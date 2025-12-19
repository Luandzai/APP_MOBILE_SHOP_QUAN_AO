// server/src/routes/orderRoutes.js
const express = require("express");
const router = express.Router();
const {
  createOrder,
  getMyOrders,
  getOrderById,
  cancelOrder,
  retryPayment,
} = require("../controllers/orderController");
const { protect } = require("../middleware/authMiddleware");

// Tất cả route đơn hàng đều cần đăng nhập
router.use(protect);

router.post("/", createOrder);
router.get("/", getMyOrders);
// @desc    Xem chi tiết 1 đơn hàng
router.get("/:id", getOrderById);
router.put("/:id/cancel", cancelOrder);
// @desc    Thanh toán lại đơn hàng chưa thanh toán
router.post("/:id/retry-payment", retryPayment);

module.exports = router;

