// server/src/routes/cartRoutes.js (ĐÃ NÂNG CẤP)
const express = require("express");
const router = express.Router();
const {
  getCart,
  addToCart,
  updateQuantity,
  removeFromCart,
  clearCart,
} = require("../controllers/cartController");
const { protect } = require("../middleware/authMiddleware");

router.use(protect); // Bảo vệ tất cả

router.get("/", getCart);
router.post("/", addToCart);
router.put("/", updateQuantity); // Route PUT mới
router.delete("/clear", clearCart); // Xóa toàn bộ giỏ hàng (phải đặt trước :phienBanId)
router.delete("/:phienBanId", removeFromCart); // Route DELETE mới

module.exports = router;
