// server/src/controllers/attributeController.js
const pool = require("../config/db");

// @desc    Lấy tất cả thuộc tính và giá trị của chúng
// @route   GET /api/attributes
// @access  Public
exports.getAllAttributes = async (req, res) => {
  try {
    const [attributes] = await pool.query("SELECT * FROM thuoctinh");
    const [values] = await pool.query("SELECT * FROM giatrithuoctinh");

    const attributeMap = {};
    attributes.forEach((attr) => {
      attributeMap[attr.ThuocTinhID] = {
        ...attr,
        GiaTri: [],
      };
    });

    values.forEach((val) => {
      if (attributeMap[val.ThuocTinhID]) {
        attributeMap[val.ThuocTinhID].GiaTri.push(val);
      }
    });

    res.json(Object.values(attributeMap));
  } catch (error) {
    console.error("Lỗi khi lấy thuộc tính:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Thêm thuộc tính mới (Ví dụ: "Kích Cỡ")
exports.createAttribute = async (req, res) => {
  try {
    const { TenThuocTinh, Slug } = req.body;
    const [result] = await pool.query(
      "INSERT INTO thuoctinh (TenThuocTinh, Slug) VALUES (?, ?)",
      [TenThuocTinh, Slug]
    );
    res
      .status(201)
      .json({ message: "Tạo thuộc tính thành công", id: result.insertId });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Thêm giá trị cho thuộc tính (Ví dụ: "S", "M")
exports.createAttributeValue = async (req, res) => {
  try {
    const { ThuocTinhID } = req.params;
    const { GiaTri } = req.body; // Ví dụ: "Xanh dương"

    const [result] = await pool.query(
      "INSERT INTO giatrithuoctinh (ThuocTinhID, GiaTri) VALUES (?, ?)",
      [ThuocTinhID, GiaTri]
    );
    res
      .status(201)
      .json({
        message: "Tạo giá trị thuộc tính thành công",
        id: result.insertId,
      });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Xóa giá trị thuộc tính
exports.deleteAttributeValue = async (req, res) => {
  try {
    const { id } = req.params; // GiaTriThuocTinhID
    await pool.query("DELETE FROM giatrithuoctinh WHERE GiaTriID = ?", [id]);
    res.json({ message: "Xóa giá trị thuộc tính thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};
