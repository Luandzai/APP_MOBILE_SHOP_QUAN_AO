// server/src/routes/paymentRoutes.js
const express = require("express");
const router = express.Router();
const {
  vnpayReturn,
  vnpayIpn,
  momoReturn,
  momoIpn,
} = require("../controllers/paymentController");

// VNPAY routes (GET)
router.get("/vnpay_return", vnpayReturn);
router.get("/vnpay_ipn", vnpayIpn);

// MOMO routes
router.get("/momo_return", momoReturn);
router.post("/momo_ipn", momoIpn);

module.exports = router;
