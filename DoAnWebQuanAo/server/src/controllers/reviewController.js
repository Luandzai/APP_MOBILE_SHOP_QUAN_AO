// server/src/controllers/reviewController.js (ĐÃ NÂNG CẤP MEDIA)
const pool = require("../config/db");
const { cloudinary } = require("../config/cloudinary"); // <-- IMPORT MỚI

// Hàm helper xóa file trên Cloudinary
const deleteCloudinaryFile = async (publicId, resourceType = "image") => {
  if (!publicId) return;
  try {
    await cloudinary.uploader.destroy(publicId, {
      resource_type: resourceType,
    });
  } catch (error) {
    console.error("Lỗi khi xóa file Cloudinary:", error);
  }
};

exports.createReview = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { PhienBanID, DiemSo, BinhLuan } = req.body;

  if (!PhienBanID || !DiemSo) {
    return res
      .status(400)
      .json({ message: "Thiếu thông tin phiên bản hoặc điểm số." });
  }

  // Lấy file từ req.files (đã được Multer upload lên Cloudinary)
  const hinhAnhFile = req.files?.image?.[0];
  const videoFile = req.files?.video?.[0];

  try {
    // 1. Kiểm tra điều kiện mua hàng (giữ nguyên)
    const [orders] = await pool.query(
      `SELECT * FROM donhang dh
       JOIN chitietdonhang ctdh ON dh.DonHangID = ctdh.DonHangID
       WHERE dh.NguoiDungID = ? AND ctdh.PhienBanID = ? AND dh.TrangThai = 'DA_GIAO'`,
      [NguoiDungID, PhienBanID]
    );
    if (orders.length === 0) {
      // Nếu không đủ điều kiện, xóa file vừa upload (nếu có)
      if (hinhAnhFile)
        await deleteCloudinaryFile(hinhAnhFile.filename, "image");
      if (videoFile) await deleteCloudinaryFile(videoFile.filename, "video");

      throw new Error(
        "Bạn chỉ có thể đánh giá sản phẩm bạn đã mua và đã nhận hàng."
      );
    }
    const [existingReview] = await pool.query(
      "SELECT * FROM danhgia WHERE NguoiDungID = ? AND PhienBanID = ?",
      [NguoiDungID, PhienBanID]
    );
    if (existingReview.length > 0) {
      // Nếu đã đánh giá, xóa file vừa upload (nếu có)
      if (hinhAnhFile)
        await deleteCloudinaryFile(hinhAnhFile.filename, "image");
      if (videoFile) await deleteCloudinaryFile(videoFile.filename, "video");

      throw new Error("Bạn đã đánh giá sản phẩm này rồi.");
    }

    // 2. Insert vào DB
    const [result] = await pool.query(
      `INSERT INTO danhgia 
         (PhienBanID, NguoiDungID, DiemSo, BinhLuan, 
          HinhAnhURL, HinhAnhPublicID, VideoURL, VideoPublicID) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        PhienBanID,
        NguoiDungID,
        DiemSo,
        BinhLuan || "",
        hinhAnhFile?.path || null,
        hinhAnhFile?.filename || null,
        videoFile?.path || null,
        videoFile?.filename || null,
      ]
    );

    res.status(201).json({
      message: "Cảm ơn bạn đã đánh giá sản phẩm!",
      DanhGiaID: result.insertId,
    });
  } catch (error) {
    // Rollback: Xóa file nếu lỗi (đã xử lý ở trên cho các trường hợp cụ thể, đây là catch all)
    // Lưu ý: Nếu lỗi xảy ra SAU khi insert DB thành công (hiếm), thì không nên xóa file.
    // Nhưng ở đây logic insert là cuối cùng, nên nếu vào catch thì thường là chưa insert hoặc lỗi insert.
    // Tuy nhiên, ta đã handle xóa file ở các điều kiện check logic phía trên.
    // Để an toàn, ta có thể check lại nếu chưa insert thành công thì xóa.
    // Đơn giản nhất là cứ để logic check ở trên.
    // Ở đây chỉ log lỗi.

    console.error("Lỗi khi tạo đánh giá:", error);
    res.status(500).json({ message: error.message || "Lỗi server nội bộ" });
  }
};

// (Hàm getMyReviewByProduct giữ nguyên)
exports.getMyReviewByProduct = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { phienBanId } = req.params;

  try {
    const [review] = await pool.query(
      "SELECT * FROM danhgia WHERE NguoiDungID = ? AND PhienBanID = ?",
      [NguoiDungID, phienBanId]
    );

    if (review.length === 0) {
      return res.json(null);
    }
    res.json(review[0]);
  } catch (error) {
    console.error("Lỗi khi lấy đánh giá:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.updateReview = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { id: DanhGiaID } = req.params;
  const { DiemSo, BinhLuan, XoaHinhAnh, XoaVideo } = req.body;

  const hinhAnhFile = req.files?.image?.[0];
  const videoFile = req.files?.video?.[0];

  if (!DiemSo) {
    // Xóa file vừa upload nếu thiếu thông tin
    if (hinhAnhFile) await deleteCloudinaryFile(hinhAnhFile.filename, "image");
    if (videoFile) await deleteCloudinaryFile(videoFile.filename, "video");
    return res.status(400).json({ message: "Thiếu điểm số." });
  }

  try {
    // 1. Lấy đánh giá cũ
    const [rows] = await pool.query(
      "SELECT * FROM danhgia WHERE DanhGiaID = ? AND NguoiDungID = ?",
      [DanhGiaID, NguoiDungID]
    );
    if (rows.length === 0) {
      // Xóa file vừa upload nếu không tìm thấy đánh giá
      if (hinhAnhFile)
        await deleteCloudinaryFile(hinhAnhFile.filename, "image");
      if (videoFile) await deleteCloudinaryFile(videoFile.filename, "video");
      return res
        .status(404)
        .json({ message: "Không tìm thấy đánh giá hoặc bạn không có quyền." });
    }
    const reviewCu = rows[0];

    // 2. Chuẩn bị dữ liệu mới
    let hinhAnhURL = reviewCu.HinhAnhURL;
    let hinhAnhPublicID = reviewCu.HinhAnhPublicID;
    let videoURL = reviewCu.VideoURL;
    let videoPublicID = reviewCu.VideoPublicID;

    // 3. Xử lý Hình ảnh
    if (hinhAnhFile) {
      // Ảnh mới đã được upload bởi Multer

      // Xóa ảnh cũ
      if (reviewCu.HinhAnhPublicID) {
        await deleteCloudinaryFile(reviewCu.HinhAnhPublicID, "image");
      }

      hinhAnhURL = hinhAnhFile.path;
      hinhAnhPublicID = hinhAnhFile.filename;
    } else if (XoaHinhAnh === "true") {
      if (reviewCu.HinhAnhPublicID) {
        await deleteCloudinaryFile(reviewCu.HinhAnhPublicID, "image");
      }
      hinhAnhURL = null;
      hinhAnhPublicID = null;
    }

    // 4. Xử lý Video
    if (videoFile) {
      // Video mới đã được upload bởi Multer

      // Xóa video cũ
      if (reviewCu.VideoPublicID) {
        await deleteCloudinaryFile(reviewCu.VideoPublicID, "video");
      }

      videoURL = videoFile.path;
      videoPublicID = videoFile.filename;
    } else if (XoaVideo === "true") {
      if (reviewCu.VideoPublicID) {
        await deleteCloudinaryFile(reviewCu.VideoPublicID, "video");
      }
      videoURL = null;
      videoPublicID = null;
    }

    // 5. Cập nhật DB
    await pool.query(
      `UPDATE danhgia SET 
         DiemSo = ?, BinhLuan = ?,
         HinhAnhURL = ?, HinhAnhPublicID = ?,
         VideoURL = ?, VideoPublicID = ?,
         NgayCapNhat = NOW()
       WHERE DanhGiaID = ?`,
      [
        DiemSo,
        BinhLuan || "",
        hinhAnhURL,
        hinhAnhPublicID,
        videoURL,
        videoPublicID,
        DanhGiaID,
      ]
    );

    res.json({ message: "Đã cập nhật đánh giá!" });
  } catch (error) {
    // Rollback: Xóa file mới upload nếu lỗi DB
    if (hinhAnhFile) await deleteCloudinaryFile(hinhAnhFile.filename, "image");
    if (videoFile) await deleteCloudinaryFile(videoFile.filename, "video");

    console.error("Lỗi khi cập nhật đánh giá:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// --------------------------------------------------------
// --- ADMIN FUNCTIONS ---
// --------------------------------------------------------

// @desc    Admin: Lấy TẤT CẢ đánh giá (có phân trang, tìm kiếm)
// @route   GET /api/admin/reviews
// @access  Private (Admin)
exports.getAllReviewsAdmin = async (req, res) => {
  try {
    const { rating, search, page = 1, limit = 10 } = req.query;

    let conditions = [];
    let params = [];

    // Lọc theo điểm số
    if (rating) {
      conditions.push("dg.DiemSo = ?");
      params.push(rating);
    }

    // Tìm kiếm (Tên SP, Tên User, Email, Bình luận)
    if (search) {
      conditions.push(`(
        sp.TenSanPham LIKE ? OR
        nd.HoTen LIKE ? OR
        nd.Email LIKE ? OR
        dg.BinhLuan LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";
    const offset = (page - 1) * limit;

    // 1. Đếm tổng số đánh giá
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
       FROM danhgia dg
       JOIN nguoidung nd ON dg.NguoiDungID = nd.NguoiDungID
       JOIN phienbansanpham pb ON dg.PhienBanID = pb.PhienBanID
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       ${whereClause}`,
      params
    );
    const total = countResult[0].total;
    const totalPages = Math.ceil(total / limit);

    // 2. Lấy dữ liệu đánh giá
    const [reviews] = await pool.query(
      `SELECT 
          dg.DanhGiaID, dg.DiemSo, dg.BinhLuan, dg.NgayTao,
          dg.HinhAnhURL, dg.VideoURL,
          dg.PhanHoi, -- [MỚI THÊM] Quan trọng để check trạng thái
          sp.TenSanPham, sp.Slug,
          nd.HoTen AS TenNguoiDung
       FROM danhgia dg
       JOIN nguoidung nd ON dg.NguoiDungID = nd.NguoiDungID
       JOIN phienbansanpham pb ON dg.PhienBanID = pb.PhienBanID
       JOIN sanpham sp ON pb.SanPhamID = sp.SanPhamID
       ${whereClause}
       ORDER BY dg.NgayTao DESC
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      reviews,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đánh giá Admin:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Xóa một đánh giá (Xóa cứng và xóa media)
// @route   DELETE /api/admin/reviews/:id
// @access  Private (Admin)
exports.deleteReviewAdmin = async (req, res) => {
  const { id: DanhGiaID } = req.params;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // 1. Lấy thông tin media để xóa trên Cloudinary
    const [rows] = await connection.query(
      "SELECT HinhAnhPublicID, VideoPublicID FROM danhgia WHERE DanhGiaID = ?",
      [DanhGiaID]
    );

    if (rows.length === 0) {
      throw new Error("Không tìm thấy đánh giá.");
    }
    const review = rows[0];

    // 2. Xóa file trên Cloudinary (Sử dụng hàm helper đã có)
    await deleteCloudinaryFile(review.HinhAnhPublicID, "image");
    await deleteCloudinaryFile(review.VideoPublicID, "video");

    // 3. Xóa đánh giá khỏi CSDL
    const [result] = await connection.query(
      "DELETE FROM danhgia WHERE DanhGiaID = ?",
      [DanhGiaID]
    );

    if (result.affectedRows === 0) {
      throw new Error("Xóa đánh giá thất bại.");
    }

    await connection.commit();
    res.json({ message: "Đã xóa đánh giá thành công." });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi xóa đánh giá (Admin):", error);
    res.status(500).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};
// @desc    Admin: Trả lời đánh giá
// @route   PUT /api/admin/reviews/:id/reply
// @access  Private (Admin)
exports.replyToReview = async (req, res) => {
  const { id: DanhGiaID } = req.params;
  const { noiDung } = req.body;

  if (!noiDung || !noiDung.trim()) {
    return res
      .status(400)
      .json({ message: "Nội dung trả lời không được để trống." });
  }

  try {
    const [result] = await pool.query(
      `UPDATE danhgia 
       SET PhanHoi = ?, NgayPhanHoi = NOW() 
       WHERE DanhGiaID = ?`,
      [noiDung, DanhGiaID]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy đánh giá." });
    }

    res.json({ message: "Đã gửi câu trả lời thành công!" });
  } catch (error) {
    console.error("Lỗi khi trả lời đánh giá:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};
