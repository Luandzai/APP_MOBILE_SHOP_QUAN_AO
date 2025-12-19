const express = require("express");
const router = express.Router();
const {
  getAllOrders,
  getAdminOrderDetail,
  updateOrderStatus,
} = require("../controllers/orderController");
const { protect, isAdmin } = require("../middleware/authMiddleware");

// Tất cả route admin đều cần đăng nhập và là admin
router.use(protect);
router.use(isAdmin);

// @desc    Admin: Lấy danh sách đơn hàng
// @route   GET /api/admin/orders
router.get("/", getAllOrders);

// @desc    Admin: Xem chi tiết đơn hàng
// @route   GET /api/admin/orders/:id
router.get("/:id", getAdminOrderDetail);

// @desc    Admin: Cập nhật trạng thái đơn hàng
// @route   PUT /api/admin/orders/:id/status
router.put("/:id/status", updateOrderStatus);

module.exports = router;
