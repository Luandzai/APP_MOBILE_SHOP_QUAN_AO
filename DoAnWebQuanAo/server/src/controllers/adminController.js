// server/src/controllers/adminController.js
const pool = require("../config/db");

// @desc    Admin: Lấy dữ liệu thống kê cho Dashboard
// @route   GET /api/admin/dashboard-stats
// @access  Private (Admin)
exports.getDashboardStats = async (req, res) => {
  try {
    // 1. DOANH SỐ THÁNG HIỆN TẠI (Đơn hàng đã giao - trừ số tiền đã hoàn trả)
    const [salesResult] = await pool.query(
      `SELECT 
         SUM(dh.TongThanhToan) - COALESCE(SUM(r.RefundAmount), 0) AS totalSales 
       FROM donhang dh
       LEFT JOIN returns r ON dh.DonHangID = r.DonHangID AND r.Status = 'COMPLETED'
       WHERE dh.TrangThai IN ('DA_GIAO', 'DOI_TRA')
         AND MONTH(dh.NgayDatHang) = MONTH(NOW()) 
         AND YEAR(dh.NgayDatHang) = YEAR(NOW())`
    );
    const totalSales = parseFloat(salesResult[0].totalSales) || 0;

    // 2. SỐ LƯỢNG ĐƠN HÀNG MỚI (Trạng thái DANG_XU_LY)
    const [newOrdersResult] = await pool.query(
      `SELECT COUNT(*) AS newOrdersCount 
       FROM donhang 
       WHERE TrangThai = 'DANG_XU_LY'`
    );
    const newOrdersCount = newOrdersResult[0].newOrdersCount || 0;

    // 3. SẢN PHẨM TỒN KHO THẤP (Tồn kho <= 10)
    const LOW_STOCK_THRESHOLD = 10;
    const [lowStockResult] = await pool.query(
      `SELECT COUNT(*) AS lowStockCount 
       FROM phienbansanpham 
       WHERE SoLuongTonKho <= ?`,
      [LOW_STOCK_THRESHOLD]
    );
    const lowStockCount = lowStockResult[0].lowStockCount || 0;

    // 4. TỔNG SỐ NGƯỜI DÙNG
    const [totalUsersResult] = await pool.query(
      `SELECT COUNT(*) AS totalUsersCount FROM nguoidung WHERE VaiTro = 'KHACHHANG'`
    );
    const totalUsersCount = totalUsersResult[0].totalUsersCount || 0;

    // 5. DANH SÁCH ĐƠN HÀNG MỚI (5 đơn gần nhất)
    const [latestOrders] = await pool.query(
      `SELECT dh.DonHangID, dh.NgayDatHang, dh.TongThanhToan, dh.TrangThai, nd.HoTen
         FROM donhang AS dh
         JOIN nguoidung AS nd ON dh.NguoiDungID = nd.NguoiDungID
         WHERE dh.TrangThai IN ('DANG_XU_LY', 'CHUA_THANH_TOAN') 
         ORDER BY dh.NgayDatHang DESC
         LIMIT 5`
    );

    // 6. TOP 10 SẢN PHẨM BÁN CHẠY NHẤT (dựa trên số lượng đã bán)
    const [topSellingProducts] = await pool.query(
      `SELECT 
         sp.TenSanPham, 
         sp.Slug,
         SUM(ctdh.SoLuong) AS totalSold,
         SUM(ctdh.SoLuong * ctdh.GiaLucMua) AS totalRevenue
       FROM chitietdonhang AS ctdh
       JOIN phienbansanpham AS pb ON ctdh.PhienBanID = pb.PhienBanID
       JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
       JOIN donhang AS dh ON ctdh.DonHangID = dh.DonHangID
       WHERE dh.TrangThai = 'DA_GIAO'
       GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug
       ORDER BY totalSold DESC
       LIMIT 10`
    );

    // 7. TOP 10 SẢN PHẨM TỒN KHO THẤP NHẤT
    const [lowStockProducts] = await pool.query(
      `SELECT sp.TenSanPham, sp.Slug, SUM(pb.SoLuongTonKho) as totalStock
       FROM sanpham sp
       JOIN phienbansanpham pb ON sp.SanPhamID = pb.SanPhamID
       GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug
       HAVING totalStock >= 0
       ORDER BY totalStock ASC
       LIMIT 10`
    );

    // 8. KHÁCH HÀNG TIỀM NĂNG NHẤT (chi tiêu nhiều nhất)
    const [topCustomerResult] = await pool.query(
      `SELECT nd.HoTen, nd.Email, SUM(dh.TongThanhToan) as totalSpent
       FROM donhang dh
       JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
       WHERE dh.TrangThai = 'DA_GIAO'
       GROUP BY nd.NguoiDungID, nd.HoTen, nd.Email
       ORDER BY totalSpent DESC
       LIMIT 1`
    );

    res.json({
      totalSales: totalSales,
      newOrdersCount: newOrdersCount,
      lowStockCount: lowStockCount,
      totalUsersCount: totalUsersCount, // Thêm vào đây
      latestOrders: latestOrders,
      topSellingProducts: topSellingProducts,
      lowStockProducts: lowStockProducts,
      topCustomer: topCustomerResult.length > 0 ? topCustomerResult[0] : null,
    });
  } catch (error) {
    console.error("Lỗi khi lấy dữ liệu Dashboard:", error);
    res.status(500).json({ message: "Lỗi server khi lấy thống kê" });
  }
};

// @desc    Admin: Lấy TẤT CẢ người dùng (có phân trang, tìm kiếm, lọc)
// @route   GET /api/admin/users
// @access  Private (Admin)
exports.getAllUsers = async (req, res) => {
  try {
    const {
      search,
      role, // KHACHHANG | ADMIN
      status, // ACTIVE | INACTIVE
      sortBy = "DATE_DESC",
      page = 1,
      limit = 10,
    } = req.query;

    let conditions = [];
    let params = [];

    // Điều kiện tìm kiếm (HoTen, Email, DienThoai, GoogleID)
    if (search) {
      conditions.push(`(
        HoTen LIKE ? OR
        Email LIKE ? OR
        DienThoai LIKE ? OR
        GoogleID LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    // Điều kiện vai trò (Role)
    if (role) {
      conditions.push("VaiTro = ?");
      params.push(role);
    }

    // Điều kiện trạng thái (Status)
    if (status) {
      conditions.push("TrangThai = ?");
      params.push(status);
    }

    // Tạo WHERE clause
    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    // ORDER BY clause
    const sortOrder =
      {
        DATE_DESC: "NgayTao DESC",
        DATE_ASC: "NgayTao ASC",
        NAME_ASC: "HoTen ASC",
        NAME_DESC: "HoTen DESC",
      }[sortBy] || "NgayTao DESC";

    // Tính toán OFFSET
    const offset = (Number(page) - 1) * Number(limit);

    // 1. Đếm tổng số người dùng
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total FROM nguoidung ${whereClause}`,
      params
    );

    const total = countResult[0].total;
    const totalPages = Math.ceil(total / Number(limit));

    // 2. Query chính để lấy danh sách người dùng
    const [users] = await pool.query(
      `SELECT 
        NguoiDungID, Email, LoaiXacThuc, HoTen, DienThoai, 
        VaiTro, TrangThai, NgayTao
       FROM nguoidung
       ${whereClause}
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      users,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách người dùng Admin:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách người dùng",
      error: error.message,
    });
  }
};

// @desc    Admin: Cập nhật trạng thái người dùng (ACTIVE/INACTIVE)
// @route   PUT /api/admin/users/:id/status
// @access  Private (Admin)
exports.updateUserStatus = async (req, res) => {
  try {
    const { id: NguoiDungID } = req.params;
    const { trangThaiMoi } = req.body;
    const AdminID = req.user.NguoiDungID; // Lấy ID Admin từ middleware

    // 1. Kiểm tra trạng thái hợp lệ
    if (!["ACTIVE", "INACTIVE"].includes(trangThaiMoi)) {
      return res.status(400).json({ message: "Trạng thái không hợp lệ." });
    }

    // 2. Không cho phép Admin tự khóa tài khoản của mình
    if (parseInt(NguoiDungID) === AdminID) {
      return res.status(400).json({
        message: "Không thể tự thay đổi trạng thái tài khoản Admin của mình.",
      });
    }

    // 3. Cập nhật trạng thái trong DB
    const [result] = await pool.query(
      `UPDATE nguoidung SET TrangThai = ? WHERE NguoiDungID = ?`,
      [trangThaiMoi, NguoiDungID]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng." });
    }

    res.json({
      message: `Đã cập nhật trạng thái người dùng #${NguoiDungID} thành công.`,
      newStatus: trangThaiMoi,
    });
  } catch (error) {
    console.error("Lỗi khi cập nhật trạng thái người dùng:", error);
    res.status(500).json({ message: "Lỗi server khi cập nhật trạng thái" });
  }
};

// @desc    Admin: Cập nhật vai trò người dùng (KHACHHANG/ADMIN)
// @route   PUT /api/admin/users/:id/role
// @access  Private (Admin)
exports.updateUserRole = async (req, res) => {
  try {
    const { id: NguoiDungID } = req.params;
    const { vaiTroMoi } = req.body;
    const AdminID = req.user.NguoiDungID;

    // 1. Kiểm tra vai trò hợp lệ
    if (!["KHACHHANG", "ADMIN"].includes(vaiTroMoi)) {
      return res.status(400).json({ message: "Vai trò không hợp lệ." });
    }

    // 2. Không cho phép Admin tự thay đổi vai trò của mình
    if (parseInt(NguoiDungID) === AdminID) {
      return res
        .status(400)
        .json({ message: "Không thể tự thay đổi vai trò Admin của mình." });
    }

    // 3. Cập nhật vai trò trong DB
    const [result] = await pool.query(
      `UPDATE nguoidung SET VaiTro = ? WHERE NguoiDungID = ?`,
      [vaiTroMoi, NguoiDungID]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng." });
    }

    res.json({
      message: `Đã cập nhật vai trò người dùng #${NguoiDungID} thành ${vaiTroMoi} thành công.`,
      newRole: vaiTroMoi,
    });
  } catch (error) {
    console.error("Lỗi khi cập nhật vai trò người dùng:", error);
    res.status(500).json({ message: "Lỗi server khi cập nhật vai trò" });
  }
};

// @desc    Admin: Lấy doanh thu theo tháng của một năm cụ thể
// @route   GET /api/admin/sales/monthly?year=YYYY
// @access  Private (Admin)
exports.getMonthlySales = async (req, res) => {
  try {
    const targetYear = parseInt(req.query.year) || new Date().getFullYear();

    const [monthlySales] = await pool.query(
      `
      SELECT 
          MONTH(dh.NgayDatHang) AS month,
          SUM(dh.TongThanhToan) - COALESCE(SUM(r.RefundAmount), 0) AS totalRevenue
      FROM donhang dh
      LEFT JOIN returns r ON dh.DonHangID = r.DonHangID AND r.Status = 'COMPLETED'
      WHERE 
          dh.TrangThai IN ('DA_GIAO', 'DOI_TRA') AND YEAR(dh.NgayDatHang) = ?
      GROUP BY 
          MONTH(dh.NgayDatHang)
      ORDER BY 
          month ASC
      `,
      [targetYear]
    );

    const formattedSales = Array.from({ length: 12 }, (_, i) => ({
      month: i + 1,
      revenue: 0,
    }));

    monthlySales.forEach((item) => {
      const monthIndex = item.month - 1;
      formattedSales[monthIndex].revenue = parseFloat(item.totalRevenue) || 0;
    });

    res.json({
      year: targetYear,
      salesData: formattedSales,
      message: `Dữ liệu doanh thu năm ${targetYear} đã sẵn sàng.`,
    });
  } catch (error) {
    console.error("Lỗi khi lấy dữ liệu doanh thu theo tháng:", error);
    res.status(500).json({ message: "Lỗi server khi lấy dữ liệu biểu đồ" });
  }
};
