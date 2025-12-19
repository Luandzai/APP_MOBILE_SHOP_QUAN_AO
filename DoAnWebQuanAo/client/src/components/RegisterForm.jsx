// client/src/components/RegisterForm.jsx

import React, { useState } from "react";
import { Form, Button, Alert } from "react-bootstrap";
import axios from "axios"; // Import axios

// Tạo một instance axios (bạn cũng có thể import 'api' từ AuthContext nếu muốn)
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
});

const RegisterForm = ({ onRegisterSuccess }) => {
  const [hoTen, setHoTen] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  // States mới cho loading và thông báo
  const [message, setMessage] = useState(null);
  const [loading, setLoading] = useState(false);

  // 2. Sửa hàm submit thành 'async'
  const submitHandler = async (e) => {
    e.preventDefault();

    if (password !== confirmPassword) {
      setMessage({ type: "danger", text: "Mật khẩu không khớp!" });
      return;
    }

    setLoading(true); // Bắt đầu loading
    setMessage(null);

    try {
      // 3. Gọi API Đăng ký
      const config = {
        headers: {
          "Content-Type": "application/json",
        },
      };
      const { data } = await api.post(
        "/auth/register",
        { HoTen: hoTen, Email: email, MatKhau: password }, // Gửi MatKhau (Back-end sẽ tự hash)
        config
      );

      setLoading(false);
      setMessage({
        type: "success",
        text: "Đăng ký thành công! Đang chuyển về trang đăng nhập...",
      });
      
      // Chuyển về trang đăng nhập sau 1.5 giây
      setTimeout(() => {
        if (onRegisterSuccess) {
          onRegisterSuccess();
        }
      }, 1500);
    } catch (error) {
      setLoading(false);
      // 4. Bắt lỗi từ back-end
      setMessage({
        type: "danger",
        text: error.response?.data?.message || "Đã xảy ra lỗi",
      });
    }
  };

  return (
    <Form onSubmit={submitHandler}>
      {/* 5. Hiển thị thông báo (thành công hoặc lỗi) */}
      {message && <Alert variant={message.type}>{message.text}</Alert>}

      {/* Các trường Form (giữ nguyên) */}
      <Form.Group className="mb-3" controlId="registerHoTen">
        <Form.Label>Họ và Tên</Form.Label>
        <Form.Control
          type="text"
          placeholder="Nhập họ tên"
          value={hoTen}
          onChange={(e) => setHoTen(e.target.value)}
          required
        />
      </Form.Group>

      <Form.Group className="mb-3" controlId="registerEmail">
        <Form.Label>Địa chỉ Email</Form.Label>
        <Form.Control
          type="email"
          placeholder="Nhập email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
      </Form.Group>

      <Form.Group className="mb-3" controlId="registerPassword">
        <Form.Label>Mật khẩu</Form.Label>
        <Form.Control
          type="password"
          placeholder="Nhập mật khẩu"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </Form.Group>

      <Form.Group className="mb-3" controlId="registerConfirmPassword">
        <Form.Label>Xác nhận Mật khẩu</Form.Label>
        <Form.Control
          type="password"
          placeholder="Xác nhận"
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          required
        />
      </Form.Group>

      {/* 6. Vô hiệu hóa nút khi đang loading */}
      <Button
        variant="primary"
        type="submit"
        className="w-100"
        disabled={loading}
      >
        {loading ? "Đang xử lý..." : "Đăng ký"}
      </Button>
    </Form>
  );
};

export default RegisterForm;
