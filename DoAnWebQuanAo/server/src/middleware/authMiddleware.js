// server/src/middleware/authMiddleware.js
const jwt = require("jsonwebtoken");
const pool = require("../config/db");

// Middleware xác thực người dùng (đã đăng nhập)
const protect = async (req, res, next) => {
  let token;

  // Kiểm tra xem header 'Authorization' có tồn tại và bắt đầu bằng 'Bearer' không
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // Lấy token từ header (loại bỏ 'Bearer ')
      token = req.headers.authorization.split(" ")[1];

      // Xác thực token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Lấy thông tin người dùng (trừ mật khẩu) từ payload của token
      // và gắn vào `req.user` để các hàm controller sau có thể sử dụng
      const [users] = await pool.query(
        "SELECT NguoiDungID, HoTen, Email, VaiTro, TrangThai FROM nguoidung WHERE NguoiDungID = ?",
        [decoded.id]
      );

      if (users.length === 0 || users[0].TrangThai !== "ACTIVE") {
        return res
          .status(401)
          .json({ message: "Người dùng không tồn tại hoặc đã bị khóa." });
      }

      req.user = users[0]; // Gắn thông tin user vào request
      next(); // Chuyển tiếp đến controller tiếp theo
    } catch (error) {
      console.error(error);
      return res
        .status(401)
        .json({ message: "Token không hợp lệ, không có quyền truy cập." });
    }
  }

  if (!token) {
    res
      .status(401)
      .json({ message: "Không có token, không có quyền truy cập." });
  }
};

// Middleware xác thực ADMIN
const isAdmin = (req, res, next) => {
  if (req.user && req.user.VaiTro === "ADMIN") {
    next(); // Là ADMIN, cho phép đi tiếp
  } else {
    // Lưu ý: Code này sẽ được sử dụng cùng với protect
    res
      .status(403)
      .json({ message: "Không phải là Admin, không có quyền thực hiện." });
  }
};

module.exports = { protect, isAdmin }; // Xuất cả hai hàm
