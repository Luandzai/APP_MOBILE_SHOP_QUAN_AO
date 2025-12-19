// server/src/routes/attributeRoutes.js (ĐÃ NÂNG CẤP ADMIN)
const express = require("express");
const router = express.Router();
const {
  getAllAttributes,
  createAttribute, // <-- IMPORT MỚI
  createAttributeValue, // <-- IMPORT MỚI
  deleteAttributeValue, // <-- IMPORT MỚI
} = require("../controllers/attributeController");
const { protect, isAdmin } = require("../middleware/authMiddleware");

// Public Route
router.get("/", getAllAttributes);

// Admin Routes (Thuộc tính)
router.post("/", protect, isAdmin, createAttribute); // Tạo thuộc tính (Kích cỡ)

// Admin Routes (Giá trị thuộc tính)
router.post("/:ThuocTinhID/values", protect, isAdmin, createAttributeValue); // Tạo giá trị (S, M, Xanh)
router.delete("/values/:id", protect, isAdmin, deleteAttributeValue); // Xóa giá trị

module.exports = router;
