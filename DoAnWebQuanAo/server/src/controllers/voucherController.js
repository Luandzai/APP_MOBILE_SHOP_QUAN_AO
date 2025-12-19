// server/src/controllers/voucherController.js (HOÀN CHỈNH - ĐÃ THÊM TRANGTHAI)
const pool = require("../config/db");

// @desc    Lấy tất cả voucher CÒN HẠN và ACTIVE
// @route   GET /api/vouchers
// @access  Public
exports.getActiveVouchers = async (req, res) => {
  try {
    const [vouchers] = await pool.query(
      `SELECT MaKhuyenMai, TenKhuyenMai, NgayKetThuc, GiaTriGiam, LoaiGiamGia
       FROM khuyenmai
       WHERE NgayKetThuc > NOW() 
         AND NgayBatDau < NOW()
         AND TrangThai = 'ACTIVE'` // <<< ĐÃ THÊM ĐIỀU KIỆN TRẠNG THÁI
    );
    res.json(vouchers);
  } catch (error) {
    console.error("Lỗi khi lấy voucher:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy các voucher ACTIVE cho 1 sản phẩm
// @route   GET /api/vouchers/product/:sanPhamId
// @access  Public
exports.getVouchersForProduct = async (req, res) => {
  const { sanPhamId } = req.params;
  try {
    // 1. Lấy DanhMucID của sản phẩm
    const [productRows] = await pool.query(
      "SELECT DanhMucID FROM sanpham WHERE SanPhamID = ?",
      [sanPhamId]
    );
    if (productRows.length === 0) {
      return res.json([]);
    }
    const danhMucId = productRows[0].DanhMucID;

    // 2. Lấy DanhMucChaID của danh mục sản phẩm (nếu có)
    const [categoryRows] = await pool.query(
      "SELECT DanhMucChaID FROM danhmuc WHERE DanhMucID = ?",
      [danhMucId]
    );
    const danhMucChaId = categoryRows[0]?.DanhMucChaID || null;

    // 3. Query voucher cho: toàn sàn, sản phẩm cụ thể, danh mục sản phẩm, HOẶC danh mục cha
    const [vouchers] = await pool.query(
      `SELECT MaKhuyenMai, TenKhuyenMai, NgayKetThuc, GiaTriGiam, LoaiGiamGia
       FROM khuyenmai
       WHERE (
         (SanPhamID IS NULL AND DanhMucID IS NULL)
         OR SanPhamID = ? 
         OR DanhMucID = ? 
         OR DanhMucID = ?
       )
         AND NgayKetThuc > NOW() 
         AND NgayBatDau < NOW()
         AND TrangThai = 'ACTIVE'`,
      [sanPhamId, danhMucId, danhMucChaId]
    );

    res.json(vouchers);
  } catch (error) {
    console.error("Lỗi khi lấy voucher cho sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Người dùng "Nhận" 1 voucher (Kiểm tra ACTIVE)
// @route   POST /api/vouchers/collect
// @access  Private
exports.collectVoucher = async (req, res) => {
  const { MaKhuyenMai } = req.body;
  const { NguoiDungID } = req.user;

  if (!MaKhuyenMai) {
    return res.status(400).json({ message: "Thiếu mã khuyến mãi." });
  }

  try {
    // 1. Kiểm tra voucher có thật, còn hạn, còn số lượng VÀ ACTIVE
    const [vouchers] = await pool.query(
      `SELECT * FROM khuyenmai 
       WHERE MaKhuyenMai = ? 
         AND NgayKetThuc > NOW() 
         AND SoLuongToiDa > 0 
         AND TrangThai = 'ACTIVE'`, // <<< ĐÃ THÊM ĐIỀU KIỆN TRẠNG THÁI
      [MaKhuyenMai]
    );
    if (vouchers.length === 0) {
      return res
        .status(404)
        .json({ message: "Voucher không tồn tại, đã hết hạn, hoặc hết lượt." });
    }

    // 2. Kiểm tra xem user đã nhận voucher này CHƯA (Giữ nguyên)
    const [existing] = await pool.query(
      "SELECT * FROM nguoidung_voucher WHERE NguoiDungID = ? AND MaKhuyenMai = ?",
      [NguoiDungID, MaKhuyenMai]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: "Bạn đã nhận voucher này rồi." });
    }

    // 3. Nếu chưa có, thêm vào
    await pool.query(
      "INSERT INTO nguoidung_voucher (NguoiDungID, MaKhuyenMai, TrangThai) VALUES (?, ?, 'DA_NHAN')",
      [NguoiDungID, MaKhuyenMai]
    );

    res.status(201).json({ message: "Đã lưu voucher!" });
  } catch (error) {
    console.error("Lỗi khi lưu voucher:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Áp dụng mã giảm giá (Kiểm tra ACTIVE)
// @route   POST /api/vouchers/apply
// @access  Private
exports.applyVoucher = async (req, res) => {
  const { MaKhuyenMai, TongTienHang } = req.body;
  const { NguoiDungID } = req.user;

  if (!MaKhuyenMai || TongTienHang === undefined) {
    return res
      .status(400)
      .json({ message: "Thiếu thông tin mã hoặc tổng tiền." });
  }

  try {
    // 1. Kiểm tra user có mã này, CHƯA SỬ DỤNG, VÀ VOUCHER CÒN ACTIVE
    const [myVoucher] = await pool.query(
      `SELECT km.* FROM nguoidung_voucher AS ndv
       JOIN khuyenmai AS km ON ndv.MaKhuyenMai = km.MaKhuyenMai
       WHERE ndv.NguoiDungID = ? 
         AND ndv.MaKhuyenMai = ? 
         AND ndv.TrangThai = 'DA_NHAN'
         AND km.TrangThai = 'ACTIVE'`, // <<< ĐÃ THÊM ĐIỀU KIỆN TRẠNG THÁI
      [NguoiDungID, MaKhuyenMai]
    );

    if (myVoucher.length === 0) {
      return res.status(404).json({
        message: "Mã không hợp lệ, đã được sử dụng hoặc đã bị vô hiệu hóa.",
      });
    }

    const voucher = myVoucher[0];

    // 2. Kiểm tra (Giữ nguyên)
    if (new Date(voucher.NgayKetThuc) < new Date()) {
      return res.status(400).json({ message: "Mã đã hết hạn." });
    }
    if (voucher.ApDungToiThieu > TongTienHang) {
      return res.status(400).json({
        message: `Mã chỉ áp dụng cho đơn từ ${voucher.ApDungToiThieu.toLocaleString(
          "vi-VN"
        )} ₫`,
      });
    }

    // 3. Tính toán giảm giá (Giữ nguyên)
    let giamGia = 0;
    if (voucher.LoaiGiamGia === "SOTIEN") {
      giamGia = parseFloat(voucher.GiaTriGiam);
    }
    if (voucher.LoaiGiamGia === "PHANTRAM") {
      giamGia = (TongTienHang * parseFloat(voucher.GiaTriGiam)) / 100;
    }

    res.json({
      message: "Áp dụng mã thành công!",
      giamGia,
      MaKhuyenMai: voucher.MaKhuyenMai,
    });
  } catch (error) {
    console.error("Lỗi khi áp dụng voucher:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// --------------------------------------------------------
// --- ADMIN FUNCTIONS (ĐÃ CẬP NHẬT) ---
// --------------------------------------------------------

// @desc    Admin: Lấy TẤT CẢ voucher (Bao gồm cả INACTIVE)
// @route   GET /api/vouchers/admin
// @access  Private (Admin)
exports.getAllVouchersAdmin = async (req, res) => {
  try {
    const [vouchers] = await pool.query(
      `SELECT 
                km.*, 
                dm.TenDanhMuc, 
                sp.TenSanPham
             FROM khuyenmai km
             LEFT JOIN danhmuc dm ON km.DanhMucID = dm.DanhMucID
             LEFT JOIN sanpham sp ON km.SanPhamID = sp.SanPhamID
             ORDER BY km.NgayKetThuc DESC`
    );
    res.json(vouchers);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách voucher Admin:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Tạo voucher mới (Mặc định là ACTIVE)
// @route   POST /api/vouchers/admin
// @access  Private (Admin)
exports.createVoucher = async (req, res) => {
  try {
    const {
      MaKhuyenMai,
      TenKhuyenMai,
      LoaiGiamGia,
      GiaTriGiam,
      ApDungToiThieu,
      DanhMucID,
      SanPhamID,
      NgayBatDau,
      NgayKetThuc,
      SoLuongToiDa,
    } = req.body;

    if (
      !MaKhuyenMai ||
      !TenKhuyenMai ||
      !LoaiGiamGia ||
      GiaTriGiam === undefined ||
      !NgayBatDau ||
      !NgayKetThuc
    ) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc." });
    }

    const [existing] = await pool.query(
      "SELECT MaKhuyenMai FROM khuyenmai WHERE MaKhuyenMai = ?",
      [MaKhuyenMai]
    );
    if (existing.length > 0) {
      return res.status(400).json({ message: "Mã khuyến mãi này đã tồn tại." });
    }

    await pool.query(
      // Thêm TrangThai, mặc định là ACTIVE
      `INSERT INTO khuyenmai 
             (MaKhuyenMai, TenKhuyenMai, LoaiGiamGia, GiaTriGiam, ApDungToiThieu, DanhMucID, SanPhamID, NgayBatDau, NgayKetThuc, SoLuongToiDa, TrangThai) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE')`,
      [
        MaKhuyenMai,
        TenKhuyenMai,
        LoaiGiamGia,
        GiaTriGiam,
        ApDungToiThieu || 0,
        DanhMucID || null,
        SanPhamID || null,
        new Date(NgayBatDau),
        new Date(NgayKetThuc),
        SoLuongToiDa || 0,
      ]
    );

    res.status(201).json({ message: "Tạo voucher thành công!", MaKhuyenMai });
  } catch (error) {
    console.error("Lỗi khi tạo voucher:", error.message);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Cập nhật voucher (Cho phép cập nhật TrangThai)
// @route   PUT /api/vouchers/admin/:maKhuyenMai
// @access  Private (Admin)
exports.updateVoucher = async (req, res) => {
  try {
    const { maKhuyenMai } = req.params;
    const {
      TenKhuyenMai,
      LoaiGiamGia,
      GiaTriGiam,
      ApDungToiThieu,
      DanhMucID,
      SanPhamID,
      NgayBatDau,
      NgayKetThuc,
      SoLuongToiDa,
      TrangThai, // Thêm TrangThai
    } = req.body;

    const [result] = await pool.query(
      `UPDATE khuyenmai SET 
                TenKhuyenMai = ?, LoaiGiamGia = ?, GiaTriGiam = ?, ApDungToiThieu = ?, 
                DanhMucID = ?, SanPhamID = ?, NgayBatDau = ?, NgayKetThuc = ?, SoLuongToiDa = ?,
                TrangThai = ? 
             WHERE MaKhuyenMai = ?`,
      [
        TenKhuyenMai,
        LoaiGiamGia,
        GiaTriGiam,
        ApDungToiThieu,
        DanhMucID || null,
        SanPhamID || null,
        new Date(NgayBatDau),
        new Date(NgayKetThuc),
        SoLuongToiDa,
        TrangThai || "ACTIVE", // Đảm bảo trạng thái hợp lệ
        maKhuyenMai,
      ]
    );

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy voucher để cập nhật." });
    }

    res.json({ message: "Cập nhật voucher thành công!" });
  } catch (error) {
    console.error("Lỗi khi cập nhật voucher:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Vô hiệu hóa (Xóa mềm) voucher
// @route   PUT /api/vouchers/admin/:maKhuyenMai/disable
// @access  Private (Admin)
exports.disableVoucher = async (req, res) => {
  try {
    const { maKhuyenMai } = req.params;

    const [result] = await pool.query(
      "UPDATE khuyenmai SET TrangThai = 'INACTIVE' WHERE MaKhuyenMai = ?",
      [maKhuyenMai]
    );

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy voucher để vô hiệu hóa." });
    }

    res.json({ message: "Voucher đã được vô hiệu hóa thành công." });
  } catch (error) {
    console.error("Lỗi khi vô hiệu hóa voucher:", error);
    res.status(500).json({ message: "Lỗi server nội bộ." });
  }
};

// @desc    Admin: Kích hoạt lại (Soft Enable) voucher
// @route   PUT /api/vouchers/admin/:maKhuyenMai/enable
// @access  Private (Admin)
exports.enableVoucher = async (req, res) => {
  try {
    const { maKhuyenMai } = req.params;

    // Kích hoạt lại (Đặt TrangThai = 'ACTIVE')
    const [result] = await pool.query(
      "UPDATE khuyenmai SET TrangThai = 'ACTIVE' WHERE MaKhuyenMai = ?",
      [maKhuyenMai]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy voucher." });
    }

    res.json({ message: "Voucher đã được kích hoạt lại." });
  } catch (error) {
    console.error("Lỗi khi kích hoạt voucher:", error);
    res.status(500).json({ message: "Lỗi server nội bộ." });
  }
};
