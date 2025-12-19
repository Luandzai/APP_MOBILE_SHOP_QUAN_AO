// server/src/services/chatService.js
const pool = require("../config/db");

// Danh sách các từ vô nghĩa cần loại bỏ khi tìm kiếm
const STOP_WORDS = [
  "shop",
  "có",
  "không",
  "cho",
  "em",
  "mình",
  "cần",
  "muốn",
  "tìm",
  "với",
  "là",
  "nhé",
  "ạ",
  "hỏi",
  "giá",
  "bao",
  "nhiêu",
  "bán",
  "còn",
  "hàng",
];

/**
 * Tìm kiếm sản phẩm thông minh dựa trên độ khớp từ khóa (Relevance Scoring)
 * Trả về cả Context cho AI và Danh sách sản phẩm thô cho Client (Rich UI)
 */
const searchProductsForAI = async (userMessage) => {
  try {
    // 1. XỬ LÝ CHUỖI
    let cleanMsg = userMessage
      .toLowerCase()
      .replace(/[^\w\sà-ỹ]/g, " ")
      .trim();

    // Tách từ và lọc bỏ Stop Words + từ quá ngắn
    const tokens = cleanMsg
      .split(/\s+/)
      .filter((w) => w.length > 1 && !STOP_WORDS.includes(w));

    // Nếu không có từ khóa nào rõ ràng (ví dụ chỉ gõ "shop ơi"), trả về rỗng
    if (tokens.length === 0) return { context: "", products: [] };

    console.log("🔍 AI đang quét các từ khóa quan trọng:", tokens);

    // 2. TẠO CÂU QUERY ĐỘNG
    const likeClauses = tokens
      .map(() => `(LOWER(sp.TenSanPham) LIKE ? OR LOWER(dm.TenDanhMuc) LIKE ?)`)
      .join(" OR ");
    const queryParams = [];
    tokens.forEach((token) => {
      queryParams.push(`%${token}%`, `%${token}%`);
    });

    // 3. QUERY DATABASE
    const [products] = await pool.query(
      `
      SELECT 
        sp.SanPhamID,
        sp.TenSanPham, 
        sp.Slug, 
        MIN(pb.GiaBan) as GiaTu,
        SUM(pb.SoLuongTonKho) as TongTonKho,
        dm.TenDanhMuc,
        (SELECT URL FROM hinhanhsanpham WHERE SanPhamID = sp.SanPhamID AND LaAnhChinh = 1 LIMIT 1) as HinhAnh
      FROM sanpham sp
      LEFT JOIN danhmuc dm ON sp.DanhMucID = dm.DanhMucID
      LEFT JOIN phienbansanpham pb ON sp.SanPhamID = pb.SanPhamID
      WHERE 
        sp.TrangThai = 'ACTIVE'
        AND (${likeClauses})
      GROUP BY sp.SanPhamID
      `,
      queryParams
    );

    // 4. THUẬT TOÁN CHẤM ĐIỂM (SCORING)
    const scoredProducts = products.map((p) => {
      let score = 0;
      const nameLower = p.TenSanPham.toLowerCase();
      const catLower = p.TenDanhMuc.toLowerCase();

      tokens.forEach((token) => {
        // Cộng điểm nếu khớp tên SP hoặc Danh mục
        if (nameLower.includes(token) || catLower.includes(token)) {
          score += 1;
        }
      });

      return { ...p, score };
    });

    // 5. LỌC THÔNG MINH (SMART FILTERING)

    // Tìm điểm số cao nhất đạt được trong danh sách kết quả
    // Ví dụ: "Áo thun" -> Max Score = 2 (khớp cả 'áo' và 'thun')
    const maxScore = Math.max(...scoredProducts.map((p) => p.score), 0);

    // Chỉ giữ lại những sản phẩm có điểm số TỐT NHẤT
    // Nếu Max Score >= 2 (khớp nhiều từ), ta chỉ lấy những cái bằng Max Score.
    // Nếu Max Score = 1 (chỉ khớp 1 từ), ta lấy cái đó.
    const bestMatches = scoredProducts
      .filter((p) => {
        // Nếu tìm được sp khớp nhiều từ (>=2), loại bỏ những sp chỉ khớp 1 từ
        if (maxScore > 1) return p.score >= maxScore;
        return p.score >= 1;
      })
      .sort((a, b) => b.score - a.score) // Sắp xếp điểm cao lên đầu
      .slice(0, 5); // Lấy top 5

    if (bestMatches.length === 0) return { context: "", products: [] };

    // 6. FORMAT KẾT QUẢ CHO AI (Context Text)
    let contextText = `Dưới đây là danh sách sản phẩm thực tế:\n`;

    bestMatches.forEach((p, index) => {
      const status = p.TongTonKho > 0 ? "Còn hàng" : "Hết hàng";
      const price = new Intl.NumberFormat("vi-VN", {
        style: "currency",
        currency: "VND",
      }).format(p.GiaTu || 0);

      contextText += `${index + 1}. ${
        p.TenSanPham
      } - Giá: ${price} - ${status}\n`;
    });

    return {
      context: contextText,
      products: bestMatches,
    };
  } catch (error) {
    console.error("❌ Lỗi tìm kiếm sản phẩm cho AI:", error);
    return { context: "", products: [] };
  }
};

module.exports = { searchProductsForAI };
