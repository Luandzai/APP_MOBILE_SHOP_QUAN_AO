// server/src/controllers/cartController.js
const pool = require("../config/db");

// @desc    Lấy giỏ hàng của người dùng
// @route   GET /api/cart
// @access  Private
exports.getCart = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;

    const [items] = await pool.query(
      `SELECT 
         ct.PhienBanID, ct.SoLuong, 
         sp.TenSanPham, sp.Slug, pb.GiaBan, pb.SKU,
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
          FROM chitietphienban AS ctpb
          JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
          JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
          WHERE ctpb.PhienBanID = ct.PhienBanID
         ) AS ThuocTinh,
        
         -- Lấy ảnh chính (LaAnhChinh) từ SanPhamID (sp.SanPhamID)
         -- thay vì tìm theo PhienBanID
         (SELECT HinhAnh.URL 
          FROM hinhanhsanpham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnh
          
       FROM chitietgiohang AS ct
       JOIN giohang AS gh ON ct.GioHangID = gh.NguoiDungID
       JOIN phienbansanpham AS pb ON ct.PhienBanID = pb.PhienBanID
       JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE gh.NguoiDungID = ?`,
      [NguoiDungID]
    );

    res.json(items);
  } catch (error) {
    console.error("Lỗi khi lấy giỏ hàng:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Thêm/Cập nhật sản phẩm trong giỏ hàng
// @route   POST /api/cart
// @access  Private
exports.addToCart = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const { PhienBanID, SoLuong } = req.body;

    if (SoLuong <= 0) {
      return res.status(400).json({ message: "Số lượng phải lớn hơn 0" });
    }

    // 1. Kiểm tra tồn kho và trạng thái sản phẩm
    const [variant] = await pool.query(
      `SELECT pb.SoLuongTonKho, sp.TenSanPham, sp.TrangThai
       FROM phienbansanpham pb
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       WHERE pb.PhienBanID = ?`,
      [PhienBanID]
    );
    if (variant.length === 0) {
      return res.status(404).json({ message: "Sản phẩm không tồn tại" });
    }
    // Kiểm tra trạng thái ACTIVE
    if (variant[0].TrangThai !== "ACTIVE") {
      return res.status(400).json({
        message: `Sản phẩm "${variant[0].TenSanPham}" không còn được bán`,
      });
    }
    if (variant[0].SoLuongTonKho < SoLuong) {
      return res.status(400).json({
        message: `Hàng tồn kho không đủ (chỉ còn ${variant[0].SoLuongTonKho})`,
      });
    }

    // Tìm hoặc tạo giỏ hàng
    await pool.query("INSERT IGNORE INTO giohang (NguoiDungID) VALUES (?)", [
      NguoiDungID,
    ]);

    // Thêm hoặc CỘNG DỒN số lượng (giỏ hàng cũ + số lượng mới)
    await pool.query(
      `INSERT INTO chitietgiohang (GioHangID, PhienBanID, SoLuong) 
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE SoLuong = SoLuong + VALUES(SoLuong)`,
      [NguoiDungID, PhienBanID, SoLuong]
    );

    res.status(201).json({ message: "Đã thêm vào giỏ hàng" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Cập nhật số lượng (từ trang Giỏ hàng)
// @route   PUT /api/cart
// @access  Private
exports.updateQuantity = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const { PhienBanID, SoLuong } = req.body;

    if (SoLuong <= 0) {
      // Nếu số lượng là 0, gọi hàm xóa
      return exports.removeFromCart(req, res);
    }

    // Kiểm tra tồn kho và trạng thái sản phẩm
    const [variant] = await pool.query(
      `SELECT pb.SoLuongTonKho, sp.TenSanPham, sp.TrangThai
       FROM phienbansanpham pb
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       WHERE pb.PhienBanID = ?`,
      [PhienBanID]
    );
    if (variant.length === 0) {
      return res.status(404).json({ message: "Sản phẩm không tồn tại" });
    }
    // Kiểm tra trạng thái ACTIVE
    if (variant[0].TrangThai !== "ACTIVE") {
      return res.status(400).json({
        message: `Sản phẩm "${variant[0].TenSanPham}" không còn được bán`,
      });
    }
    if (variant[0].SoLuongTonKho < SoLuong) {
      return res.status(400).json({
        message: `Số lượng tồn kho không đủ (chỉ còn ${variant[0].SoLuongTonKho} sản phẩm)`,
      });
    }

    // Cập nhật (SET) số lượng mới
    await pool.query(
      "UPDATE chitietgiohang SET SoLuong = ? WHERE GioHangID = ? AND PhienBanID = ?",
      [SoLuong, NguoiDungID, PhienBanID]
    );

    res.json({ message: "Đã cập nhật giỏ hàng" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Xóa sản phẩm khỏi giỏ hàng
// @route   DELETE /api/cart/:phienBanId
// @access  Private
exports.removeFromCart = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const { phienBanId } = req.params; // Lấy từ URL

    await pool.query(
      "DELETE FROM chitietgiohang WHERE GioHangID = ? AND PhienBanID = ?",
      [NguoiDungID, phienBanId]
    );

    res.json({ message: "Đã xóa sản phẩm" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};
