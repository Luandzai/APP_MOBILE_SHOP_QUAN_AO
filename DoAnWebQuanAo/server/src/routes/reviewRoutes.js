// server/src/routes/reviewRoutes.js
const express = require("express");
const router = express.Router();
const {
  createReview,
  getMyReviewByProduct,
  updateReview,
} = require("../controllers/reviewController");
const { protect } = require("../middleware/authMiddleware");
const { upload } = require("../config/cloudinary");
const handleUploadErrors = require("../middleware/uploadErrorHandler"); // <-- IMPORT MỚI

// Hàm helper để bọc middleware
const uploadMiddleware = upload.fields([
  { name: "image", maxCount: 1 },
  { name: "video", maxCount: 1 },
]);

// Hàm helper để xử lý lỗi
const uploadErrorHandler = (req, res, next) => {
  uploadMiddleware(req, res, (err) => {
    // Chuyển lỗi (nếu có) cho middleware xử lý lỗi
    handleUploadErrors(err, req, res, next);
  });
};

// @route   POST /api/reviews
// @desc    Tạo một đánh giá mới
// @access  Private
// === SỬA ĐỔI: Sử dụng 2 middleware ===
router.post(
  "/",
  protect,
  uploadErrorHandler, // Chạy upload và bắt lỗi trước
  createReview // Chỉ chạy nếu upload thành công
);
// ======================================

// @route   GET /api/reviews/my-review/:phienBanId
// @desc    Lấy đánh giá của tôi cho 1 sản phẩm
// @access  Private
router.get("/my-review/:phienBanId", protect, getMyReviewByProduct);

// @route   PUT /api/reviews/:id
// @desc    Cập nhật 1 đánh giá
// @access  Private
// === SỬA ĐỔI: Sử dụng 2 middleware ===
router.put(
  "/:id",
  protect,
  uploadErrorHandler, // Chạy upload và bắt lỗi trước
  updateReview // Chỉ chạy nếu upload thành công
);
// ======================================

module.exports = router;
