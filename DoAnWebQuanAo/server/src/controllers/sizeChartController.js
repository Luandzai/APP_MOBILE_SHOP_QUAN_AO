// server/src/controllers/sizeChartController.js
const pool = require("../config/db");

// @desc    Lấy bảng size theo DanhMucID
// @route   GET /api/sizecharts/:danhMucId
// @access  Public
exports.getSizeChartByCategory = async (req, res) => {
  try {
    const { danhMucId } = req.params;
    const [rows] = await pool.query(
      "SELECT * FROM sizechart WHERE DanhMucID = ?",
      [danhMucId]
    );

    if (rows.length === 0) {
      return res.json({ MoTa: null }); // Trả về null nếu chưa có
    }

    res.json(rows[0]);
  } catch (error) {
    console.error("Lỗi lấy size chart:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Tạo hoặc Cập nhật bảng size cho danh mục
// @route   POST /api/sizecharts
// @access  Private (Admin)
exports.upsertSizeChart = async (req, res) => {
  try {
    const { DanhMucID, MoTa } = req.body;

    if (!DanhMucID) {
      return res.status(400).json({ message: "Thiếu DanhMucID" });
    }

    // Kiểm tra xem đã có chưa
    const [existing] = await pool.query(
      "SELECT SizeChartID FROM sizechart WHERE DanhMucID = ?",
      [DanhMucID]
    );

    if (existing.length > 0) {
      // UPDATE
      await pool.query("UPDATE sizechart SET MoTa = ? WHERE DanhMucID = ?", [
        MoTa,
        DanhMucID,
      ]);
      res.json({ message: "Cập nhật bảng size thành công!" });
    } else {
      // INSERT
      await pool.query(
        "INSERT INTO sizechart (DanhMucID, MoTa) VALUES (?, ?)",
        [DanhMucID, MoTa]
      );
      res.status(201).json({ message: "Tạo bảng size thành công!" });
    }
  } catch (error) {
    console.error("Lỗi lưu size chart:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
