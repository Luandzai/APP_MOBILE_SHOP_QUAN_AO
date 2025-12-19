// server/src/config/db.js
const mysql = require("mysql2/promise");
require("dotenv").config();

// Tạo một "pool" kết nối thay vì một kết nối đơn lẻ
// Pool giúp quản lý nhiều kết nối cùng lúc, hiệu quả hơn
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Hàm helper để kiểm tra kết nối
(async () => {
  try {
    const connection = await pool.getConnection();
    console.log("✅ Kết nối MySQL thành công!");
    connection.release();
  } catch (error) {
    console.error("❌ Không thể kết nối đến MySQL:", error.message);
  }
})();

module.exports = pool;
