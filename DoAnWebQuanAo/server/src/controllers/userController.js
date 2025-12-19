// server/src/controllers/userController.js
const pool = require("../config/db");

// @desc    Lấy thông tin tài khoản
// @route   GET /api/user/profile
// @access  Private
exports.getUserProfile = async (req, res) => {
  // Vì middleware "protect" đã lấy thông tin user và gắn vào req.user,
  // chúng ta chỉ cần trả nó về (trừ mật khẩu)
  const userProfile = {
    NguoiDungID: req.user.NguoiDungID,
    HoTen: req.user.HoTen,
    Email: req.user.Email,
    DienThoai: req.user.DienThoai,
    NgaySinh: req.user.NgaySinh,
    GioiTinh: req.user.GioiTinh,
  };
  res.json(userProfile);
};

// @desc    Cập nhật thông tin tài khoản
// @route   PUT /api/user/profile
// @access  Private
exports.updateUserProfile = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const { HoTen, DienThoai, NgaySinh, GioiTinh } = req.body;

    // Xử lý NgaySinh: chuyển chuỗi rỗng thành null
    const ngaySinhValue = NgaySinh && NgaySinh.trim() !== '' ? NgaySinh : null;
    // Xử lý GioiTinh: chuyển chuỗi rỗng thành null
    const gioiTinhValue = GioiTinh && GioiTinh.trim() !== '' ? GioiTinh : null;

    await pool.query(
      "UPDATE nguoidung SET HoTen = ?, DienThoai = ?, NgaySinh = ?, GioiTinh = ? WHERE NguoiDungID = ?",
      [HoTen, DienThoai, ngaySinhValue, gioiTinhValue, NguoiDungID]
    );

    res.json({ message: "Cập nhật thông tin thành công" });
  } catch (error) {
    console.error("Lỗi updateUserProfile:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// @desc    Lấy danh sách yêu thích
// @route   GET /api/user/wishlist
// @access  Private
exports.getWishlist = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;

    // Query JOIN 3 bảng: YeuThich -> PhienBanSanPham -> SanPham
    const [wishlistItems] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc,
         pb.PhienBanID, 
         pb.GiaBan,
         (SELECT HinhAnh.URL 
          FROM hinhanhsanpham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh
       FROM yeuthich AS yt
       JOIN phienbansanpham AS pb ON yt.PhienBanID = pb.PhienBanID
       JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE yt.NguoiDungID = ?`,
      [NguoiDungID]
    );

    res.json(wishlistItems);
  } catch (error) {
    console.error("Lỗi khi lấy wishlist:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy các voucher MÀ NGƯỜI DÙNG ĐÃ LƯU (và CHƯA SỬ DỤNG)
// @route   GET /api/user/my-vouchers
// @access  Private
exports.getMyVouchers = async (req, res) => {
  const { NguoiDungID } = req.user;
  try {
    // THÊM: AND ndv.TrangThai = 'DA_NHAN'
    const [myVouchers] = await pool.query(
      `SELECT km.* FROM nguoidung_voucher AS ndv
       JOIN khuyenmai AS km ON ndv.MaKhuyenMai = km.MaKhuyenMai
       WHERE ndv.NguoiDungID = ? 
         AND km.NgayKetThuc > NOW() 
         AND ndv.TrangThai = 'DA_NHAN'`, // Chỉ lấy voucher còn hạn và CHƯA DÙNG
      [NguoiDungID]
    );
    res.json(myVouchers);
  } catch (error) {
    console.error("Lỗi khi lấy voucher của tôi:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy các voucher MÀ NGƯỜI DÙNG ĐÃ LƯU và CÓ THỂ ÁP DỤNG cho giỏ hàng
// @route   POST /api/user/my-applicable-vouchers
// @access  Private
exports.getMyApplicableVouchers = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { cartItems } = req.body;

  if (!cartItems || !Array.isArray(cartItems) || cartItems.length === 0) {
    return res.json([]); // Nếu giỏ hàng trống, không có voucher nào áp dụng được
  }

  const connection = await pool.getConnection();
  try {
    // 1. Lấy SanPhamID và DanhMucID từ các PhienBanID trong giỏ hàng
    const phienBanIDs = cartItems.map((item) => item.PhienBanID);
    const [productInfoRows] = await connection.query(
      `SELECT DISTINCT sp.SanPhamID, sp.DanhMucID
       FROM phienbansanpham pb
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       WHERE pb.PhienBanID IN (?)`,
      [phienBanIDs]
    );

    const sanPhamIDsInCart = productInfoRows.map((p) => p.SanPhamID);
    const danhMucIDsInCart = productInfoRows.map((p) => p.DanhMucID);
    
    // 2. Lấy DanhMucChaID (danh mục cha) của các danh mục sản phẩm
    let allDanhMucIDs = [...danhMucIDsInCart];
    if (danhMucIDsInCart.length > 0) {
      const [categoryRows] = await connection.query(
        `SELECT DanhMucID, DanhMucChaID FROM danhmuc WHERE DanhMucID IN (?)`,
        [danhMucIDsInCart]
      );
      // Thêm danh mục cha vào danh sách (nếu có)
      const danhMucChaIDs = categoryRows
        .map((c) => c.DanhMucChaID)
        .filter((id) => id !== null);
      allDanhMucIDs = [...new Set([...danhMucIDsInCart, ...danhMucChaIDs])];
    }

    // 3. Lấy tất cả voucher người dùng đã lưu, còn hạn, còn lượt và đang active
    // Kiểm tra voucher áp dụng cho: toàn sàn, sản phẩm cụ thể, danh mục (bao gồm cả danh mục cha)
    const [myVouchers] = await connection.query(
      `SELECT km.* 
       FROM nguoidung_voucher AS ndv
       JOIN khuyenmai AS km ON ndv.MaKhuyenMai = km.MaKhuyenMai
       WHERE ndv.NguoiDungID = ? 
         AND km.NgayKetThuc > NOW() 
         AND km.SoLuongToiDa > 0
         AND km.TrangThai = 'ACTIVE'
         AND ndv.TrangThai = 'DA_NHAN'
         AND (
            (km.SanPhamID IS NULL AND km.DanhMucID IS NULL) -- Voucher toàn sàn
            OR (km.SanPhamID IS NOT NULL AND km.SanPhamID IN (?)) -- Voucher cho sản phẩm cụ thể
            OR (km.DanhMucID IS NOT NULL AND km.DanhMucID IN (?)) -- Voucher cho danh mục (bao gồm danh mục cha)
         )`,
      [NguoiDungID, sanPhamIDsInCart, allDanhMucIDs]
    );

    res.json(myVouchers);
  } catch (error) {
    console.error("Lỗi khi lấy voucher có thể áp dụng:", error);
    res.status(500).json({ message: "Lỗi server" });
  } finally {
    connection.release();
  }
};

// @desc    Lấy danh sách yêu cầu đổi/trả của người dùng
// @route   GET /api/user/returns
// @access  Private
exports.getMyReturns = async (req, res) => {
  const { NguoiDungID } = req.user;
  try {
    // Lấy tất cả phiếu Returns của user
    const [returns] = await pool.query(
      `SELECT r.ReturnID, r.DonHangID, r.Reason, r.Status, r.NgayYeuCau
       FROM returns AS r
       JOIN donhang AS dh ON r.DonHangID = dh.DonHangID
       WHERE dh.NguoiDungID = ?
       ORDER BY r.NgayYeuCau DESC`,
      [NguoiDungID]
    );

    res.json(returns);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đổi/trả:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
