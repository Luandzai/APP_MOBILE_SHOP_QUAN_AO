// server/src/controllers/shippingController.js
const pool = require("../config/db");

// @desc    Lấy tất cả PTVC còn hoạt động
// @route   GET /api/shipping
// @access  Public
exports.getShippingMethods = async (req, res) => {
  try {
    const [methods] = await pool.query(
      "SELECT * FROM phuongthucvanchuyen"
      // Bạn có thể thêm "WHERE Active = TRUE" nếu có
    );
    res.json(methods);
  } catch (error) {
    console.error("Lỗi khi lấy PTVC:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
