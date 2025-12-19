// server/src/controllers/orderController.js
const pool = require("../config/db");
// 1. IMPORT TIỆN ÍCH VNPAY VÀ MOMO
const { createPaymentUrl } = require("../utils/vnpay");
const { createPaymentRequest } = require("../utils/momo");
// Import hằng số timeout từ scheduler
const { PAYMENT_TIMEOUT_MINUTES } = require("../utils/orderScheduler");

// @desc    Tạo đơn hàng mới
exports.createOrder = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const {
      shippingInfo,
      paymentMethodId, // ID 701 (COD), 702 (VNPAY), 703 (MOMO)
      notes,
      cartItems,
      MaKhuyenMai,
      PhuongThucID,
    } = req.body;
    const {
      TenNguoiNhan,
      DienThoaiNhan,
      SoNha,
      PhuongXa,
      QuanHuyen,
      TinhThanh,
    } = shippingInfo;
    const DiaChiChiTiet = `${SoNha}, ${PhuongXa}, ${QuanHuyen}, ${TinhThanh}`;
    if (!TenNguoiNhan || !DienThoaiNhan || !SoNha || !PhuongXa) {
      return res
        .status(400)
        .json({ message: "Vui lòng điền đầy đủ thông tin giao hàng." });
    }
    const [addrResult] = await connection.query(
      `INSERT INTO diachigiaohang (NguoiDungID, TenNguoiNhan, DienThoaiNhan, DiaChiChiTiet, PhuongXa, QuanHuyen, TinhThanh, MacDinh) 
       VALUES (?, ?, ?, ?, ?, ?, ?, 0)`,
      [
        NguoiDungID,
        TenNguoiNhan,
        DienThoaiNhan,
        DiaChiChiTiet,
        PhuongXa,
        QuanHuyen,
        TinhThanh,
      ]
    );
    const newDiaChiID = addrResult.insertId;

    await connection.beginTransaction();

    let TongTienHang = 0;
    const phienBanIDs = cartItems.map((item) => item.PhienBanID);
    if (phienBanIDs.length === 0) {
      await connection.rollback();
      return res.status(400).json({ message: "Giỏ hàng trống." });
    }
    // JOIN với sanpham để kiểm tra trạng thái sản phẩm
    const [dbItems] = await connection.query(
      `SELECT pb.PhienBanID, pb.GiaBan, pb.SoLuongTonKho, pb.SanPhamID, 
              sp.TenSanPham, sp.TrangThai 
       FROM phienbansanpham pb
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       WHERE pb.PhienBanID IN (?)`,
      [phienBanIDs]
    );
    for (const item of cartItems) {
      const dbItem = dbItems.find((p) => p.PhienBanID === item.PhienBanID);
      if (!dbItem)
        throw new Error(`Sản phẩm ID ${item.PhienBanID} không tồn tại.`);
      // Kiểm tra sản phẩm có đang ACTIVE không
      if (dbItem.TrangThai !== "ACTIVE")
        throw new Error(`Sản phẩm "${dbItem.TenSanPham}" không còn được bán.`);
      if (dbItem.SoLuongTonKho < item.SoLuong)
        throw new Error(`Sản phẩm "${dbItem.TenSanPham}" không đủ tồn kho.`);
      TongTienHang += dbItem.GiaBan * item.SoLuong;
    }

    let PhiVanChuyen = 0;
    if (PhuongThucID) {
      const [shipMethod] = await connection.query(
        "SELECT PhiCoDinh FROM phuongthucvanchuyen WHERE PhuongThucID = ?",
        [PhuongThucID]
      );
      if (shipMethod.length > 0)
        PhiVanChuyen = parseFloat(shipMethod[0].PhiCoDinh);
    }

    // Logic Voucher
    let GiamGia = 0;
    if (MaKhuyenMai) {
      const [myVoucher] = await connection.query(
        `SELECT * FROM nguoidung_voucher 
         WHERE NguoiDungID = ? AND MaKhuyenMai = ? AND TrangThai = 'DA_NHAN'`,
        [NguoiDungID, MaKhuyenMai]
      );
      if (myVoucher.length === 0) {
        throw new Error("Mã giảm giá không hợp lệ hoặc đã được sử dụng.");
      }

      const [vouchers] = await connection.query(
        "SELECT * FROM khuyenmai WHERE MaKhuyenMai = ? AND NgayKetThuc > NOW() AND ApDungToiThieu <= ? AND SoLuongToiDa > 0",
        [MaKhuyenMai, TongTienHang]
      );
      if (vouchers.length === 0) {
        throw new Error(
          "Mã giảm giá đã hết hạn, hết lượt sử dụng hoặc không đủ điều kiện."
        );
      }

      const voucher = vouchers[0];
      
      // Kiểm tra voucher có áp dụng cho sản phẩm/danh mục cụ thể không
      if (voucher.SanPhamID || voucher.DanhMucID) {
        // Lấy danh sách SanPhamID và DanhMucID từ các sản phẩm trong đơn hàng
        const sanPhamIDs = dbItems.map(item => item.SanPhamID);
        const [productCategories] = await connection.query(
          "SELECT SanPhamID, DanhMucID FROM sanpham WHERE SanPhamID IN (?)",
          [sanPhamIDs]
        );
        const danhMucIDs = productCategories.map(p => p.DanhMucID);
        
        // Kiểm tra voucher cho sản phẩm cụ thể
        if (voucher.SanPhamID && !sanPhamIDs.includes(voucher.SanPhamID)) {
          throw new Error("Mã giảm giá không áp dụng cho sản phẩm trong đơn hàng.");
        }
        
        // Kiểm tra voucher cho danh mục
        if (voucher.DanhMucID && !voucher.SanPhamID) {
          // Lấy DanhMucChaID của các danh mục sản phẩm
          const [categories] = await connection.query(
            "SELECT DanhMucID, DanhMucChaID FROM danhmuc WHERE DanhMucID IN (?)",
            [danhMucIDs]
          );
          const allDanhMucIDs = [...danhMucIDs, ...categories.map(c => c.DanhMucChaID).filter(id => id !== null)];
          
          if (!allDanhMucIDs.includes(voucher.DanhMucID)) {
            throw new Error("Mã giảm giá không áp dụng cho danh mục sản phẩm trong đơn hàng.");
          }
        }
      }
      // Nếu cả SanPhamID và DanhMucID đều NULL -> voucher toàn sàn, áp dụng bình thường
      
      if (voucher.LoaiGiamGia === "SOTIEN")
        GiamGia = parseFloat(voucher.GiaTriGiam);
      if (voucher.LoaiGiamGia === "PHANTRAM")
        GiamGia = (TongTienHang * parseFloat(voucher.GiaTriGiam)) / 100;

      await connection.query(
        "UPDATE nguoidung_voucher SET TrangThai = 'DA_SU_DUNG' WHERE NguoiDungID = ? AND MaKhuyenMai = ?",
        [NguoiDungID, MaKhuyenMai]
      );
      await connection.query(
        "UPDATE khuyenmai SET SoLuongToiDa = SoLuongToiDa - 1 WHERE MaKhuyenMai = ?",
        [MaKhuyenMai]
      );
    }
    const TongThanhToan = TongTienHang + PhiVanChuyen - GiamGia;

    const isOnlinePayment =
      paymentMethodId == "702" || paymentMethodId == "703";
    const initialTrangThai = isOnlinePayment ? "CHUA_THANH_TOAN" : "DANG_XU_LY";

    const [orderResult] = await connection.query(
      "INSERT INTO donhang (NguoiDungID, DiaChiGiaoHangID, MaKhuyenMai, PhuongThucID, TongTienHang, PhiVanChuyen, TongThanhToan, TrangThai, GhiChu) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        NguoiDungID,
        newDiaChiID,
        MaKhuyenMai,
        PhuongThucID,
        TongTienHang,
        PhiVanChuyen,
        TongThanhToan,
        initialTrangThai,
        notes,
      ]
    );
    const newDonHangID = orderResult.insertId;

    for (const item of cartItems) {
      const dbItem = dbItems.find((p) => p.PhienBanID === item.PhienBanID);
      await connection.query(
        "INSERT INTO chitietdonhang (DonHangID, PhienBanID, SoLuong, GiaLucMua) VALUES (?, ?, ?, ?)",
        [newDonHangID, item.PhienBanID, item.SoLuong, dbItem.GiaBan]
      );
      
      // Giảm tồn kho ngay khi đặt hàng
      await connection.query(
        "UPDATE phienbansanpham SET SoLuongTonKho = SoLuongTonKho - ? WHERE PhienBanID = ?",
        [item.SoLuong, item.PhienBanID]
      );
    }
    await connection.query(
      'INSERT INTO thanhtoan (DonHangID, MethodID, SoTienThanhToan, TrangThai) VALUES (?, ?, ?, "PENDING")',
      [newDonHangID, paymentMethodId, TongThanhToan]
    );

    const orderedPhienBanIDs = cartItems.map((item) => item.PhienBanID);
    if (orderedPhienBanIDs.length > 0) {
      await connection.query(
        "DELETE FROM chitietgiohang WHERE GioHangID = ? AND PhienBanID IN (?)",
        [NguoiDungID, orderedPhienBanIDs]
      );
    }

    await connection.commit();

    if (paymentMethodId == "702") {
      const ipAddr =
        req.headers["x-forwarded-for"] ||
        req.connection.remoteAddress ||
        req.socket.remoteAddress ||
        (req.connection.socket ? req.connection.socket.remoteAddress : null);

      const paymentUrl = createPaymentUrl(
        newDonHangID,
        TongThanhToan,
        ipAddr,
        `Thanh toan don hang ${newDonHangID}`
      );

      res.status(201).json({
        message: "Đơn hàng đã được tạo, đang chuyển hướng...",
        DonHangID: newDonHangID,
        paymentUrl: paymentUrl,
      });
    } else if (paymentMethodId == "703") {
      const momoResponse = await createPaymentRequest(
        newDonHangID,
        TongThanhToan,
        `Thanh toan don hang ${newDonHangID}`
      );

      res.status(201).json({
        message: "Đơn hàng đã được tạo, đang chuyển hướng...",
        DonHangID: newDonHangID,
        paymentUrl: momoResponse.payUrl,
      });
    } else {
      res
        .status(201)
        .json({ message: "Đặt hàng thành công!", DonHangID: newDonHangID });
    }
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi đặt hàng:", error);
    res
      .status(500)
      .json({ message: error.message || "Lỗi server khi đặt hàng" });
  } finally {
    connection.release();
  }
};

// @desc    Lấy danh sách đơn hàng của người dùng
exports.getMyOrders = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;

    const [orders] = await pool.query(
      `SELECT 
         dh.DonHangID, dh.NgayDatHang, dh.TongThanhToan, dh.TrangThai,
         tt.MethodID,
         (EXISTS (SELECT 1 FROM returns r WHERE r.DonHangID = dh.DonHangID)) AS DaYeuCauTraHang
       FROM donhang AS dh
       LEFT JOIN thanhtoan AS tt ON dh.DonHangID = tt.DonHangID
       WHERE dh.NguoiDungID = ? 
       ORDER BY dh.NgayDatHang DESC`,
      [NguoiDungID]
    );

    const orderDetails = await Promise.all(
      orders.map(async (order) => {
        const [items] = await pool.query(
          `SELECT 
           ctdh.PhienBanID, ctdh.SoLuong, ctdh.GiaLucMua, 
           sp.TenSanPham, 
           (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
            FROM chitietphienban AS ctpb
            JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
            JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
            WHERE ctpb.PhienBanID = ctdh.PhienBanID
           ) AS ThuocTinh,
           (SELECT HinhAnh.URL FROM hinhanhsanpham AS HinhAnh 
            WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
            LIMIT 1) as HinhAnh,
           (EXISTS (
             SELECT 1 FROM danhgia dg 
             WHERE dg.PhienBanID = ctdh.PhienBanID AND dg.NguoiDungID = ?
           )) AS DaDanhGia
         FROM chitietdonhang AS ctdh
         JOIN phienbansanpham AS pb ON ctdh.PhienBanID = pb.PhienBanID
         JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
         WHERE ctdh.DonHangID = ?`,
          [NguoiDungID, order.DonHangID]
        );
        return { ...order, items: items };
      })
    );

    res.json(orderDetails);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Xem chi tiết đơn hàng (User) - Đã BỎ VanChuyen
exports.getOrderById = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const DonHangID = req.params.id;
    const [orderRows] = await pool.query(
      `SELECT dh.*, dc.TenNguoiNhan, dc.DienThoaiNhan, dc.DiaChiChiTiet, 
              ptt.TenPhuongThuc AS TenPhuongThucThanhToan
       FROM donhang AS dh
       LEFT JOIN diachigiaohang AS dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
       LEFT JOIN thanhtoan AS tt ON dh.DonHangID = tt.DonHangID
       LEFT JOIN paymentmethods AS ptt ON tt.MethodID = ptt.MethodID
       WHERE dh.DonHangID = ? AND dh.NguoiDungID = ?`,
      [DonHangID, NguoiDungID]
    );
    if (orderRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng" });
    }
    const order = orderRows[0];

    const [items] = await pool.query(
      `SELECT 
         ctdh.*, sp.TenSanPham, sp.Slug, pb.SKU, 
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
            FROM chitietphienban AS ctpb
            JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
            JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
            WHERE ctpb.PhienBanID = ctdh.PhienBanID
           ) AS ThuocTinh,
         (SELECT HinhAnh.URL FROM hinhanhsanpham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnh
       FROM chitietdonhang AS ctdh
       JOIN phienbansanpham AS pb ON ctdh.PhienBanID = pb.PhienBanID
       JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE ctdh.DonHangID = ?`,
      [DonHangID]
    );

    res.json({ ...order, items });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Hủy đơn hàng (User)
exports.cancelOrder = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id: DonHangID } = req.params;
    const { NguoiDungID } = req.user;
    await connection.beginTransaction();
    const [orderRows] = await connection.query(
      "SELECT * FROM donhang WHERE DonHangID = ? AND NguoiDungID = ?",
      [DonHangID, NguoiDungID]
    );
    if (orderRows.length === 0) throw new Error("Không tìm thấy đơn hàng.");
    const order = orderRows[0];

    // Lấy phương thức thanh toán
    const [paymentRows] = await connection.query(
      "SELECT MethodID FROM thanhtoan WHERE DonHangID = ?",
      [DonHangID]
    );
    const paymentMethodId = paymentRows.length > 0 ? paymentRows[0].MethodID : null;

    if (order.TrangThai === "CHUA_THANH_TOAN") {
      // Cho phép hủy đơn chưa thanh toán
    } else if (order.TrangThai === "DANG_XU_LY") {
      // Chỉ cho phép hủy COD (MethodID = 701) khi đang xử lý
      if (paymentMethodId != 701) {
        throw new Error(
          "Không thể hủy đơn hàng đã thanh toán online. Vui lòng liên hệ hỗ trợ."
        );
      }
    } else {
      throw new Error(
        "Chỉ có thể hủy đơn hàng ở trạng thái 'Đang xử lý' hoặc 'Chưa thanh toán'."
      );
    }
    await connection.query(
      "UPDATE donhang SET TrangThai = 'DA_HUY' WHERE DonHangID = ?",
      [DonHangID]
    );

    await connection.query(
      "UPDATE thanhtoan SET TrangThai = 'FAILED' WHERE DonHangID = ?",
      [DonHangID]
    );

    // Hoàn tồn kho khi hủy đơn
    const [items] = await connection.query(
      "SELECT PhienBanID, SoLuong FROM chitietdonhang WHERE DonHangID = ?",
      [DonHangID]
    );
    for (const item of items) {
      await connection.query(
        "UPDATE phienbansanpham SET SoLuongTonKho = SoLuongTonKho + ? WHERE PhienBanID = ?",
        [item.SoLuong, item.PhienBanID]
      );
    }

    await connection.commit();
    res.json({ message: "Đã hủy đơn hàng thành công!" });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi hủy đơn hàng:", error);
    res.status(400).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};

// --- ADMIN FUNCTIONS ---

// @desc    Admin: Lấy TẤT CẢ đơn hàng
exports.getAllOrders = async (req, res) => {
  try {
    const {
      search,
      status,
      sortBy = "DATE_DESC",
      page = 1,
      limit = 10,
    } = req.query;

    let conditions = [];
    let params = [];

    if (search) {
      conditions.push(`(
        dh.DonHangID LIKE ? OR
        nd.HoTen LIKE ? OR
        nd.Email LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    if (status) {
      conditions.push("dh.TrangThai = ?");
      params.push(status);
    }

    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    const sortOrder =
      {
        DATE_DESC: "dh.NgayDatHang DESC",
        DATE_ASC: "dh.NgayDatHang ASC",
        TOTAL_DESC: "dh.TongThanhToan DESC",
        TOTAL_ASC: "dh.TongThanhToan ASC",
      }[sortBy] || "dh.NgayDatHang DESC";

    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
       FROM donhang dh
       JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
       ${whereClause}`,
      params
    );

    const total = countResult[0].total;
    const offset = (page - 1) * limit;

    const [orders] = await pool.query(
      `SELECT 
        dh.*,
        nd.HoTen,
        nd.Email,
        dc.TenNguoiNhan,
        dc.DienThoaiNhan,
        dc.DiaChiChiTiet
       FROM donhang dh
       JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
       LEFT JOIN diachigiaohang dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
       ${whereClause}
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      orders,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đơn hàng:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách đơn hàng",
      error: error.message,
    });
  }
};

// @desc    Admin: Xem chi tiết đơn hàng - Đã BỎ VanChuyen
exports.getAdminOrderDetail = async (req, res) => {
  try {
    const orderId = req.params.id;

    const [orders] = await pool.query(
      `SELECT 
        dh.*,
        nd.HoTen AS TenKhachHang, nd.Email AS EmailKhachHang,
        dc.TenNguoiNhan, dc.DienThoaiNhan, dc.DiaChiChiTiet,
        ptvc.TenPhuongThuc,
        km.MaKhuyenMai, km.TenKhuyenMai, km.GiaTriGiam, km.LoaiGiamGia,
        uc.HoTen AS NguoiCapNhatTen
      FROM donhang dh
      JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
      LEFT JOIN diachigiaohang dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
      LEFT JOIN phuongthucvanchuyen ptvc ON dh.PhuongThucID = ptvc.PhuongThucID
      LEFT JOIN khuyenmai km ON dh.MaKhuyenMai = km.MaKhuyenMai
      LEFT JOIN nguoidung uc ON dh.NguoiCapNhat = uc.NguoiDungID
      WHERE dh.DonHangID = ?`,
      [orderId]
    );

    if (orders.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Không tìm thấy đơn hàng" });
    }

    const order = orders[0];

    const [items] = await pool.query(
      `SELECT 
        ctdh.*,
        sp.TenSanPham,
        sp.Slug,
        pb.SKU,
        (
          SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
          FROM chitietphienban ctpb
          JOIN giatrithuoctinh gtt ON ctpb.GiaTriID = gtt.GiaTriID
          JOIN thuoctinh tt ON gtt.ThuocTinhID = tt.ThuocTinhID
          WHERE ctpb.PhienBanID = ctdh.PhienBanID
        ) AS ThuocTinh,
        (
          SELECT ha.URL 
          FROM hinhanhsanpham ha
          WHERE ha.SanPhamID = sp.SanPhamID AND ha.LaAnhChinh = 1
          LIMIT 1
        ) AS HinhAnh
      FROM chitietdonhang ctdh
      JOIN phienbansanpham pb ON ctdh.PhienBanID = pb.PhienBanID
      JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
      WHERE ctdh.DonHangID = ?`,
      [orderId]
    );

    const [history] = await pool.query(
      `SELECT *
       FROM lichsudonhang
       WHERE DonHangID = ?
       ORDER BY ThoiGian DESC`,
      [orderId]
    );

    res.json({
      success: true,
      data: {
        ...order,
        items,
        history,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải chi tiết đơn hàng",
      error: error.message,
    });
  }
};

// @desc    Admin: Cập nhật trạng thái đơn hàng - Đã BỎ VanChuyen
exports.updateOrderStatus = async (req, res) => {
  let connection;
  try {
    const { id } = req.params;
    const { trangThaiMoi } = req.body;
    const adminId = req.user?.NguoiDungID;

    if (!id || !trangThaiMoi || !adminId) {
      return res.status(400).json({
        success: false,
        message: "Thiếu thông tin cập nhật trạng thái",
      });
    }

    connection = await pool.getConnection();
    await connection.beginTransaction();

    try {
      const [orders] = await connection.query(
        "SELECT TrangThai FROM donhang WHERE DonHangID = ?",
        [id]
      );
      if (orders.length === 0)
        throw new Error(`Không tìm thấy đơn hàng #${id}`);
      const currentStatus = orders[0].TrangThai;

      if (currentStatus === trangThaiMoi)
        throw new Error("Đơn hàng đã ở trạng thái này");

      // Cập nhật DonHang
      await connection.query(
        "UPDATE donhang SET TrangThai = ?, NguoiCapNhat = ?, NgayCapNhat = NOW() WHERE DonHangID = ?",
        [trangThaiMoi, adminId, id]
      );

      if (trangThaiMoi === "DA_HUY") {
        await connection.query(
          "UPDATE thanhtoan SET TrangThai = 'FAILED' WHERE DonHangID = ?",
          [id]
        );
        // Hoàn tồn kho khi Admin hủy đơn
        const [items] = await connection.query(
          "SELECT PhienBanID, SoLuong FROM chitietdonhang WHERE DonHangID = ?",
          [id]
        );
        for (const item of items) {
          await connection.query(
            "UPDATE phienbansanpham SET SoLuongTonKho = SoLuongTonKho + ? WHERE PhienBanID = ?",
            [item.SoLuong, item.PhienBanID]
          );
        }
      }

      await connection.query(
        `INSERT INTO lichsudonhang (DonHangID, TrangThaiCu, TrangThaiMoi, ThoiGian, GhiChu) VALUES (?, ?, ?, NOW(), ?)`,
        [id, currentStatus, trangThaiMoi, `Cập nhật bởi Admin #${adminId}`]
      );

      await connection.commit();

      res.json({
        success: true,
        message: `Đã cập nhật trạng thái đơn hàng thành công`,
      });
    } catch (error) {
      await connection.rollback();
      throw error;
    }
  } catch (error) {
    console.error("Error updating order status:", error);
    res.status(error.message.includes("Không tìm thấy") ? 404 : 400).json({
      success: false,
      message: error.message,
    });
  } finally {
    if (connection) connection.release();
  }
};

// @desc    Thanh toán lại đơn hàng chưa thanh toán
// @route   POST /api/orders/:id/retry-payment
// @access  Private
exports.retryPayment = async (req, res) => {
  try {
    const { id: DonHangID } = req.params;
    const { NguoiDungID } = req.user;

    // Kiểm tra đơn hàng
    const [orderRows] = await pool.query(
      `SELECT dh.*, tt.MethodID 
       FROM donhang dh
       JOIN thanhtoan tt ON dh.DonHangID = tt.DonHangID
       WHERE dh.DonHangID = ? AND dh.NguoiDungID = ?`,
      [DonHangID, NguoiDungID]
    );

    if (orderRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng." });
    }

    const order = orderRows[0];

    if (order.TrangThai !== "CHUA_THANH_TOAN") {
      return res
        .status(400)
        .json({ message: "Đơn hàng không ở trạng thái chờ thanh toán." });
    }

    // Kiểm tra thời gian (đảm bảo chưa quá 15 phút)
    const orderDate = new Date(order.NgayDatHang);
    const now = new Date();
    const minutesPassed = (now - orderDate) / (1000 * 60);

    if (minutesPassed >= PAYMENT_TIMEOUT_MINUTES) {
      return res.status(400).json({
        message: `Đơn hàng đã quá ${PAYMENT_TIMEOUT_MINUTES} phút. Vui lòng đặt lại đơn hàng mới.`,
      });
    }

    // Tạo lại URL thanh toán
    if (order.MethodID == 702) {
      // VNPAY
      const ipAddr =
        req.headers["x-forwarded-for"] ||
        req.connection.remoteAddress ||
        req.socket.remoteAddress ||
        (req.connection.socket ? req.connection.socket.remoteAddress : null);

      const paymentUrl = createPaymentUrl(
        DonHangID,
        parseFloat(order.TongThanhToan),
        ipAddr,
        `Thanh toan don hang ${DonHangID}`
      );
      return res.json({ paymentUrl });
    } else if (order.MethodID == 703) {
      // MOMO
      const momoResponse = await createPaymentRequest(
        DonHangID,
        parseFloat(order.TongThanhToan),
        `Thanh toan don hang ${DonHangID}`
      );
      return res.json({ paymentUrl: momoResponse.payUrl });
    } else {
      return res
        .status(400)
        .json({ message: "Phương thức thanh toán không hỗ trợ thanh toán lại." });
    }
  } catch (error) {
    console.error("Lỗi retryPayment:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
