// server/src/controllers/categoryController.js
const pool = require("../config/db");
const slugify = require("slugify");

// @desc    Lấy tất cả danh mục (cả cha và con)
// @route   GET /api/categories
// @access  Public
exports.getAllCategories = async (req, res) => {
  try {
    // Lấy tất cả danh mục, sắp xếp theo Cha trước
    const [categories] = await pool.query(
      "SELECT * FROM danhmuc ORDER BY DanhMucChaID ASC, TenDanhMuc ASC"
    );
    res.json(categories);
  } catch (error) {
    console.error("Lỗi khi lấy danh mục:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Tạo danh mục mới
// @route   POST /api/categories
// @access  Private (Admin)
exports.createCategory = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { TenDanhMuc, Slug, DanhMucChaID } = req.body;

    // Validate required fields
    if (!TenDanhMuc) {
      return res.status(400).json({ message: "Tên danh mục là bắt buộc." });
    }

    // Generate slug if not provided
    const finalSlug =
      Slug ||
      slugify(TenDanhMuc, {
        lower: true,
        locale: "vi",
        remove: /[*+~.()'"!:@]/g,
      });

    await connection.beginTransaction();

    // Check if parent category exists if provided
    if (DanhMucChaID) {
      const [parentExists] = await connection.query(
        "SELECT DanhMucID FROM danhmuc WHERE DanhMucID = ?",
        [DanhMucChaID]
      );
      if (parentExists.length === 0) {
        await connection.rollback();
        return res.status(400).json({ message: "Danh mục cha không tồn tại." });
      }
    }

    // Check for duplicate slug
    const [existing] = await connection.query(
      "SELECT DanhMucID FROM danhmuc WHERE Slug = ?",
      [finalSlug]
    );
    if (existing.length > 0) {
      await connection.rollback();
      return res.status(400).json({ message: "Slug đã tồn tại." });
    }

    // Insert new category
    const [result] = await connection.query(
      "INSERT INTO danhmuc (TenDanhMuc, Slug, DanhMucChaID) VALUES (?, ?, ?)",
      [TenDanhMuc, finalSlug, DanhMucChaID || null]
    );

    await connection.commit();

    res.status(201).json({
      message: "Tạo danh mục thành công!",
      category: {
        DanhMucID: result.insertId,
        TenDanhMuc,
        Slug: finalSlug,
        DanhMucChaID: DanhMucChaID || null,
      },
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi tạo danh mục:", error);
    res.status(500).json({
      message: "Lỗi server khi tạo danh mục",
      error: error.message,
    });
  } finally {
    connection.release();
  }
};

// @desc    Admin: Cập nhật danh mục
// @route   PUT /api/categories/:id
// @access  Private (Admin)
exports.updateCategory = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id } = req.params;
    const { TenDanhMuc, Slug, DanhMucChaID } = req.body;

    await connection.beginTransaction();

    // 1. Check if category exists
    const [categoryExists] = await connection.query(
      "SELECT DanhMucID FROM danhmuc WHERE DanhMucID = ?",
      [id]
    );
    if (categoryExists.length === 0) {
      await connection.rollback();
      return res.status(404).json({ message: "Không tìm thấy danh mục" });
    }

    // 2. Validate required fields
    if (!TenDanhMuc) {
      await connection.rollback();
      return res.status(400).json({ message: "Tên danh mục là bắt buộc" });
    }

    // 3. Generate or validate slug
    const finalSlug =
      Slug ||
      slugify(TenDanhMuc, {
        lower: true,
        locale: "vi",
        remove: /[*+~.()'"!:@]/g,
      });

    // 4. Check for duplicate slug (excluding current category)
    const [existing] = await connection.query(
      "SELECT DanhMucID FROM danhmuc WHERE Slug = ? AND DanhMucID != ?",
      [finalSlug, id]
    );
    if (existing.length > 0) {
      await connection.rollback();
      return res.status(400).json({ message: "Slug đã tồn tại" });
    }

    // 5. If parent category is specified, validate it exists and prevent self-reference
    if (DanhMucChaID) {
      if (DanhMucChaID === id) {
        await connection.rollback();
        return res
          .status(400)
          .json({ message: "Danh mục không thể là cha của chính nó" });
      }

      const [parentExists] = await connection.query(
        "SELECT DanhMucID FROM danhmuc WHERE DanhMucID = ?",
        [DanhMucChaID]
      );
      if (parentExists.length === 0) {
        await connection.rollback();
        return res.status(400).json({ message: "Danh mục cha không tồn tại" });
      }

      // Check for circular reference
      let parentId = DanhMucChaID;
      while (parentId) {
        if (parentId === id) {
          await connection.rollback();
          return res
            .status(400)
            .json({ message: "Không thể tạo vòng lặp trong cây danh mục" });
        }
        const [parent] = await connection.query(
          "SELECT DanhMucChaID FROM danhmuc WHERE DanhMucID = ?",
          [parentId]
        );
        parentId = parent[0]?.DanhMucChaID;
      }
    }

    // 6. Update the category
    await connection.query(
      "UPDATE danhmuc SET TenDanhMuc = ?, Slug = ?, DanhMucChaID = ? WHERE DanhMucID = ?",
      [TenDanhMuc, finalSlug, DanhMucChaID || null, id]
    );

    await connection.commit();

    res.json({
      message: "Cập nhật danh mục thành công!",
      category: {
        DanhMucID: id,
        TenDanhMuc,
        Slug: finalSlug,
        DanhMucChaID: DanhMucChaID || null,
      },
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi cập nhật danh mục:", error);
    res.status(500).json({
      message: "Lỗi server khi cập nhật danh mục",
      error: error.message,
    });
  } finally {
    connection.release();
  }
};

// @desc    Admin: Xóa danh mục
// @route   DELETE /api/categories/:id
// @access  Private (Admin)
exports.deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;

    // TÙY CHỌN: Bạn có thể thêm logic kiểm tra khóa ngoại ở đây
    // Nếu có lỗi, MySQL sẽ tự báo lỗi khóa ngoại 400.
    await pool.query("DELETE FROM danhmuc WHERE DanhMucID = ?", [id]);

    res.json({ message: "Xóa danh mục thành công!" });
  } catch (error) {
    console.error("Lỗi khi xóa danh mục:", error);
    res.status(400).json({
      message:
        "Không thể xóa danh mục này (Có thể do đang có sản phẩm/danh mục con liên kết).",
    });
  }
};
