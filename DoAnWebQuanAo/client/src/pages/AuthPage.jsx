// client/src/pages/AuthPage.jsx (Nội dung HOÀN CHỈNH)

import React, { useState, useContext } from "react";
import {
  Container,
  Row,
  Col,
  Card,
  Image,
  Button,
  Alert,
  Spinner,
} from "react-bootstrap";
import { GoogleLogin } from "@react-oauth/google";
import { Link } from "react-router-dom";

import LoginForm from "../components/LoginForm";
import RegisterForm from "../components/RegisterForm";
import AuthContext from "../context/AuthContext";
import "./AuthPage.css";

// Import ảnh minh họa (Bạn cần đảm bảo các đường dẫn này là đúng)
import authImage from "../assets/ANH_BIA.jpg";
import authLogo from "../assets/LOGO.jpg";

const AuthPage = () => {
  const [isLoginView, setIsLoginView] = useState(true);

  // Lấy hàm từ Context
  const { googleLogin } = useContext(AuthContext);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  // Hàm xử lý khi Google đăng nhập thành công
  const handleGoogleSuccess = async (credentialResponse) => {
    setLoading(true);
    setError(null);
    try {
      // credentialResponse.credential là token Google gửi về
      await googleLogin(credentialResponse.credential);
      // Nếu thành công, AuthContext sẽ tự động chuyển hướng
    } catch (err) {
      // Nếu có lỗi từ Backend (ví dụ: Email đã đăng ký Local)
      setError(err.message || "Đăng nhập Google thất bại");
      setLoading(false);
    }
  };

  const handleGoogleError = () => {
    setError("Đăng nhập Google thất bại. Vui lòng thử lại.");
  };

  return (
    // Wrapper toàn trang
    <div className="auth-page-wrapper">
      {/* Card chính, 2 cột */}
      <Card className="shadow-lg auth-card-container">
        <Row className="g-0">
          {/* === CỘT BÊN TRÁI (Hình ảnh) === */}
          <Col md={5}>
            <Image src={authImage} className="auth-card-image" />
          </Col>

          {/* === CỘT BÊN PHẢI (Form) === */}
          <Col md={7}>
            <div className="auth-form-content">
              {/* Logo và tiêu đề */}
              <div className="text-center mb-4">
                <Image
                  src={authLogo}
                  alt="Blank Canvas Logo"
                  className="auth-logo"
                />
                <p className="text-muted mt-2">
                  Trải nghiệm mua hàng thật tốt với Blank Canvas.
                </p>
              </div>

              {/* Hiển thị lỗi chung (nếu có) */}
              {error && <Alert variant="danger">{error}</Alert>}

              {/* Hiển thị Spinner (nếu đang loading) */}
              {loading ? (
                <div className="text-center">
                  <Spinner animation="border" />
                  <p>Đang xử lý...</p>
                </div>
              ) : (
                <>
                  {/* Form Đăng nhập / Đăng ký */}
                  {isLoginView ? (
                    <>
                      <h3 className="text-center mb-3 fw-bold">Đăng Nhập</h3>
                      {/* LoginForm cần phải xử lý lỗi form riêng */}
                      <LoginForm />

                      {/* === LINK QUÊN MẬT KHẨU === */}
                      <div className="text-end mt-2">
                        <Button
                          as={Link}
                          to="/forgot-password"
                          variant="link"
                          size="sm"
                        >
                          Quên mật khẩu?
                        </Button>
                      </div>
                      {/* ================================== */}
                    </>
                  ) : (
                    <>
                      <h3 className="text-center mb-3 fw-bold">Đăng Ký</h3>
                      <RegisterForm onRegisterSuccess={() => setIsLoginView(true)} />
                    </>
                  )}

                  {/* 8. Link để chuyển đổi form */}
                  <div className="text-center mt-3">
                    {isLoginView ? (
                      <span className="auth-toggle-link">
                        Chưa có tài khoản?
                        <Button
                          variant="link"
                          size="sm"
                          onClick={() => setIsLoginView(false)}
                        >
                          Đăng Ký
                        </Button>
                      </span>
                    ) : (
                      <span className="auth-toggle-link">
                        Đã có tài khoản?
                        <Button
                          variant="link"
                          size="sm"
                          onClick={() => setIsLoginView(true)}
                        >
                          Đăng Nhập
                        </Button>
                      </span>
                    )}
                  </div>
                  {/* Vạch kẻ "Hoặc" */}
                  <Row className="my-3 align-items-center">
                    <Col>
                      <hr />
                    </Col>
                    <Col xs="auto" className="text-muted">
                      HOẶC
                    </Col>
                    <Col>
                      <hr />
                    </Col>
                  </Row>

                  {/* 5. NÚT GOOGLE LOGIN */}
                  <div className="d-flex justify-content-center">
                    <GoogleLogin
                      onSuccess={handleGoogleSuccess}
                      onError={handleGoogleError}
                      // [ĐÃ SỬA] Xóa thuộc tính useOneTap hoặc đặt nó thành false
                      // useOneTap // <-- XÓA DÒNG NÀY
                    />
                  </div>
                </>
              )}
            </div>
          </Col>
        </Row>
      </Card>
    </div>
  );
};

export default AuthPage;
