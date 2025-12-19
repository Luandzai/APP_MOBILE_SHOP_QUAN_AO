// server/src/controllers/returnsController.js (HOÀN CHỈNH: USER + ADMIN FUNCTIONS)
const pool = require("../config/db");

// @desc    Người dùng tạo yêu cầu đổi/trả
// @route   POST /api/returns
// @access  Private
exports.requestReturn = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { NguoiDungID } = req.user;
    const { DonHangID, Reason, items } = req.body;

    if (!DonHangID || !Reason || !items || items.length === 0) {
      return res
        .status(400)
        .json({ message: "Vui lòng cung cấp đầy đủ thông tin." });
    }

    // 1. Kiểm tra đơn hàng thuộc về user và trạng thái hợp lệ
    const [orderRows] = await connection.query(
      `SELECT DonHangID, TrangThai, NgayCapNhat 
       FROM donhang 
       WHERE DonHangID = ? AND NguoiDungID = ?`,
      [DonHangID, NguoiDungID]
    );
    
    if (orderRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng." });
    }
    
    const order = orderRows[0];
    
    // Kiểm tra đơn hàng đã giao chưa
    if (order.TrangThai !== "DA_GIAO") {
      return res.status(400).json({ 
        message: "Chỉ có thể yêu cầu đổi/trả cho đơn hàng đã giao thành công." 
      });
    }
    
    // Kiểm tra thời hạn đổi/trả (7 ngày kể từ ngày cập nhật trạng thái DA_GIAO)
    const RETURN_DEADLINE_DAYS = 7;
    const deliveredDate = new Date(order.NgayCapNhat);
    const now = new Date();
    const daysSinceDelivery = Math.floor((now - deliveredDate) / (1000 * 60 * 60 * 24));
    
    if (daysSinceDelivery > RETURN_DEADLINE_DAYS) {
      return res.status(400).json({ 
        message: `Đã quá thời hạn đổi/trả hàng (${RETURN_DEADLINE_DAYS} ngày kể từ ngày giao).` 
      });
    }

    // 2. Kiểm tra trùng lặp
    const [existingReturns] = await connection.query(
      "SELECT * FROM returns WHERE DonHangID = ?",
      [DonHangID]
    );

    if (existingReturns.length > 0) {
      return res
        .status(400)
        .json({ message: "Bạn đã gửi yêu cầu đổi/trả cho đơn hàng này rồi." });
    }

    await connection.beginTransaction();

    // 2. Tạo Phiếu Trả Hàng (Returns)
    const [returnResult] = await connection.query(
      "INSERT INTO returns (DonHangID, Reason, Status) VALUES (?, ?, 'PENDING')",
      [DonHangID, Reason]
    );
    const newReturnID = returnResult.insertId;

    // 3. Thêm các sản phẩm vào ChiTietReturns
    for (const item of items) {
      if (
        !item.PhienBanID ||
        !item.SoLuongTra ||
        item.SoLuongTra <= 0 ||
        !item.GiaHoanTra
      ) {
        throw new Error("Dữ liệu sản phẩm trả không hợp lệ.");
      }

      await connection.query(
        "INSERT INTO chitietreturns (ReturnID, PhienBanID, SoLuongTra, GiaHoanTra) VALUES (?, ?, ?, ?)",
        [newReturnID, item.PhienBanID, item.SoLuongTra, item.GiaHoanTra]
      );
    }

    // 4. Kiểm tra xem người dùng có đổi trả toàn bộ sản phẩm hay không
    // Lấy danh sách sản phẩm gốc trong đơn hàng
    const [orderItems] = await connection.query(
      `SELECT PhienBanID, SoLuong FROM chitietdonhang WHERE DonHangID = ?`,
      [DonHangID]
    );

    // So sánh số lượng trả với số lượng đặt ban đầu
    let isFullReturn = true;
    for (const orderItem of orderItems) {
      const returnedItem = items.find(i => i.PhienBanID === orderItem.PhienBanID);
      // Nếu sản phẩm không được trả hoặc số lượng trả < số lượng đặt → đổi trả một phần
      if (!returnedItem || returnedItem.SoLuongTra < orderItem.SoLuong) {
        isFullReturn = false;
        break;
      }
    }

    // Nếu đổi trả toàn bộ → cập nhật trạng thái đơn hàng thành DOI_TRA
    if (isFullReturn) {
      await connection.query(
        `UPDATE donhang SET TrangThai = 'DOI_TRA', NgayCapNhat = NOW() WHERE DonHangID = ?`,
        [DonHangID]
      );
    }
    // Nếu đổi trả một phần → giữ nguyên trạng thái DA_GIAO (không làm gì cả)

    await connection.commit();
    res.status(201).json({
      message: "Đã gửi yêu cầu đổi/trả thành công. Đơn hàng đang được xử lý.",
      ReturnID: newReturnID,
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi tạo yêu cầu đổi/trả:", error);
    res.status(500).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};

// --------------------------------------------------------
// --- ADMIN FUNCTIONS ---
// --------------------------------------------------------

// @desc    Admin: Lấy danh sách yêu cầu đổi/trả (có phân trang)
// @route   GET /api/admin/returns
// @access  Private (Admin)
exports.getAllReturns = async (req, res) => {
  try {
    const { status, search, page = 1, limit = 10 } = req.query;

    let conditions = [];
    let params = [];

    if (status) {
      conditions.push("r.Status = ?");
      params.push(status);
    }

    if (search) {
      conditions.push(`(r.DonHangID LIKE ? OR nd.Email LIKE ?)`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm);
    }

    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";
    const offset = (page - 1) * limit;

    // 1. Đếm tổng số yêu cầu
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
             FROM returns r 
             JOIN donhang dh ON r.DonHangID = dh.DonHangID 
             JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
             ${whereClause}`,
      params
    );
    const total = countResult[0].total;
    const totalPages = Math.ceil(total / limit);

    // 2. Lấy dữ liệu yêu cầu
    const [returnsList] = await pool.query(
      `SELECT 
                r.ReturnID, r.DonHangID, r.Status, r.NgayYeuCau, r.RefundAmount,
                nd.HoTen AS TenKhachHang, nd.Email
             FROM returns r
             JOIN donhang dh ON r.DonHangID = dh.DonHangID
             JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
             ${whereClause}
             ORDER BY r.NgayYeuCau DESC
             LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      returns: returnsList,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách yêu cầu đổi/trả:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Lấy chi tiết một yêu cầu đổi/trả
// @route   GET /api/admin/returns/:id
// @access  Private (Admin)
exports.getReturnDetail = async (req, res) => {
  try {
    const { id: ReturnID } = req.params;

    // 1. Lấy thông tin phiếu trả hàng và đơn hàng liên quan
    const [returnRows] = await pool.query(
      `SELECT 
                r.*, dh.TongThanhToan, dh.NgayDatHang, 
                nd.HoTen AS TenKhachHang, nd.Email, 
                dc.DiaChiChiTiet
             FROM returns r
             JOIN donhang dh ON r.DonHangID = dh.DonHangID
             JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
             JOIN diachigiaohang dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
             WHERE r.ReturnID = ?`,
      [ReturnID]
    );
    if (returnRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy yêu cầu." });
    }
    const returnDetail = returnRows[0];

    // 2. Lấy chi tiết sản phẩm được trả/đổi
    const [items] = await pool.query(
      `SELECT 
                ctr.PhienBanID, ctr.SoLuongTra, ctr.GiaHoanTra, 
                sp.TenSanPham, sp.Slug, 
                (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
                 FROM chitietphienban AS ctpb
                 JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
                 JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
                 WHERE ctpb.PhienBanID = ctr.PhienBanID
                ) AS ThuocTinh
             FROM chitietreturns ctr
             JOIN phienbansanpham pb ON ctr.PhienBanID = pb.PhienBanID
             JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
             WHERE ctr.ReturnID = ?`,
      [ReturnID]
    );

    res.json({ ...returnDetail, items });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết yêu cầu đổi/trả:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Cập nhật trạng thái yêu cầu đổi/trả
// @route   PUT /api/admin/returns/:id/status
// @access  Private (Admin)
exports.updateReturnStatus = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id: ReturnID } = req.params;
    const { newStatus, refundAmount, restoreInventory } = req.body;
    const AdminID = req.user.NguoiDungID;

    // 1. Kiểm tra trạng thái hợp lệ
    if (!["APPROVED", "REJECTED", "COMPLETED"].includes(newStatus)) {
      return res.status(400).json({ message: "Trạng thái không hợp lệ." });
    }

    await connection.beginTransaction();

    // 2. Lấy thông tin yêu cầu hiện tại
    const [returns] = await connection.query(
      "SELECT ReturnID, DonHangID, Status, RefundAmount FROM returns WHERE ReturnID = ?",
      [ReturnID]
    );
    if (returns.length === 0)
      throw new Error("Không tìm thấy yêu cầu hoàn trả.");
    const currentReturn = returns[0];

    if (
      currentReturn.Status !== "PENDING" &&
      currentReturn.Status !== "APPROVED"
    ) {
      throw new Error(
        `Yêu cầu đã được xử lý ở trạng thái: ${currentReturn.Status}`
      );
    }

    // 3. Xử lý logic theo trạng thái mới
    let updateQuery =
      "UPDATE returns SET Status = ?, NgayCapNhat = NOW(), NguoiCapNhat = ?";
    let updateParams = [newStatus, AdminID];

    if (newStatus === "APPROVED") {
      // Phê duyệt: Thêm số tiền hoàn trả. Đơn hàng gốc vẫn giữ trạng thái DOI_TRA.
      if (refundAmount === undefined || refundAmount < 0) {
        throw new Error("Vui lòng cung cấp số tiền hoàn trả hợp lệ.");
      }
      updateQuery += ", RefundAmount = ?";
      updateParams.push(refundAmount);
    } else if (newStatus === "REJECTED") {
      // TỪ CHỐI: Hoàn tác trạng thái đơn hàng gốc về DA_GIAO (Đơn hàng được coi là giao dịch thành công)
      await connection.query(
        "UPDATE donhang SET TrangThai = 'DA_GIAO', NgayCapNhat = NOW(), NguoiCapNhat = ? WHERE DonHangID = ?",
        [AdminID, currentReturn.DonHangID]
      );
    } else if (newStatus === "COMPLETED") {
      // HOÀN TIỀN THÀNH CÔNG: Giữ nguyên trạng thái đơn hàng gốc là DOI_TRA
      if (
        currentReturn.RefundAmount === null ||
        currentReturn.RefundAmount === undefined ||
        currentReturn.Status !== "APPROVED"
      ) {
        throw new Error(
          "Yêu cầu cần được phê duyệt (APPROVED) và có số tiền hoàn trả trước khi hoàn tất."
        );
      }

      // 4. Nếu admin xác nhận hàng còn nguyên vẹn, cập nhật tồn kho
      if (restoreInventory === true) {
        // Lấy danh sách sản phẩm trả từ chitietreturns
        const [returnItems] = await connection.query(
          "SELECT PhienBanID, SoLuongTra FROM chitietreturns WHERE ReturnID = ?",
          [ReturnID]
        );

        // Cộng lại số lượng trả vào tồn kho của từng phiên bản sản phẩm
        for (const item of returnItems) {
          await connection.query(
            "UPDATE phienbansanpham SET SoLuongTonKho = SoLuongTonKho + ? WHERE PhienBanID = ?",
            [item.SoLuongTra, item.PhienBanID]
          );
        }
      }
    }

    updateQuery += " WHERE ReturnID = ?";
    updateParams.push(ReturnID);

    await connection.query(updateQuery, updateParams);

    await connection.commit();

    res.json({
      message: `Đã cập nhật trạng thái yêu cầu #${ReturnID} thành ${newStatus}.`,
      newStatus: newStatus,
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi cập nhật trạng thái yêu cầu đổi/trả:", error);
    res.status(400).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};
