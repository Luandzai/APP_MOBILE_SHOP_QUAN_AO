// server/src/routes/userRoutes.js
const express = require("express");
const router = express.Router();
const {
  getUserProfile,
  updateUserProfile,
  getWishlist,
  getMyVouchers,
  getMyApplicableVouchers,
  getMyReturns,
} = require("../controllers/userController");
const { protect } = require("../middleware/authMiddleware");

// Tất cả route user đều cần đăng nhập
router.use(protect);

router.get("/profile", getUserProfile);
router.put("/profile", updateUserProfile);
router.get("/wishlist", getWishlist);
router.get("/my-vouchers", getMyVouchers);
router.post("/my-applicable-vouchers", getMyApplicableVouchers);
router.get("/returns", getMyReturns);

module.exports = router;
