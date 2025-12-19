// server/src/middleware/uploadErrorHandler.js (File MỚI)
const multer = require("multer");

const handleUploadErrors = (err, req, res, next) => {
  // Kiểm tra xem lỗi có phải từ Multer không
  if (err instanceof multer.MulterError) {
    // Kiểm tra mã lỗi
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        message: "File quá lớn. Vui lòng chọn file ảnh/video dưới 100MB.",
      });
    }
    // Bạn có thể thêm các mã lỗi khác ở đây, ví dụ:
    // if (err.code === "LIMIT_FILE_COUNT") { ... }
  } else if (err) {
    // Một lỗi không xác định khác
    return res.status(500).json({ message: err.message });
  }

  // Nếu không có lỗi, cho phép đi tiếp
  next();
};

module.exports = handleUploadErrors;
