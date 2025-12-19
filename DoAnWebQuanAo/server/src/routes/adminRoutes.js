// server/src/routes/adminRoutes.js (ĐÃ CẬP NHẬT)

const express = require("express");
const router = express.Router();
const { protect, isAdmin } = require("../middleware/authMiddleware");
const adminController = require("../controllers/adminController");
const productController = require("../controllers/productController");
const reviewController = require("../controllers/reviewController");

// Áp dụng bảo vệ chung cho tất cả route Admin
router.use(protect, isAdmin);

// Quản lý Dashboard
router.get("/dashboard-stats", adminController.getDashboardStats);
// === ROUTE MỚI CHO BIỂU ĐỒ ===
router.get("/sales/monthly", adminController.getMonthlySales);

// Quản lý Sản phẩm
router.get("/products", productController.getAdminProducts);
router.get("/products/:id", productController.getAdminProductById); // <-- ROUTE MỚI

// Quản lý Người dùng
router.get("/users", adminController.getAllUsers);
router.put("/users/:id/status", adminController.updateUserStatus);
router.put("/users/:id/role", adminController.updateUserRole);

// === 2. THÊM QUẢN LÝ ĐÁNH GIÁ ===
// GET /api/admin/reviews
router.get("/reviews", reviewController.getAllReviewsAdmin);
// DELETE /api/admin/reviews/:id
router.delete("/reviews/:id", reviewController.deleteReviewAdmin);
router.put("/reviews/:id/reply", reviewController.replyToReview);
module.exports = router;
