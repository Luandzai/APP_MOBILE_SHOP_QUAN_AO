// server/src/routes/shippingRoutes.js
const express = require("express");
const router = express.Router();
const { getShippingMethods } = require("../controllers/shippingController");

router.get("/", getShippingMethods);

module.exports = router;
