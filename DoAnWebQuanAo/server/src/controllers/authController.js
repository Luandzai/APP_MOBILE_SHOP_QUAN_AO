// server/src/controllers/authController.js
const pool = require("../config/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto"); // <-- THÊM MỚI
const sendEmail = require("../utils/sendEmail"); // <-- THÊM MỚI

const { OAuth2Client } = require("google-auth-library");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
// 1. ĐĂNG KÝ
exports.register = async (req, res) => {
  try {
    const { HoTen, Email, MatKhau } = req.body;

    // Kiểm tra đầu vào
    if (!HoTen || !Email || !MatKhau) {
      return res
        .status(400)
        .json({ message: "Vui lòng điền đầy đủ thông tin." });
    }

    // Kiểm tra xem email đã tồn tại chưa
    const [users] = await pool.query(
      "SELECT * FROM nguoidung WHERE Email = ?",
      [Email]
    );
    if (users.length > 0) {
      return res.status(409).json({ message: "Email này đã được sử dụng." });
    }

    // Mã hóa mật khẩu
    const salt = await bcrypt.genSalt(10);
    const MatKhauHash = await bcrypt.hash(MatKhau, salt);

    // Lưu người dùng vào DB (dùng schema của bạn)
    const [result] = await pool.query(
      "INSERT INTO nguoidung (HoTen, Email, MatKhauHash, VaiTro) VALUES (?, ?, ?, ?)",
      [HoTen, Email, MatKhauHash, "KHACHHANG"]
    );

    res.status(201).json({
      message: "Đăng ký thành công!",
      NguoiDungID: result.insertId,
    });
  } catch (error) {
    console.error("Lỗi khi đăng ký:", error);
    res.status(500).json({ message: "Lỗi server nội bộ" });
  }
};

// 2. ĐĂNG NHẬP
exports.login = async (req, res) => {
  const pool = require("../config/db"); // Giả định pool được import tại đây
  const bcrypt = require("bcryptjs"); // Giả định bcrypt được import
  const jwt = require("jsonwebtoken"); // Giả định jwt được import

  try {
    const { Email, MatKhau } = req.body;

    // 1. Kiểm tra đầu vào
    if (!Email || !MatKhau) {
      return res
        .status(400)
        .json({ message: "Vui lòng điền Email và Mật khẩu." });
    }

    // 2. Tìm người dùng trong DB
    const [users] = await pool.query(
      "SELECT * FROM nguoidung WHERE Email = ?",
      [Email]
    );
    const user = users[0];

    if (!user) {
      return res
        .status(401)
        .json({ message: "Email hoặc mật khẩu không chính xác." });
    }

    // 3. Kiểm tra trạng thái ACTIVE
    if (user.TrangThai !== "ACTIVE") {
      // Lấy từ DB: TrangThai
      return res
        .status(403)
        .json({ message: "Tài khoản của bạn đã bị vô hiệu hóa." });
    }

    // 4. So sánh mật khẩu
    const isMatch = await bcrypt.compare(MatKhau, user.MatKhauHash);
    if (!isMatch) {
      return res
        .status(401)
        .json({ message: "Email hoặc mật khẩu không chính xác." });
    }

    // 5. Tạo JWT - SỬA CASING: Sử dụng vaiTro (camelCase)
    const payload = {
      id: user.NguoiDungID,
      vaiTro: user.VaiTro, // Lấy VaiTro từ DB
    };

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: "30d", // Token hết hạn sau 30 ngày
    });

    // 6. Tính toán ngày hết hạn và lưu phiên đăng nhập
    const hetHan = new Date();
    hetHan.setDate(hetHan.getDate() + 30);

    await pool.query(
      "INSERT INTO phiendangnhap (NguoiDungID, Token, HetHan) VALUES (?, ?, ?)",
      [user.NguoiDungID, token, hetHan]
    );

    // 7. Trả về token và thông tin người dùng - SỬA CASING: Thống nhất vaiTro và thêm trangThai
    res.json({
      message: "Đăng nhập thành công!",
      token,
      user: {
        id: user.NguoiDungID,
        hoTen: user.HoTen,
        email: user.Email,
        vaiTro: user.VaiTro, // <<< SỬ DỤNG camelCase cho Frontend >>>
        trangThai: user.TrangThai, // <<< THÊM TRẠNG THÁI (camelCase) >>>
        dienThoai: user.DienThoai,
        ngaySinh: user.NgaySinh,
        gioiTinh: user.GioiTinh,
      },
    });
  } catch (error) {
    console.error("Lỗi khi đăng nhập:", error);
    res.status(500).json({ message: "Lỗi server nội bộ" });
  }
};

// === 2. HÀM MỚI: XỬ LÝ GOOGLE LOGIN ===
exports.googleLogin = async (req, res) => {
  // Giả định pool, jwt, client (từ google-auth-library) đã được import
  const pool = require("../config/db");
  const jwt = require("jsonwebtoken");
  // const { OAuth2Client } = require("google-auth-library");
  // const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

  const { token } = req.body;
  try {
    // 1. Xác thực token với Google (Giữ nguyên)
    const ticket = await client.verifyIdToken({
      idToken: token,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { sub: googleId, email, name: hoTen } = payload; // Lấy thông tin

    // 2. Kiểm tra CSDL xem user này đã tồn tại chưa (bằng GoogleID)
    const [existingUser] = await pool.query(
      "SELECT * FROM nguoidung WHERE GoogleID = ?",
      [googleId]
    );

    let user = existingUser[0];

    // 3. Nếu user CHƯA tồn tại (Giữ nguyên logic tạo user)
    if (!user) {
      // Kiểm tra xem email đã được dùng (cho tài khoản LOCAL) chưa
      const [emailCheck] = await pool.query(
        "SELECT * FROM nguoidung WHERE Email = ?",
        [email]
      );
      if (emailCheck.length > 0) {
        return res.status(400).json({
          message:
            "Email này đã được đăng ký bằng mật khẩu. Vui lòng đăng nhập bằng mật khẩu.",
        });
      }

      // TẠO USER MỚI (Mặc định VaiTro là KHACHHANG, TrangThai là ACTIVE)
      const [newUser] = await pool.query(
        "INSERT INTO nguoidung (Email, GoogleID, HoTen, LoaiXacThuc, TrangThai) VALUES (?, ?, ?, 'GOOGLE', 'ACTIVE')",
        [email, googleId, hoTen]
      );

      // Lấy lại user vừa tạo
      const [userRows] = await pool.query(
        "SELECT * FROM nguoidung WHERE NguoiDungID = ?",
        [newUser.insertId]
      );
      user = userRows[0];
    }

    // 4. KIỂM TRA TRẠNG THÁI (Nếu đã tồn tại hoặc vừa được tạo)
    if (user.TrangThai !== "ACTIVE") {
      return res
        .status(403)
        .json({ message: "Tài khoản của bạn đã bị vô hiệu hóa." });
    }

    // 5. TẠO TOKEN JWT (Của riêng server chúng ta)
    // SỬA CASING: Sử dụng vaiTro (camelCase)
    const appPayload = {
      id: user.NguoiDungID,
      vaiTro: user.VaiTro,
    };
    const appToken = jwt.sign(appPayload, process.env.JWT_SECRET, {
      expiresIn: "30d",
    });

    // 6. Lưu token vào PhienDangNhap
    const hetHan = new Date();
    hetHan.setDate(hetHan.getDate() + 30);
    await pool.query(
      "INSERT INTO phiendangnhap (NguoiDungID, Token, HetHan) VALUES (?, ?, ?)",
      [user.NguoiDungID, appToken, hetHan]
    );

    // 7. Trả về token (của chúng ta) và thông tin user
    // SỬA CASING: Thống nhất vaiTro và thêm trangThai (camelCase)
    res.json({
      message: "Đăng nhập Google thành công!",
      token: appToken,
      user: {
        id: user.NguoiDungID,
        hoTen: user.HoTen,
        email: user.Email,
        vaiTro: user.VaiTro, // <<< ĐÃ SỬA CASING >>>
        trangThai: user.TrangThai, // <<< ĐÃ THÊM THUỘC TÍNH TRẠNG THÁI >>>
        dienThoai: user.DienThoai,
        ngaySinh: user.NgaySinh,
        gioiTinh: user.GioiTinh,
      },
    });
  } catch (error) {
    console.error("Lỗi khi đăng nhập Google:", error);
    res.status(401).json({ message: "Token không hợp lệ hoặc đã hết hạn." });
  }
};

// === 3. HÀM MỚI: QUÊN MẬT KHẨU ===
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    // 1. Tìm user
    const [users] = await pool.query(
      "SELECT * FROM nguoidung WHERE Email = ? AND LoaiXacThuc = 'LOCAL'",
      [email]
    );
    const user = users[0];

    if (!user) {
      return res
        .status(404)
        .json({ message: "Email không tồn tại hoặc đăng nhập bằng Google." });
    }

    // 2. Tạo token reset (bằng 'crypto' của Node.js)
    const resetToken = crypto.randomBytes(32).toString("hex");

    // 3. Hash token này để lưu vào CSDL (bảo mật)
    const hashedToken = crypto
      .createHash("sha256")
      .update(resetToken)
      .digest("hex");

    // 4. Đặt thời gian hết hạn (10 phút)
    const expires = new Date(Date.now() + 10 * 60 * 1000); // 10 phút

    // 5. Lưu token HASHED vào CSDL
    await pool.query(
      "UPDATE nguoidung SET MatKhauResetToken = ?, MatKhauResetTokenExpires = ? WHERE NguoiDungID = ?",
      [hashedToken, expires, user.NguoiDungID]
    );

    // 6. Tạo URL reset (gửi token PLAIN cho user)
    const clientUrl = process.env.CLIENT_URL || 'http://localhost:5173';
    const resetUrl = `${clientUrl}/reset-password/${resetToken}`;

    // 7. Tạo nội dung email
    const emailHtml = `
      <p>Bạn (hoặc ai đó) đã yêu cầu đặt lại mật khẩu cho tài khoản BLANK CANVAS.</p>
      <p>Vui lòng nhấp vào liên kết bên dưới để đặt lại mật khẩu của bạn:</p>
      <a href="${resetUrl}" clicktracking="off">${resetUrl}</a>
      <p>Liên kết này sẽ hết hạn sau 10 phút.</p>
      <p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>
    `;

    // 8. Gửi email
    await sendEmail({
      email: user.Email,
      subject: "Yêu cầu đặt lại mật khẩu BLANK CANVAS",
      html: emailHtml,
    });

    res.json({ message: "Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra!" });
  } catch (error) {
    console.error("Lỗi khi quên mật khẩu:", error);
    // Xóa token nếu có lỗi
    await pool.query(
      "UPDATE nguoidung SET MatKhauResetToken = NULL, MatKhauResetTokenExpires = NULL WHERE Email = ?",
      [req.body.email]
    );
    res.status(500).json({ message: "Lỗi server khi gửi email" });
  }
};

// === 4. HÀM MỚI: ĐẶT LẠI MẬT KHẨU ===
exports.resetPassword = async (req, res) => {
  try {
    const { token } = req.params;
    const { password } = req.body;

    // 1. Hash token (plain) từ URL để so sánh với token (hashed) trong CSDL
    const hashedToken = crypto.createHash("sha256").update(token).digest("hex");

    // 2. Tìm user bằng token HASHED và THỜI GIAN
    const [users] = await pool.query(
      "SELECT * FROM nguoidung WHERE MatKhauResetToken = ? AND MatKhauResetTokenExpires > NOW()",
      [hashedToken]
    );
    const user = users[0];

    if (!user) {
      return res
        .status(400)
        .json({ message: "Token không hợp lệ hoặc đã hết hạn." });
    }

    // 3. Hash mật khẩu mới
    const salt = await bcrypt.genSalt(10);
    const MatKhauHash = await bcrypt.hash(password, salt);

    // 4. Cập nhật mật khẩu VÀ xóa token
    await pool.query(
      "UPDATE nguoidung SET MatKhauHash = ?, MatKhauResetToken = NULL, MatKhauResetTokenExpires = NULL WHERE NguoiDungID = ?",
      [MatKhauHash, user.NguoiDungID]
    );

    res.json({ message: "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập." });
  } catch (error) {
    console.error("Lỗi khi reset mật khẩu:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
