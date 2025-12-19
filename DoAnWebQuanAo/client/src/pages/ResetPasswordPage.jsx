// client/src/pages/ResetPasswordPage.jsx (File MỚI)

import React, { useState, useContext } from "react";
import {
  Container,
  Row,
  Col,
  Card,
  Form,
  Button,
  Alert,
  Spinner,
} from "react-bootstrap";
import { Link, useParams, useNavigate } from "react-router-dom";
import AuthContext from "../context/AuthContext";

const ResetPasswordPage = () => {
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const { api } = useContext(AuthContext);
  const { token } = useParams(); // Lấy token từ URL
  const navigate = useNavigate();

  const submitHandler = async (e) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      setError("Mật khẩu không khớp!");
      return;
    }

    setLoading(true);
    setMessage("");
    setError("");

    try {
      const { data } = await api.put(`/auth/reset-password/${token}`, {
        password,
      });
      setMessage(data.message);
      // Tự động chuyển về trang đăng nhập sau 3s
      setTimeout(() => {
        navigate("/auth");
      }, 3000);
    } catch (err) {
      setError(err.response?.data?.message || "Đã xảy ra lỗi");
    } finally {
      setLoading(false);
    }
  };

  return (
    // Dùng chung CSS với trang Auth
    <div className="auth-page-wrapper">
      <Container>
        <Row className="justify-content-center">
          <Col md={6}>
            <Card className="shadow-lg auth-card-container">
              <div className="auth-form-content">
                <h3 className="text-center mb-4 fw-bold">Đặt Lại Mật Khẩu</h3>
                {message && (
                  <Alert variant="success">
                    {message} Sẽ tự động chuyển hướng...
                  </Alert>
                )}
                {error && <Alert variant="danger">{error}</Alert>}

                <Form onSubmit={submitHandler}>
                  <Form.Group className="mb-3" controlId="resetPassword">
                    <Form.Label>Mật khẩu mới</Form.Label>
                    <Form.Control
                      type="password"
                      placeholder="Nhập mật khẩu mới"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                    />
                  </Form.Group>
                  <Form.Group className="mb-3" controlId="resetConfirmPassword">
                    <Form.Label>Xác nhận mật khẩu mới</Form.Label>
                    <Form.Control
                      type="password"
                      placeholder="Xác nhận mật khẩu"
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                      required
                    />
                  </Form.Group>

                  <Button
                    variant="primary"
                    type="submit"
                    className="w-100"
                    disabled={loading || message} // Vô hiệu hóa nếu đang tải hoặc đã thành công
                  >
                    {loading ? (
                      <Spinner as="span" animation="border" size="sm" />
                    ) : (
                      "Đặt Lại Mật Khẩu"
                    )}
                  </Button>
                </Form>
              </div>
            </Card>
          </Col>
        </Row>
      </Container>
    </div>
  );
};

export default ResetPasswordPage;
