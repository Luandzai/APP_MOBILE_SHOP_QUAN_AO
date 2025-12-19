// server/src/routes/sizeChartRoutes.js
const express = require("express");
const router = express.Router();
const {
  getSizeChartByCategory,
  upsertSizeChart,
} = require("../controllers/sizeChartController");
const { protect, isAdmin } = require("../middleware/authMiddleware");

// Public: Lấy bảng size
router.get("/:danhMucId", getSizeChartByCategory);

// Admin: Tạo/Sửa bảng size
router.post("/", protect, isAdmin, upsertSizeChart);

module.exports = router;
