// server/src/routes/returnsRoutes.js (ĐÃ BỔ SUNG ADMIN ROUTES)
const express = require("express");
const router = express.Router();
const { protect, isAdmin } = require("../middleware/authMiddleware");
const returnsController = require("../controllers/returnsController");

// --- Public Routes (User) ---
// User gửi yêu cầu đổi trả
router.post("/", protect, returnsController.requestReturn);
// User có thể xem danh sách yêu cầu của mình (Hàm này nằm trong userController, nhưng có thể nằm ở đây)
// router.get("/", protect, returnsController.getUserReturns);

// --- Admin Routes ---
// Áp dụng bảo vệ chung cho tất cả route Admin
router.use(protect, isAdmin);

// GET /api/admin/returns - Lấy danh sách yêu cầu (ĐÃ FIX LỖI 404)
router.get("/", returnsController.getAllReturns);
// GET /api/admin/returns/:id - Lấy chi tiết
router.get("/:id", returnsController.getReturnDetail);
// PUT /api/admin/returns/:id/status - Cập nhật trạng thái
router.put("/:id/status", returnsController.updateReturnStatus);

module.exports = router;
