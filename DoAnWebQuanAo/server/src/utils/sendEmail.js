// server/src/utils/sendEmail.js (File MỚI)
const nodemailer = require("nodemailer");
require("dotenv").config();

const sendEmail = async (options) => {
  // 1. Tạo transporter (dịch vụ sẽ gửi email)
  const transporter = nodemailer.createTransport({
    service: "gmail", // Sử dụng service của Gmail để cấu hình đơn giản hơn
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  // 2. Định nghĩa các tùy chọn email
  const mailOptions = {
    from: `BLANK CANVAS <${process.env.EMAIL_USER}>`,
    to: options.email,
    subject: options.subject,
    html: options.html, // Gửi nội dung dạng HTML
  };

  // 3. Gửi email
  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;
