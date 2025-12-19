// server/src/index.js
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const axios = require("axios");
require("./config/db");

// Import services
const { searchProductsForAI } = require("./services/chatService");

// Import routes
const authRoutes = require("./routes/authRoutes");
const productRoutes = require("./routes/productRoutes");
const cartRoutes = require("./routes/cartRoutes");
const userRoutes = require("./routes/userRoutes");
const orderRoutes = require("./routes/orderRoutes");
const reviewRoutes = require("./routes/reviewRoutes");
const voucherRoutes = require("./routes/voucherRoutes");
const wishlistRoutes = require("./routes/wishlistRoutes");
const shippingRoutes = require("./routes/shippingRoutes");
const locationRoutes = require("./routes/locationRoutes");
const returnsRoutes = require("./routes/returnsRoutes");
const categoryRoutes = require("./routes/categoryRoutes");
const attributeRoutes = require("./routes/attributeRoutes");
const adminRoutes = require("./routes/adminRoutes");
const adminOrderRoutes = require("./routes/adminOrderRoutes");
const contactRoutes = require("./routes/contactRoutes");
const paymentRoutes = require("./routes/paymentRoutes");
const tryOnRoutes = require("./routes/tryOnRoutes");
const sizeChartRoutes = require("./routes/sizeChartRoutes");

// Import scheduler for auto-updating voucher status
const { startVoucherScheduler } = require("./utils/voucherScheduler");
// Import scheduler for auto-canceling unpaid orders
const { startOrderScheduler } = require("./utils/orderScheduler");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));

// --- API CHATBOT (Groq - Llama 3 + RAG + Rich UI) ---
app.post("/api/chat", async (req, res) => {
  const { message, history } = req.body;

  if (!message) {
    return res.status(400).json({ reply: "Vui lòng nhập tin nhắn." });
  }

  const apiKey = process.env.GROQ_API_KEY;
  const apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  try {
    // 1. TÌM KIẾM SẢN PHẨM (Lấy cả Context Text và Mảng Sản Phẩm)
    const { context, products } = await searchProductsForAI(message);

    // 2. Xử lý lịch sử chat
    const contextHistory = Array.isArray(history) ? history.slice(-10) : [];

    // 3. Tạo System Prompt thông minh hơn
    const systemPrompt = `
Bạn là Stylist ảo của shop thời trang "Blank Canvas".
Nhiệm vụ: Tư vấn thời trang và hỗ trợ tìm kiếm sản phẩm cho khách hàng.

QUAN TRỌNG - DỮ LIỆU KHO HÀNG THỰC TẾ:
${
  context
    ? context
    : "Hiện tại không tìm thấy sản phẩm nào khớp chính xác trong kho với từ khóa của khách. Hãy tư vấn chung chung hoặc gợi ý khách xem danh mục khác."
}

Nguyên tắc trả lời:
1. Dựa vào "DỮ LIỆU KHO HÀNG THỰC TẾ" ở trên để trả lời. Nếu có sản phẩm khớp, hãy giới thiệu Tên và Giá.
2. Nếu sản phẩm "Hết hàng", hãy báo khách biết.
3. Phong cách: Ngắn gọn, trẻ trung, thân thiện, dùng emoji 😊✨.
4. Nếu khách hỏi thứ không liên quan đến thời trang/shop, hãy từ chối lịch sự.
5. KHÔNG được bịa ra sản phẩm không có trong danh sách trên.
        `;

    const payload = {
      model: "llama-3.3-70b-versatile",
      messages: [
        { role: "system", content: systemPrompt },
        ...contextHistory,
        { role: "user", content: message },
      ],
      temperature: 0.5,
      max_tokens: 300,
    };

    const response = await axios.post(apiUrl, payload, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
    });

    const reply =
      response.data?.choices?.[0]?.message?.content ||
      "Mình chưa nghĩ ra câu trả lời phù hợp 😅";

    // 4. TRẢ VỀ JSON: Lời nhắn của AI + Danh sách sản phẩm (để Frontend hiển thị Card)
    res.json({
      reply,
      suggestedProducts: products, // Mảng sản phẩm cho Rich UI
    });
  } catch (error) {
    console.error("❌ Lỗi API Chatbot:", error.response?.data || error.message);
    res
      .status(500)
      .json({ reply: "Stylist đang bận kiểm tra kho, thử lại sau nha 😅" });
  }
});

// Một route API test
app.get("/api", (req, res) => {
  res.json({ message: "Chào mừng bạn đến với API bán quần áo!" });
});

// Sử dụng routes
app.use("/api/auth", authRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/products", productRoutes);
app.use("/api/user", userRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/reviews", reviewRoutes);
app.use("/api/vouchers", voucherRoutes);
app.use("/api/wishlist", wishlistRoutes);
app.use("/api/shipping", shippingRoutes);
app.use("/api/locations", locationRoutes);
app.use("/api/returns", returnsRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/attributes", attributeRoutes);
app.use("/api/contact", contactRoutes);
app.use("/api/payment", paymentRoutes);
app.use("/api/try-on", tryOnRoutes);
app.use("/api/sizecharts", sizeChartRoutes);

// Admin routes
app.use("/api/admin/orders", adminOrderRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/admin/returns", returnsRoutes);

app.listen(PORT, () => {
  console.log(`Server đang chạy tại http://localhost:${PORT}`);
  // Khởi động voucher scheduler để tự động vô hiệu hóa voucher hết hạn/hết lượt
  startVoucherScheduler();
  // Khởi động order scheduler để tự động hủy đơn chưa thanh toán sau 15 phút
  startOrderScheduler();
});

