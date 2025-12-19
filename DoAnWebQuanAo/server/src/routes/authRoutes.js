// server/src/routes/authRoutes.js
const express = require("express");
const router = express.Router();
// 1. Import thêm 'googleLogin'
const {
  register,
  login,
  googleLogin,
  forgotPassword, // <-- THÊM MỚI
  resetPassword, // <-- THÊM MỚI
} = require("../controllers/authController");

router.post("/register", register);
router.post("/login", login);
router.post("/google", googleLogin); // <-- 2. THÊM ROUTE MỚI

// <-- 3. THÊM 2 ROUTE MỚI -->
router.post("/forgot-password", forgotPassword);
router.put("/reset-password/:token", resetPassword);

module.exports = router;
