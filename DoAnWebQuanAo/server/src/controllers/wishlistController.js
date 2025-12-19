// server/src/controllers/wishlistController.js
const pool = require("../config/db");

// @desc    Thêm sản phẩm vào Yêu thích
// @route   POST /api/wishlist
// @access  Private
exports.addWishlistItem = async (req, res) => {
  const { SanPhamID } = req.body;
  const { NguoiDungID } = req.user;

  if (!SanPhamID) {
    return res.status(400).json({ message: "Thiếu SanPhamID" });
  }

  try {
    // 1. Tìm 1 PhienBanID bất kỳ của SanPhamID này
    const [variants] = await pool.query(
      "SELECT PhienBanID FROM phienbansanpham WHERE SanPhamID = ? LIMIT 1",
      [SanPhamID]
    );

    if (variants.length === 0) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy phiên bản sản phẩm" });
    }
    const firstPhienBanID = variants[0].PhienBanID;

    // 2. Thêm vào bảng YeuThich (dùng IGNORE để tránh lỗi trùng lặp)
    await pool.query(
      "INSERT IGNORE INTO yeuthich (NguoiDungID, PhienBanID) VALUES (?, ?)",
      [NguoiDungID, firstPhienBanID]
    );

    res.status(201).json({ message: "Đã thêm vào yêu thích" });
  } catch (error) {
    console.error("Lỗi khi thêm wishlist:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Xóa sản phẩm khỏi Yêu thích
// @route   DELETE /api/wishlist/:sanPhamId
// @access  Private
exports.removeWishlistItem = async (req, res) => {
  const { sanPhamId } = req.params;
  const { NguoiDungID } = req.user;

  try {
    // Xóa dựa trên SanPhamID, bằng cách JOIN 2 bảng
    // (Vì YeuThich lưu PhienBanID, nhưng chúng ta xóa theo SanPhamID)
    await pool.query(
      `DELETE yt FROM yeuthich AS yt
       JOIN phienbansanpham AS pb ON yt.PhienBanID = pb.PhienBanID
       WHERE yt.NguoiDungID = ? AND pb.SanPhamID = ?`,
      [NguoiDungID, sanPhamId]
    );

    res.json({ message: "Đã xóa khỏi yêu thích" });
  } catch (error) {
    console.error("Lỗi khi xóa wishlist:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
