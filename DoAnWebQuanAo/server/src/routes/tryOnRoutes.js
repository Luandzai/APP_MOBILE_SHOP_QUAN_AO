const express = require("express");
const multer = require("multer");
const { handleTryOn } = require("../controllers/tryOnController");

const router = express.Router();

// Cấu hình Multer để lưu file vào bộ nhớ (memory storage)
// Điều này hiệu quả vì chúng ta chỉ cần buffer để gửi đi nơi khác
const storage = multer.memoryStorage();
const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 } // Giới hạn file 10MB
});

// Định nghĩa route POST /api/try-on
// Sử dụng upload.fields để xử lý nhiều loại file từ các field khác nhau
router.post(
    "/",
    upload.fields([
        { name: "personImage", maxCount: 1 },
        { name: "clothImage", maxCount: 1 },
    ]),
    handleTryOn
);

module.exports = router;
