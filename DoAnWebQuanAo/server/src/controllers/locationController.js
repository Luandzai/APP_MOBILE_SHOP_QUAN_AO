// server/src/controllers/locationController.js
const axios = require("axios");
require("dotenv").config();

const GHN_API_BASE =
  "https://online-gateway.ghn.vn/shiip/public-api/master-data";
const GHN_API_KEY = process.env.GHN_API_KEY;

// Tạo một instance axios cho GHN
const ghnApi = axios.create({
  baseURL: GHN_API_BASE,
  headers: {
    Token: GHN_API_KEY,
  },
});

// @desc    Lấy danh sách Tỉnh/Thành
// @route   GET /api/locations/provinces
exports.getProvinces = async (req, res) => {
  try {
    const response = await ghnApi.get("/province");
    res.json(response.data.data); // Trả về mảng Tỉnh/Thành
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi lấy dữ liệu tỉnh thành" });
  }
};

// @desc    Lấy danh sách Quận/Huyện
// @route   GET /api/locations/districts
exports.getDistricts = async (req, res) => {
  try {
    const { province_id } = req.query; // Lấy province_id từ query
    if (!province_id) {
      return res.status(400).json({ message: "Thiếu ProvinceID" });
    }
    const response = await ghnApi.get("/district", { params: { province_id } });
    res.json(response.data.data);
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi lấy dữ liệu quận huyện" });
  }
};

// @desc    Lấy danh sách Phường/Xã
// @route   GET /api/locations/wards
exports.getWards = async (req, res) => {
  try {
    const { district_id } = req.query; // Lấy district_id từ query
    if (!district_id) {
      return res.status(400).json({ message: "Thiếu DistrictID" });
    }
    const response = await ghnApi.get("/ward", { params: { district_id } });
    res.json(response.data.data);
  } catch (error) {
    res.status(500).json({ message: "Lỗi khi lấy dữ liệu phường xã" });
  }
};
