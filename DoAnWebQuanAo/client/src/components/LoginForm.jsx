// client/src/components/LoginForm.jsx

import React, { useState, useContext } from "react";
import { Form, Button, Alert } from "react-bootstrap";
// 1. Import AuthContext
import AuthContext from "../context/AuthContext";

const LoginForm = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  // States mới
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  // 2. Lấy hàm 'login' từ Context
  const { login } = useContext(AuthContext);

  // 3. Sửa hàm submit
  const submitHandler = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // 4. Gọi hàm login từ Context
      await login(email, password);
      // (AuthContext sẽ tự động chuyển hướng nếu thành công)
    } catch (err) {
      setLoading(false);
      // 5. Bắt lỗi (ví dụ: "Email hoặc mật khẩu không chính xác")
      setError(err.message || "Đã xảy ra lỗi");
    }
  };

  return (
    <Form onSubmit={submitHandler}>
      {/* 6. Hiển thị lỗi */}
      {error && <Alert variant="danger">{error}</Alert>}

      <Form.Group className="mb-3" controlId="loginEmail">
        <Form.Label>Địa chỉ Email</Form.Label>
        <Form.Control
          type="email"
          placeholder="Nhập email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
      </Form.Group>

      <Form.Group className="mb-3" controlId="loginPassword">
        <Form.Label>Mật khẩu</Form.Label>
        <Form.Control
          type="password"
          placeholder="Nhập mật khẩu"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </Form.Group>

      {/* 7. Vô hiệu hóa nút khi đang loading */}
      <Button
        variant="primary"
        type="submit"
        className="w-100"
        disabled={loading}
      >
        {loading ? "Đang đăng nhập..." : "Đăng nhập"}
      </Button>
    </Form>
  );
};

export default LoginForm;
