// client/src/pages/ForgotPasswordPage.jsx (File MỚI)

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
import { Link } from "react-router-dom";
import AuthContext from "../context/AuthContext";

const ForgotPasswordPage = () => {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const { api } = useContext(AuthContext);

  const submitHandler = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage("");
    setError("");
    try {
      const { data } = await api.post("/auth/forgot-password", { email });
      setMessage(data.message);
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
                <h3 className="text-center mb-4 fw-bold">Quên Mật Khẩu</h3>
                {message && <Alert variant="success">{message}</Alert>}
                {error && <Alert variant="danger">{error}</Alert>}

                <p className="text-muted">
                  Nhập email của bạn. Chúng tôi sẽ gửi một liên kết để đặt lại
                  mật khẩu (chỉ áp dụng cho tài khoản đăng ký bằng email).
                </p>

                <Form onSubmit={submitHandler}>
                  <Form.Group className="mb-3" controlId="forgotEmail">
                    <Form.Label>Địa chỉ Email</Form.Label>
                    <Form.Control
                      type="email"
                      placeholder="Nhập email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                    />
                  </Form.Group>

                  <Button
                    variant="primary"
                    type="submit"
                    className="w-100"
                    disabled={loading}
                  >
                    {loading ? (
                      <Spinner as="span" animation="border" size="sm" />
                    ) : (
                      "Gửi yêu cầu"
                    )}
                  </Button>
                </Form>
                <div className="text-center mt-3">
                  <Button as={Link} to="/auth" variant="link" size="sm">
                    Quay lại Đăng nhập
                  </Button>
                </div>
              </div>
            </Card>
          </Col>
        </Row>
      </Container>
    </div>
  );
};

export default ForgotPasswordPage;
