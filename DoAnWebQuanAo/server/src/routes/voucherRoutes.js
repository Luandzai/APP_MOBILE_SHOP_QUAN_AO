// server/src/routes/voucherRoutes.js (ĐÃ SỬA LỖI 404 CHO USER)
const express = require("express");
const router = express.Router();
const {
  getActiveVouchers,
  collectVoucher,
  applyVoucher,
  getVouchersForProduct,
  getAllVouchersAdmin,
  createVoucher,
  updateVoucher,
  disableVoucher,
  enableVoucher,
} = require("../controllers/voucherController");
const { protect, isAdmin } = require("../middleware/authMiddleware");

// === 1. USER ROUTES (Không yêu cầu Admin) ===
// (Những route này được gắn vào /api/vouchers)

// GET /api/vouchers
router.get("/", getActiveVouchers);
// GET /api/vouchers/product/:sanPhamId  <-- ROUTE GÂY LỖI 404
router.get("/product/:sanPhamId", getVouchersForProduct);
// POST /api/vouchers/collect
router.post("/collect", protect, collectVoucher);
// POST /api/vouchers/apply
router.post("/apply", protect, applyVoucher);

// === 2. ADMIN ROUTES (Yêu cầu Admin) ===
// (Các route này cũng được gắn vào /api/vouchers, nhưng có tiền tố /admin)

// GET /api/vouchers/admin
router.get("/admin", protect, isAdmin, getAllVouchersAdmin);
// POST /api/vouchers/admin
router.post("/admin", protect, isAdmin, createVoucher);
// PUT /api/vouchers/admin/:maKhuyenMai
router.put("/admin/:maKhuyenMai", protect, isAdmin, updateVoucher);
// PUT /api/vouchers/admin/:maKhuyenMai/disable
router.put("/admin/:maKhuyenMai/disable", protect, isAdmin, disableVoucher);
// PUT /api/vouchers/admin/:maKhuyenMai/enable
router.put("/admin/:maKhuyenMai/enable", protect, isAdmin, enableVoucher);

module.exports = router;
