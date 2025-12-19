// server/src/routes/categoryRoutes.js (ĐÃ NÂNG CẤP ADMIN)
const express = require("express");
const router = express.Router();
const {
  getAllCategories,
  createCategory, // <-- IMPORT MỚI
  updateCategory, // <-- IMPORT MỚI
  deleteCategory, // <-- IMPORT MỚI
} = require("../controllers/categoryController");
const { protect, isAdmin } = require("../middleware/authMiddleware"); // <-- IMPORT MỚI

// Public Route
router.get("/", getAllCategories);

// Admin Routes (Cần bảo vệ)
router.post("/", protect, isAdmin, createCategory);
router.put("/:id", protect, isAdmin, updateCategory);
router.delete("/:id", protect, isAdmin, deleteCategory);

module.exports = router;
