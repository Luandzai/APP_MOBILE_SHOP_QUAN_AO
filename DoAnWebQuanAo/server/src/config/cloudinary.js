// server/src/config/cloudinary.js
const cloudinary = require("cloudinary").v2;
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const multer = require("multer");
require("dotenv").config();

// Cấu hình Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Cấu hình lưu trữ cho Multer
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: (req, file) => {
    // Xác định thư mục và định dạng file
    let folder;
    let resource_type;

    if (file.mimetype.startsWith("image/")) {
      folder = "reviews/images";
      resource_type = "image";
    } else if (file.mimetype.startsWith("video/")) {
      folder = "reviews/videos";
      resource_type = "video";
    } else {
      folder = "reviews/others";
      resource_type = "auto";
    }

    return {
      folder: folder,
      resource_type: resource_type,
      // public_id: file.originalname (Tùy chọn: đặt tên file)
    };
  },
});

// === SỬA ĐỔI: Thêm 'limits' vào middleware 'upload' ===
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 100 * 1024 * 1024, // Giới hạn 100MB
  },
});
// ====================================================

module.exports = { upload, cloudinary };