// server/src/routes/productRoutes.js
const express = require("express");
const router = express.Router();
const {
  getAllProducts,
  getProductBySlug,
  createProduct,
  updateProduct,
  deleteProduct,
  restoreProduct,
  getBestSellingProducts,
  getNewestProducts,
} = require("../controllers/productController");
const { protect, isAdmin } = require("../middleware/authMiddleware");
const { upload } = require("../config/cloudinary");

// === Public Routes (Cho người dùng) ===
router.get("/bestselling", getBestSellingProducts);
router.get("/newest", getNewestProducts);

router.get("/", getAllProducts);
router.get("/:slug", getProductBySlug);

// === Admin Routes (Cho quản trị viên) ===
// protect: Đảm bảo đã đăng nhập
// isAdmin: Đảm bảo là ADMIN
router.post(
  "/",
  protect,
  isAdmin,
  // DÒNG NÀY RẤT QUAN TRỌNG ĐỂ CÓ req.files VÀ req.body (texts)
  upload.array("images", 10),
  createProduct
);
router.put("/:id", protect, isAdmin, upload.array("images", 10), updateProduct);
router.patch("/:id/restore", protect, isAdmin, restoreProduct);
router.delete("/:id", protect, isAdmin, deleteProduct);

module.exports = router;