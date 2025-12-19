// client/src/components/Footer.jsx

import React from "react";
import {
  Container,
  Row,
  Col,
  Nav,
  Form, // Thêm Form
  InputGroup, // Thêm InputGroup
  FormControl, // Thêm FormControl
  Button, // Thêm Button
} from "react-bootstrap";
import { Link } from "react-router-dom";
import { GeoAlt, Telephone, Facebook, Envelope } from "react-bootstrap-icons"; // Import các icon
// 1. Import file CSS tùy chỉnh
import "./Footer.css";

const Footer = () => {
  return (
    // 'mt-auto' tự động đẩy footer xuống dưới nếu trang ngắn
    // Đổi màu nền (bg-dark) để phù hợp với màu nền của ảnh mẫu (màu xám đậm hơn)
    <footer className="footer-container text-light mt-auto py-5">
      <Container fluid>
        <Row>
          {/* CỘT 1: VỀ CHÚNG TÔI - Chiếm 5/12 cột (theo tỉ lệ ảnh) */}
          <Col md={8} className="mb-4">
            <h3 className="fw-bold mb-3">VỀ CHÚNG TÔI</h3>
            <p className="footer-text large-text">
              <strong>Blank Canvas</strong> được hình thành từ niềm tin rằng mỗi ngày mới đều là một
              "tấm toan trắng", và thời trang chính là ngôn ngữ để bạn vẽ nên màu sắc cá tính của riêng mình.
              Không chỉ dừng lại ở việc cung cấp các sản phẩm may mặc bắt kịp xu hướng, chúng tôi khao khát
              mang đến một phong cách sống hiện đại, nơi sự tối giản giao thoa cùng chất lượng đỉnh cao.
            </p>
            <p className="footer-text large-text">
              Tại Blank Canvas, trải nghiệm của khách hàng là kim chỉ nam cho mọi hoạt động.
              Chúng tôi cam kết tỉ mỉ từ khâu chọn lựa chất liệu đến dịch vụ chăm sóc khách hàng,
              giúp bạn tự tin khẳng định bản sắc riêng trên mọi hành trình.
            </p>
          </Col>

          {/* CỘT 2: ĐƯỜNG DẪN - Giữ nguyên cấu trúc link, thay đổi tiêu đề */}
          <Col md={2} className="mb-4">
            <h5 className="fw-bold mb-3">ĐƯỜNG DẪN</h5>
            <Nav className="flex-column footer-links">
              <Nav.Link as={Link} to="/">
                Trang chủ
              </Nav.Link>
              <Nav.Link as={Link} to="/news">
                Về chúng tôi
              </Nav.Link>
              <Nav.Link as={Link} to="/contact">
                Thông tin liên hệ
              </Nav.Link>
            </Nav>
          </Col>

          {/* CỘT 3: THÔNG TIN LIÊN HỆ - Chiếm 4/12 cột */}
          <Col md={2} className="mb-4">
            <h5 className="fw-bold mb-3">THÔNG TIN LIÊN HỆ</h5>
            <ul className="list-unstyled contact-list">
              <li>
                <GeoAlt size={16} className="me-2" />
                <span>Địa chỉ: 38 Linh Dông TP.HCM</span>
              </li>
              <li>
                <Telephone size={16} className="me-2" />
                <span>+84 812422901</span>
              </li>
              {/* CẬP NHẬT LINK FACEBOOK */}
              <li>
                <a
                  href="https://www.facebook.com/profile.php?id=61583922954340"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-light-subtle d-flex align-items-start text-decoration-none"
                >
                  <Facebook size={16} className="me-2" />
                  <span>Facebook</span>
                </a>
              </li>
              <li>
                <Envelope size={16} className="me-2" />
                <span>blankcanvas.hotro@gmail.com</span>
              </li>
            </ul>
          </Col>
        </Row>
      </Container>
    </footer>
  );
};

export default Footer;
