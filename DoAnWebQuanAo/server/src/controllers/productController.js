// server/src/controllers/productController.js (ĐÃ NÂNG CẤP BADGE ĐỘNG)
const pool = require("../config/db");
// Hằng số cho phân trang
const PRODUCTS_PER_PAGE = 15;
// === THÊM CÁC IMPORT NÀY LÊN ĐẦU ===
const { cloudinary } = require("../config/cloudinary");
const slugify = require("slugify");
// @desc    Lấy tất cả sản phẩm (ĐÃ NÂNG CẤP)
// @route   GET /api/products
// @access  Public
exports.getAllProducts = async (req, res) => {
  try {
    const filters = req.query;
    const { danhMuc, khoangGia, sortBy, search } = filters;

    // 1. Phân trang
    const page = parseInt(req.query.page) || 1;
    const limit = PRODUCTS_PER_PAGE;
    const offset = (page - 1) * limit;

    let baseSelect = `
      SELECT 
        sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc, 
        (SELECT HinhAnh.URL FROM hinhanhsanpham AS HinhAnh 
         WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
         LIMIT 1) as HinhAnhChinh,
        MIN(pb.GiaBan) as GiaBan,
        IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
        (EXISTS (
            SELECT 1 FROM khuyenmai km
            LEFT JOIN danhmuc dm_sp ON sp.DanhMucID = dm_sp.DanhMucID
            WHERE (
              (km.SanPhamID IS NULL AND km.DanhMucID IS NULL)
              OR km.SanPhamID = sp.SanPhamID 
              OR km.DanhMucID = sp.DanhMucID 
              OR km.DanhMucID = dm_sp.DanhMucChaID
            )
            AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
            AND km.TrangThai = 'ACTIVE'
        )) AS HasVoucher,
        COUNT(DISTINCT tt.ThuocTinhID) AS ThuocTinhKhop
    `;

    let fromJoin = `
      FROM sanpham AS sp
      LEFT JOIN danhmuc AS dm_child ON sp.DanhMucID = dm_child.DanhMucID
      LEFT JOIN danhmuc AS dm_parent ON dm_child.DanhMucChaID = dm_parent.DanhMucID
      LEFT JOIN phienbansanpham AS pb ON sp.SanPhamID = pb.SanPhamID
      LEFT JOIN chitietphienban AS ctpb ON pb.PhienBanID = ctpb.PhienBanID
      LEFT JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
      LEFT JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
    `;

    let whereClauses = ["sp.TrangThai = 'ACTIVE'"];
    let params = [];
    let havingConditions = [];

    // Logic Lọc (Giữ nguyên)
    if (search) {
      whereClauses.push(`sp.TenSanPham LIKE ?`);
      params.push(`%${search}%`);
    }

    if (danhMuc) {
      const categories = danhMuc.split(",");
      whereClauses.push(`(dm_child.Slug IN (?) OR dm_parent.Slug IN (?))`);
      params.push(categories);
      params.push(categories);
    }

    if (khoangGia) {
      const priceRanges = khoangGia.split(",");
      let priceConditions = [];
      priceRanges.forEach((range) => {
        const [min, max] = range.split("-");
        priceConditions.push(`(pb.GiaBan BETWEEN ? AND ?)`);
        params.push(min);
        params.push(max);
      });
      whereClauses.push(`(${priceConditions.join(" OR ")})`);
    }

    const attributeFilters = Object.keys(filters).filter(
      (key) =>
        !["danhMuc", "khoangGia", "sortBy", "search", "page"].includes(key)
    );

    // Nếu có attribute filters, sử dụng subquery để tìm variant khớp TẤT CẢ thuộc tính
    if (attributeFilters.length > 0) {
      // Xây dựng subquery: tìm các PhienBanID có TẤT CẢ thuộc tính được chọn
      let attrConditions = [];
      attributeFilters.forEach((attrSlug) => {
        const values = filters[attrSlug].split(",");
        // Mỗi thuộc tính phải match ít nhất 1 giá trị
        attrConditions.push(`
          EXISTS (
            SELECT 1 FROM chitietphienban ctpb_sub
            JOIN giatrithuoctinh gtt_sub ON ctpb_sub.GiaTriID = gtt_sub.GiaTriID
            JOIN thuoctinh tt_sub ON gtt_sub.ThuocTinhID = tt_sub.ThuocTinhID
            WHERE ctpb_sub.PhienBanID = pb.PhienBanID
              AND tt_sub.Slug = ?
              AND gtt_sub.GiaTri IN (?)
          )
        `);
        params.push(attrSlug);
        params.push(values);
      });
      
      // Tất cả điều kiện phải thỏa mãn (AND)
      whereClauses.push(`(${attrConditions.join(" AND ")})`);
    }
    // Kết thúc Logic Lọc

    let whereSql = "";
    if (whereClauses.length > 0) {
      whereSql = " WHERE " + whereClauses.join(" AND ");
    }

    let havingSql = "";
    if (havingConditions.length > 0) {
      havingSql = " HAVING " + havingConditions.join(" AND ");
    }

    const groupBy =
      " GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc ";

    // 2. Lấy Tổng số sản phẩm (Count Query)
    // Query chỉ cần lấy ID để đếm số sản phẩm khớp
    const countQuery = `SELECT sp.SanPhamID ${fromJoin} ${whereSql} ${groupBy} ${havingSql}`;

    // Tham số cho Count Query (không bao gồm LIMIT/OFFSET)
    const countParams = [...params];

    // Thực hiện Count Query
    const [allProducts] = await pool.query(countQuery, countParams);
    const totalProducts = allProducts.length;
    const totalPages = Math.ceil(totalProducts / limit);

    // 3. Lấy dữ liệu theo phân trang (Data Query)
    let dataQuery = baseSelect + fromJoin + whereSql + groupBy + havingSql;

    let orderAndLimit = "";
    if (sortBy === "price-asc") {
      orderAndLimit = " ORDER BY GiaBan ASC LIMIT ? OFFSET ?";
    } else if (sortBy === "price-desc") {
      orderAndLimit = " ORDER BY GiaBan DESC LIMIT ? OFFSET ?";
    } else {
      orderAndLimit = ` ORDER BY sp.NgayTao DESC LIMIT ? OFFSET ?`;
    }

    // Thêm tham số LIMIT/OFFSET vào mảng params chỉ cho data query
    params.push(limit);
    params.push(offset);

    dataQuery += orderAndLimit;

    const [products] = await pool.query(dataQuery, params);

    // 4. Trả về kết quả
    res.json({
      products,
      currentPage: page,
      totalPages: totalPages,
      totalProducts: totalProducts,
    });
  } catch (error) {
    console.error("Lỗi khi lấy tất cả sản phẩm (Filter/Pagination):", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy chi tiết 1 sản phẩm (cho người dùng)
// @route   GET /api/products/:slug
// @access  Public
exports.getProductBySlug = async (req, res) => {
  try {
    const { slug } = req.params;
    const [productRows] = await pool.query(
      `SELECT 
         sp.*, 
         dm.Slug AS DanhMucSlug,
         (SELECT SUM(ctdh.SoLuong) 
          FROM chitietdonhang AS ctdh
          JOIN donhang AS dh ON ctdh.DonHangID = dh.DonHangID
          JOIN phienbansanpham AS pb ON ctdh.PhienBanID = pb.PhienBanID
          WHERE pb.SanPhamID = sp.SanPhamID AND (dh.TrangThai = 'DA_GIAO' OR dh.TrangThai = 'DANG_XU_LY')
         ) AS TotalSold
       FROM sanpham AS sp 
       LEFT JOIN danhmuc AS dm ON sp.DanhMucID = dm.DanhMucID
       WHERE sp.Slug = ? AND sp.TrangThai = 'ACTIVE'`,
      [slug]
    );
    if (productRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }
    const product = productRows[0];
    const [images] = await pool.query(
      "SELECT HinhAnhID, URL, MoTa FROM hinhanhsanpham WHERE SanPhamID = ?",
      [product.SanPhamID]
    );
    const [variants] = await pool.query(
      `SELECT 
         pb.PhienBanID, pb.SKU, pb.GiaBan, pb.SoLuongTonKho,
         JSON_OBJECTAGG(tt.TenThuocTinh, gtt.GiaTri) AS options
       FROM phienbansanpham AS pb
       JOIN chitietphienban AS ctpb ON pb.PhienBanID = ctpb.PhienBanID
       JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
       JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
       WHERE pb.SanPhamID = ?
       GROUP BY pb.PhienBanID`,
      [product.SanPhamID]
    );

    const [reviews] = await pool.query(
      `SELECT 
         dg.DanhGiaID, dg.DiemSo, dg.BinhLuan, 
         dg.NgayTao, dg.NgayCapNhat,
         dg.PhanHoi, dg.NgayPhanHoi, 
         dg.HinhAnhURL, dg.VideoURL,
         nd.HoTen,
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
          FROM chitietphienban AS ctpb
          JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
          JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
          WHERE ctpb.PhienBanID = dg.PhienBanID
         ) AS ThuocTinh
       FROM danhgia AS dg
       JOIN nguoidung AS nd ON dg.NguoiDungID = nd.NguoiDungID
       WHERE dg.PhienBanID IN (SELECT PhienBanID FROM phienbansanpham WHERE SanPhamID = ?)
       ORDER BY dg.NgayTao DESC`,
      [product.SanPhamID]
    );

    res.json({
      ...product,
      HinhAnh: images,
      PhienBan: variants,
      DanhGia: reviews,
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// === HÀM TẠO SẢN PHẨM HOÀN CHỈNH (CREATE) ===
exports.createProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    // 1. Lấy dữ liệu và Parse versions
    const {
      TenSanPham,
      MoTa,
      DanhMucID,
      GiaGoc,
      ThuongHieu,
      ChatLieu,
      versions: versionsJson, // versions là JSON string
    } = req.body;

    let versions = [];
    if (versionsJson) {
      versions = JSON.parse(versionsJson);
    }

    // 2. Kiểm tra bắt buộc & Slug
    if (!TenSanPham || !DanhMucID || !GiaGoc) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc (Tên, Danh mục, Giá gốc).",
      });
    }
    if (!req.files || req.files.length === 0) {
      return res
        .status(400)
        .json({ message: "Vui lòng tải lên ít nhất 1 ảnh." });
    }
    if (versions.length === 0) {
      return res
        .status(400)
        .json({ message: "Vui lòng thêm ít nhất một phiên bản sản phẩm." });
    }

    const slug = slugify(TenSanPham, {
      lower: true,
      locale: "vi",
      remove: /[*+~.()'"!:@]/g,
    });

    await connection.beginTransaction(); // Bắt đầu Transaction

    // 3. INSERT SanPham
    const [spResult] = await connection.query(
      `INSERT INTO sanpham (TenSanPham, Slug, MoTa, DanhMucID, GiaGoc, ThuongHieu, ChatLieu, TrangThai) 
       VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE')`,
      [
        TenSanPham,
        slug,
        MoTa || null,
        DanhMucID,
        GiaGoc,
        ThuongHieu || null,
        ChatLieu || null,
      ]
    );
    const newSanPhamID = spResult.insertId;

    // 4. INSERT Ảnh (req.files từ Multer/Cloudinary)
    for (let index = 0; index < req.files.length; index++) {
      const file = req.files[index];
      await connection.query(
        `INSERT INTO hinhanhsanpham (SanPhamID, URL, MoTa, LaAnhChinh, ViTri) 
             VALUES (?, ?, ?, ?, ?)`,
        [newSanPhamID, file.path, file.originalname, index === 0 ? 1 : 0, index]
      );
    }

    // 5. INSERT Phiên bản và Chi tiết Phiên bản
    for (const version of versions) {
      // 5a. INSERT PhienBanSanPham
      const [pbResult] = await connection.query(
        `INSERT INTO phienbansanpham (SanPhamID, SKU, GiaBan, SoLuongTonKho) 
             VALUES (?, ?, ?, ?)`,
        [newSanPhamID, version.sku, version.price, version.stock]
      );
      const newPhienBanID = pbResult.insertId;

      // 5b. INSERT ChiTietPhienBan
      for (const [attrName, attrValue] of Object.entries(version.options)) {
        const [attrValueRows] = await connection.query(
          `SELECT gtt.GiaTriID 
                 FROM giatrithuoctinh AS gtt
                 JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
                 WHERE tt.TenThuocTinh = ? AND gtt.GiaTri = ?`,
          [attrName, attrValue]
        );

        if (attrValueRows.length === 0) {
          throw new Error(
            `Giá trị thuộc tính không hợp lệ: ${attrName}: ${attrValue}`
          );
        }

        await connection.query(
          `INSERT INTO chitietphienban (PhienBanID, GiaTriID) 
                 VALUES (?, ?)`,
          [newPhienBanID, attrValueRows[0].GiaTriID]
        );
      }
    }

    await connection.commit(); // Thành công
    res
      .status(201)
      .json({ message: "Tạo sản phẩm thành công!", SanPhamID: newSanPhamID });
  } catch (error) {
    await connection.rollback(); // Lỗi -> Hoàn tác DB

    // Xóa file đã tải lên Cloudinary nếu Transaction bị lỗi (Quan trọng!)
    if (req.files) {
      for (const file of req.files) {
        await cloudinary.uploader.destroy(file.filename);
      }
    }

    console.error("Lỗi khi tạo sản phẩm:", error);
    res
      .status(500)
      .json({ message: error.message || "Lỗi server nội bộ khi tạo sản phẩm" });
  } finally {
    connection.release();
  }
};

// @desc    Admin: Lấy chi tiết 1 sản phẩm (cho trang admin)
// @route   GET /api/admin/products/:id
// @access  Private (Admin)
exports.getAdminProductById = async (req, res) => {
  try {
    const { id } = req.params;

    // 1. Lấy thông tin sản phẩm cơ bản
    const [productRows] = await pool.query(
      `SELECT * FROM sanpham WHERE SanPhamID = ?`,
      [id]
    );
    if (productRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }
    const product = productRows[0];

    // 2. Lấy danh sách hình ảnh
    const [images] = await pool.query(
      "SELECT HinhAnhID, URL, LaAnhChinh FROM hinhanhsanpham WHERE SanPhamID = ? ORDER BY ViTri ASC",
      [id]
    );

    // 3. Lấy danh sách phiên bản và thuộc tính của chúng
    const [variants] = await pool.query(
      `SELECT
         pb.PhienBanID, pb.SKU, pb.GiaBan, pb.SoLuongTonKho,
         JSON_OBJECTAGG(tt.TenThuocTinh, gtt.GiaTri) AS options
       FROM phienbansanpham AS pb
       JOIN chitietphienban AS ctpb ON pb.PhienBanID = ctpb.PhienBanID
       JOIN giatrithuoctinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
       JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
       WHERE pb.SanPhamID = ?
       GROUP BY pb.PhienBanID`,
      [id]
    );

    // Đổi tên các key cho nhất quán với frontend
    const formattedVariants = variants.map((v) => ({
      ...v,
      sku: v.SKU,
      price: v.GiaBan,
      stock: v.SoLuongTonKho,
    }));

    res.json({
      ...product,
      images: images,
      versions: formattedVariants, // Trả về 'versions' thay vì 'PhienBan'
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết sản phẩm admin:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.updateProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id } = req.params;
    const {
      TenSanPham,
      MoTa,
      DanhMucID,
      GiaGoc,
      ThuongHieu,
      ChatLieu,
      versions: versionsJson,
      deletedImages: deletedImagesJson, // Ảnh bị xóa
      deletedVariantIds: deletedVariantIdsJson, // Phiên bản bị xóa
    } = req.body;

    let versions = [];
    if (versionsJson) {
      versions = JSON.parse(versionsJson);
    }

    let deletedImages = [];
    if (deletedImagesJson) {
      deletedImages = JSON.parse(deletedImagesJson);
    }

    let deletedVariantIds = [];
    if (deletedVariantIdsJson) {
      deletedVariantIds = JSON.parse(deletedVariantIdsJson);
    }

    await connection.beginTransaction();

    // 1. Update basic product info
    const slug = slugify(TenSanPham, {
      lower: true,
      locale: "vi",
      remove: /[*+~.()'"!:@]/g,
    });

    await connection.query(
      `UPDATE sanpham 
       SET TenSanPham = ?, Slug = ?, MoTa = ?, GiaGoc = ?, 
           ThuongHieu = ?, ChatLieu = ?, DanhMucID = ? 
       WHERE SanPhamID = ?`,
      [TenSanPham, slug, MoTa, GiaGoc, ThuongHieu, ChatLieu, DanhMucID, id]
    );

    // 2. Handle deleted images
    if (deletedImages && deletedImages.length > 0) {
      const imageIdsToDelete = deletedImages.map((img) => img.HinhAnhID);

      // Delete from Cloudinary
      for (const image of deletedImages) {
        const publicId = image.URL.split("/").pop().split(".")[0]; // Cần logic tốt hơn để lấy publicId
        if (publicId) await cloudinary.uploader.destroy(publicId);
      }
      // Delete from DB
      await connection.query(
        "DELETE FROM hinhanhsanpham WHERE HinhAnhID IN (?)",
        [imageIdsToDelete]
      );
    }

    // 3. Add new images if any
    if (req.files && req.files.length > 0) {
      const [existingImages] = await connection.query(
        "SELECT COUNT(*) as count FROM hinhanhsanpham WHERE SanPhamID = ?",
        [id]
      );

      let startPosition = existingImages[0].count;

      for (let index = 0; index < req.files.length; index++) {
        const file = req.files[index];
        await connection.query(
          `INSERT INTO hinhanhsanpham (SanPhamID, URL, MoTa, LaAnhChinh, ViTri) 
           VALUES (?, ?, ?, ?, ?)`,
          [
            id,
            file.path,
            file.originalname,
            startPosition === 0 && index === 0 ? 1 : 0,
            startPosition + index,
          ]
        );
      }
    }

    // 4. Handle deleted variants
    if (deletedVariantIds && deletedVariantIds.length > 0) {
      await connection.query(
        "DELETE FROM chitietphienban WHERE PhienBanID IN (?)",
        [deletedVariantIds]
      );
      await connection.query(
        "DELETE FROM phienbansanpham WHERE PhienBanID IN (?)",
        [deletedVariantIds]
      );
    }

    // 5. Handle new and updated variants
    for (const version of versions) {
      if (version.PhienBanID) {
        // UPDATE existing variant
        await connection.query(
          `UPDATE phienbansanpham SET SKU = ?, GiaBan = ?, SoLuongTonKho = ? WHERE PhienBanID = ?`,
          [version.sku, version.price, version.stock, version.PhienBanID]
        );
      } else {
        // INSERT new variant
        const [pbResult] = await connection.query(
          `INSERT INTO phienbansanpham (SanPhamID, SKU, GiaBan, SoLuongTonKho) VALUES (?, ?, ?, ?)`,
          [id, version.sku, version.price, version.stock]
        );
        const newPhienBanID = pbResult.insertId;

        // Insert ChiTietPhienBan for the new variant
        for (const [attrName, attrValue] of Object.entries(version.options)) {
          const [attrValueRows] = await connection.query(
            `SELECT gtt.GiaTriID FROM giatrithuoctinh AS gtt
             JOIN thuoctinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
             WHERE tt.TenThuocTinh = ? AND gtt.GiaTri = ?`,
            [attrName, attrValue]
          );

          if (attrValueRows.length === 0) {
            throw new Error(
              `Giá trị thuộc tính không hợp lệ: ${attrName}: ${attrValue}`
            );
          }

          await connection.query(
            `INSERT INTO chitietphienban (PhienBanID, GiaTriID) VALUES (?, ?)`,
            [newPhienBanID, attrValueRows[0].GiaTriID]
          );
        }
      }
    }

    await connection.commit();
    res.json({
      message: "Cập nhật sản phẩm thành công!",
      productId: id,
    });
  } catch (error) {
    await connection.rollback();

    // Cleanup any uploaded images if there was an error
    if (req.files) {
      for (const file of req.files) {
        await cloudinary.uploader.destroy(file.filename);
      }
    }

    console.error("Lỗi khi cập nhật sản phẩm:", error);
    res.status(500).json({
      message: error.message || "Lỗi server khi cập nhật sản phẩm",
    });
  } finally {
    connection.release();
  }
};

// === HÀM XÓA SẢN PHẨM (ARCHIVE) ===
exports.deleteProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id } = req.params;

    await connection.beginTransaction();

    // 1. Check if product exists and get its current status
    const [product] = await connection.query(
      "SELECT TrangThai FROM sanpham WHERE SanPhamID = ?",
      [id]
    );

    if (product.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }

    // 2. Check if product is already archived
    if (product[0].TrangThai === "ARCHIVED") {
      return res
        .status(400)
        .json({ message: "Sản phẩm đã được lưu trữ trước đó" });
    }

    // 3. Check if product has any orders
    const [orders] = await connection.query(
      `SELECT COUNT(*) as count 
       FROM chitietdonhang ctdh 
       JOIN phienbansanpham pb ON ctdh.PhienBanID = pb.PhienBanID 
       WHERE pb.SanPhamID = ?`,
      [id]
    );

    // 4. If product has orders, just archive it
    if (orders[0].count > 0) {
      await connection.query(
        "UPDATE sanpham SET TrangThai = 'ARCHIVED' WHERE SanPhamID = ?",
        [id]
      );
    } else {
      // 5. If no orders, we can delete associated data
      // Get image URLs for Cloudinary cleanup
      const [images] = await connection.query(
        "SELECT URL FROM hinhanhsanpham WHERE SanPhamID = ?",
        [id]
      );

      // Delete from HinhAnhSanPham
      await connection.query("DELETE FROM hinhanhsanpham WHERE SanPhamID = ?", [
        id,
      ]);

      // Get variant IDs
      const [variants] = await connection.query(
        "SELECT PhienBanID FROM phienbansanpham WHERE SanPhamID = ?",
        [id]
      );
      const variantIds = variants.map((v) => v.PhienBanID);

      if (variantIds.length > 0) {
        // Delete from ChiTietPhienBan
        await connection.query(
          "DELETE FROM chitietphienban WHERE PhienBanID IN (?)",
          [variantIds]
        );
      }

      // Delete from PhienBanSanPham
      await connection.query(
        "DELETE FROM phienbansanpham WHERE SanPhamID = ?",
        [id]
      );

      // Delete from KhuyenMai if any
      await connection.query("DELETE FROM khuyenmai WHERE SanPhamID = ?", [id]);

      // Finally delete the product
      await connection.query("DELETE FROM sanpham WHERE SanPhamID = ?", [id]);

      // Clean up images from Cloudinary
      for (const image of images) {
        const publicId = image.URL.split("/").pop().split(".")[0];
        await cloudinary.uploader.destroy(publicId);
      }
    }

    await connection.commit();
    res.json({
      message:
        orders[0].count > 0
          ? "Sản phẩm đã được lưu trữ thành công"
          : "Sản phẩm đã được xóa hoàn toàn",
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi xóa/lưu trữ sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server khi xóa sản phẩm" });
  } finally {
    connection.release();
  }
};

// === HÀM KHÔI PHỤC SẢN PHẨM ===
exports.restoreProduct = async (req, res) => {
  try {
    const { id } = req.params;

    // 1. Kiểm tra sản phẩm tồn tại
    const [product] = await pool.query(
      "SELECT TrangThai FROM sanpham WHERE SanPhamID = ?",
      [id]
    );

    if (product.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }

    // 2. Kiểm tra sản phẩm có đang ở trạng thái ARCHIVED không
    if (product[0].TrangThai !== "ARCHIVED") {
      return res.status(400).json({ 
        message: "Chỉ có thể khôi phục sản phẩm đang ở trạng thái đã ẩn" 
      });
    }

    // 3. Cập nhật trạng thái về ACTIVE
    await pool.query(
      "UPDATE sanpham SET TrangThai = 'ACTIVE' WHERE SanPhamID = ?",
      [id]
    );

    res.json({ message: "Khôi phục sản phẩm thành công!" });
  } catch (error) {
    console.error("Lỗi khi khôi phục sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server khi khôi phục sản phẩm" });
  }
};

// === HÀM BÁN CHẠY & MỚI NHẤT (ĐÃ NÂNG CẤP) ===
exports.getBestSellingProducts = async (req, res) => {
  try {
    const [products] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc,
         (SELECT HinhAnh.URL FROM hinhanhsanpham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh,
         (SELECT MIN(pb_inner.GiaBan) FROM phienbansanpham AS pb_inner 
          WHERE pb_inner.SanPhamID = sp.SanPhamID) as GiaBan,
         SUM(ctdh.SoLuong) AS totalSold,
         
         -- === THÊM 2 CỜ BADGE ===
         IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
         (EXISTS (
             SELECT 1 FROM khuyenmai km
             LEFT JOIN danhmuc dm_sp ON sp.DanhMucID = dm_sp.DanhMucID
             WHERE (
               (km.SanPhamID IS NULL AND km.DanhMucID IS NULL)
               OR km.SanPhamID = sp.SanPhamID 
               OR km.DanhMucID = sp.DanhMucID 
               OR km.DanhMucID = dm_sp.DanhMucChaID
             )
             AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
             AND km.TrangThai = 'ACTIVE'
         )) AS HasVoucher
         -- =======================

       FROM chitietdonhang AS ctdh
       JOIN donhang AS dh ON ctdh.DonHangID = dh.DonHangID
       JOIN phienbansanpham AS pb ON ctdh.PhienBanID = pb.PhienBanID
       JOIN sanpham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE (dh.TrangThai = 'DA_GIAO' OR dh.TrangThai = 'DANG_XU_LY') 
         AND sp.TrangThai = 'ACTIVE'
       GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc
       ORDER BY totalSold DESC
       LIMIT 8`
    );
    res.json(products);
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm bán chạy:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
exports.getNewestProducts = async (req, res) => {
  try {
    const [products] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc, 
         (SELECT HinhAnh.URL 
          FROM hinhanhsanpham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh,
         (SELECT MIN(pb.GiaBan) 
          FROM phienbansanpham AS pb 
          WHERE pb.SanPhamID = sp.SanPhamID) as GiaBan,
          
          -- === THÊM 2 CỜ BADGE ===
          IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
          (EXISTS (
              SELECT 1 FROM khuyenmai km
              LEFT JOIN danhmuc dm_sp ON sp.DanhMucID = dm_sp.DanhMucID
              WHERE (
                (km.SanPhamID IS NULL AND km.DanhMucID IS NULL)
                OR km.SanPhamID = sp.SanPhamID 
                OR km.DanhMucID = sp.DanhMucID 
                OR km.DanhMucID = dm_sp.DanhMucChaID
              )
              AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
              AND km.TrangThai = 'ACTIVE'
          )) AS HasVoucher
          -- =======================

       FROM sanpham AS sp
       WHERE sp.TrangThai = 'ACTIVE'
       ORDER BY sp.NgayTao DESC
       LIMIT 16`
    );
    res.json(products);
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm mới nhất:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Lấy TẤT CẢ sản phẩm (kể cả DRAFT/ARCHIVED)
// @route   GET /api/admin/products
// @access  Private (Admin)
// server/src/controllers/productController.js (PHIÊN BẢN NÂNG CẤP)

// ... (các hàm khác)

// @desc    Admin: Lấy TẤT CẢ sản phẩm (có phân trang, tìm kiếm, lọc)
// @route   GET /api/admin/products
// @access  Private (Admin)
exports.getAdminProducts = async (req, res) => {
  try {
    const {
      search,
      status,
      sortBy = "DATE_DESC",
      page = 1,
      limit = 10,
    } = req.query;

    let conditions = [];
    let params = [];

    // Điều kiện tìm kiếm (ID, Tên sản phẩm, SKU)
    if (search) {
      // Kiểm tra nếu search term là số (ID)
      const searchAsNumber = parseInt(search);
      if (!isNaN(searchAsNumber)) {
        conditions.push(`(
          sp.SanPhamID = ? OR
          sp.TenSanPham LIKE ? OR
          pb.SKU LIKE ?
        )`);
        const searchTerm = `%${search}%`;
        params.push(searchAsNumber, searchTerm, searchTerm);
      } else {
        conditions.push(`(
          sp.TenSanPham LIKE ? OR
          pb.SKU LIKE ?
        )`);
        const searchTerm = `%${search}%`;
        params.push(searchTerm, searchTerm);
      }
    }

    // Điều kiện trạng thái
    if (status) {
      conditions.push("sp.TrangThai = ?");
      params.push(status);
    } else {
      // Mặc định chỉ hiển thị ACTIVE, DRAFT, ARCHIVED nếu không lọc cụ thể
      conditions.push("sp.TrangThai IN ('ACTIVE', 'DRAFT', 'ARCHIVED')");
    }

    // Tạo WHERE clause
    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    // ORDER BY clause
    const sortOrder =
      {
        DATE_DESC: "sp.NgayTao DESC",
        DATE_ASC: "sp.NgayTao ASC",
        PRICE_ASC: "GiaBanThapNhat ASC", // Sắp xếp theo alias
        PRICE_DESC: "GiaBanThapNhat DESC",
        STOCK_DESC: "TongTonKho DESC",
        STOCK_ASC: "TongTonKho ASC",
      }[sortBy] || "sp.NgayTao DESC";

    // Tính toán OFFSET
    const offset = (Number(page) - 1) * Number(limit);

    // Query đếm tổng số sản phẩm KHỚP (Quan trọng: Phải sử dụng GROUP BY)
    const countQuery = `
       SELECT COUNT(T.SanPhamID) AS total
       FROM (
          SELECT sp.SanPhamID
          FROM sanpham sp
          LEFT JOIN phienbansanpham pb ON sp.SanPhamID = pb.SanPhamID
          ${whereClause}
          GROUP BY sp.SanPhamID
       ) AS T
    `;

    // Thực hiện Count Query
    const [countResult] = await pool.query(countQuery, params);
    const total = countResult[0].total;
    const totalPages = Math.ceil(total / Number(limit));

    // Query chính để lấy danh sách sản phẩm
    const [products] = await pool.query(
      `SELECT 
        sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc, sp.TrangThai, sp.NgayTao,
        (SELECT HinhAnh.URL FROM hinhanhsanpham AS HinhAnh 
         WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
         LIMIT 1) as HinhAnhChinh,
        MIN(pb.GiaBan) as GiaBanThapNhat,
        SUM(pb.SoLuongTonKho) as TongTonKho
       FROM sanpham AS sp
       LEFT JOIN phienbansanpham AS pb ON sp.SanPhamID = pb.SanPhamID
       ${whereClause}
       GROUP BY sp.SanPhamID
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      products,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách sản phẩm Admin:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách sản phẩm",
      error: error.message,
    });
  }
};
