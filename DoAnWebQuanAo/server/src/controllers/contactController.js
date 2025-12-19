// server/src/controllers/contactController.js (File MỚI)

const sendEmail = require("../utils/sendEmail");
require("dotenv").config();

const handleContactForm = async (req, res) => {
  try {
    const { name, email, phone, message } = req.body;

    // Kiểm tra dữ liệu đầu vào cơ bản
    if (!name || !email || !message) {
      return res
        .status(400)
        .json({ message: "Vui lòng điền đầy đủ các trường bắt buộc." });
    }

    const adminEmail = process.env.EMAIL_ADMIN;
    if (!adminEmail) {
      console.error("EMAIL_ADMIN is not defined in .env file");
      return res.status(500).json({ message: "Lỗi cấu hình máy chủ." });
    }

    const subject = `[BLANK CANVAS] - Liên hệ mới từ ${name}`;
    const html = `
      <h2>Bạn có một tin nhắn liên hệ mới từ website BLANK CANVAS</h2>
      <p><strong>Tên người gửi:</strong> ${name}</p>
      <p><strong>Email:</strong> ${email}</p>
      <p><strong>Số điện thoại:</strong> ${phone || "Không cung cấp"}</p>
      <hr>
      <h3>Nội dung:</h3>
      <p>${message.replace(/\n/g, "<br>")}</p>
    `;

    await sendEmail({ email: adminEmail, subject, html });

    res
      .status(200)
      .json({
        message:
          "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.",
      });
  } catch (error) {
    console.error("Error sending contact email:", error);
    res
      .status(500)
      .json({ message: "Đã có lỗi xảy ra, vui lòng thử lại sau." });
  }
};

module.exports = { handleContactForm };
