// client/src/components/Chatbot.jsx
import React, { useState, useRef, useEffect } from "react";
import "./Chatbot.css";
import { BiCommentDetail, BiSend, BiX } from "react-icons/bi";
import axios from "axios";
import { Link } from "react-router-dom"; // Import Link để chuyển trang

const Chatbot = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [inputStr, setInputStr] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  // Thêm products vào cấu trúc tin nhắn
  const [messages, setMessages] = useState([
    {
      text: "Chào bạn! Mình là Stylist ảo của Blank Canvas. Bạn cần tư vấn chọn đồ gì hôm nay nhỉ? ✨",
      isBot: true,
      products: [], // Mảng sản phẩm gợi ý
    },
  ]);

  const messagesEndRef = useRef(null);
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };
  useEffect(scrollToBottom, [messages]);

  const handleSend = async () => {
    if (!inputStr.trim()) return;

    const currentUserMessage = inputStr;
    const userMsgObj = { text: currentUserMessage, isBot: false, products: [] };

    setMessages((prev) => [...prev, userMsgObj]);
    setInputStr("");
    setIsLoading(true);

    try {
      const historyPayload = messages.map((msg) => ({
        role: msg.isBot ? "assistant" : "user",
        content: msg.text,
      }));

      // Gọi API
      const response = await axios.post(`${import.meta.env.VITE_API_URL}/chat`, {
        message: currentUserMessage,
        history: historyPayload,
      });

      // Lấy text VÀ danh sách sản phẩm từ response
      const botMsg = {
        text: response.data.reply,
        isBot: true,
        products: response.data.suggestedProducts || [], // Lưu mảng sản phẩm
      };

      setMessages((prev) => [...prev, botMsg]);
    } catch (error) {
      console.error("Lỗi gửi tin nhắn:", error);
      const errorMsg = {
        text: "⚠️ Mất kết nối tới server stylist.",
        isBot: true,
      };
      setMessages((prev) => [...prev, errorMsg]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter" && !isLoading) handleSend();
  };

  const formatPrice = (price) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(price);
  };

  return (
    <>
      {!isOpen && (
        <div className="chatbot-bubble" onClick={() => setIsOpen(true)}>
          <BiCommentDetail />
        </div>
      )}

      {isOpen && (
        <div className="chatbot-window">
          <div className="chatbot-header">
            <span>Blank Canvas Stylist AI ✨</span>
            <BiX
              size={24}
              style={{ cursor: "pointer" }}
              onClick={() => setIsOpen(false)}
            />
          </div>

          <div className="chatbot-messages">
            {messages.map((msg, index) => (
              <div
                key={index}
                className={`message-container ${
                  msg.isBot ? "bot-container" : "user-container"
                }`}
                style={{
                  display: "flex",
                  flexDirection: "column",
                  alignItems: msg.isBot ? "flex-start" : "flex-end",
                }}
              >
                {/* 1. Tin nhắn Text */}
                <div className={`message ${msg.isBot ? "bot" : "user"}`}>
                  {msg.text}
                </div>

                {/* 2. RICH UI: Hiển thị danh sách sản phẩm (Nếu có) */}
                {msg.isBot && msg.products && msg.products.length > 0 && (
                  <div className="chat-product-list">
                    {msg.products.map((p) => (
                      <Link
                        to={`/product/${p.Slug}`}
                        key={p.SanPhamID}
                        className="chat-product-card"
                        onClick={() => setIsOpen(false)} // Đóng chat khi click xem
                      >
                        <img
                          src={
                            p.HinhAnh ||
                            "https://placehold.co/150x150?text=No+Img"
                          }
                          alt={p.TenSanPham}
                          className="chat-product-img"
                        />
                        <div className="chat-product-info">
                          <div
                            className="chat-product-name"
                            title={p.TenSanPham}
                          >
                            {p.TenSanPham}
                          </div>
                          <div className="chat-product-price">
                            {formatPrice(p.GiaTu)}
                          </div>
                        </div>
                      </Link>
                    ))}
                  </div>
                )}
              </div>
            ))}

            {isLoading && (
              <div className="typing">Stylist đang tìm sản phẩm...</div>
            )}
            <div ref={messagesEndRef} />
          </div>

          <div className="chatbot-input">
            <input
              type="text"
              placeholder="Nhập tin nhắn..."
              value={inputStr}
              onChange={(e) => setInputStr(e.target.value)}
              onKeyDown={handleKeyPress}
              disabled={isLoading}
            />
            <button
              onClick={handleSend}
              disabled={isLoading || !inputStr.trim()}
            >
              <BiSend />
            </button>
          </div>
        </div>
      )}
    </>
  );
};

export default Chatbot;
