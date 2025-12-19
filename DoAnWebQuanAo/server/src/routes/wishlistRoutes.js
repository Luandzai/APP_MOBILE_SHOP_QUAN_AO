// server/src/routes/wishlistRoutes.js
const express = require("express");
const router = express.Router();
const {
  addWishlistItem,
  removeWishlistItem,
} = require("../controllers/wishlistController");
const { protect } = require("../middleware/authMiddleware");

// Bảo vệ tất cả các route này
router.use(protect);

router.post("/", addWishlistItem);
router.delete("/:sanPhamId", removeWishlistItem);

module.exports = router;
