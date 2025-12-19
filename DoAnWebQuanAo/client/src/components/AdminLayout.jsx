// client/src/components/AdminLayout.jsx (ĐÃ THÊM THEME TOGGLE)

import React, { useContext } from "react";
import { Container, Row, Col, Nav, Dropdown } from "react-bootstrap";
import { Link, NavLink } from "react-router-dom";
import {
  Speedometer,
  BoxSeam,
  List,
  People,
  ArrowReturnLeft,
  Gift,
  StarFill,
  PersonCircle,
} from "react-bootstrap-icons";
import AuthContext from "../context/AuthContext";
// 1. Import ThemeToggle
import ThemeToggle from "./ThemeToggle";

const AdminLayout = ({ children }) => {
  const { user, logout } = useContext(AuthContext);

  return (
    // Thêm class 'bg-body-tertiary' để màu nền tự động đổi theo theme
    <Container
      fluid
      className="p-0 admin-container bg-body-tertiary"
      style={{ height: "100vh", overflow: "hidden" }}
    >
      <Row className="g-0 h-100">
        {/* Sidebar Admin - Fixed position */}
        <Col
          md={3}
          lg={2}
          className="bg-body border-end shadow-sm d-flex flex-column"
          style={{ height: "100vh", position: "sticky", top: 0, overflowY: "auto" }}
        >
          <div className="p-3">
            <h4 className="mb-4 fw-bold text-primary px-2">Admin Panel</h4>
            <Nav className="flex-column">
              <Nav.Link
                as={NavLink}
                to="/admin/dashboard"
                className="mb-2 nav-link-admin"
              >
                <Speedometer className="me-2" /> Dashboard
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/products"
                className="mb-2 nav-link-admin"
              >
                <BoxSeam className="me-2" /> Sản phẩm
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/categories"
                className="mb-2 nav-link-admin"
              >
                <List className="me-2" /> Danh mục & Thuộc tính
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/orders"
                className="mb-2 nav-link-admin"
              >
                <BoxSeam className="me-2" /> Đơn hàng
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/users"
                className="mb-2 nav-link-admin"
              >
                <People className="me-2" /> Người dùng
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/returns"
                className="mb-2 nav-link-admin"
              >
                <ArrowReturnLeft className="me-2" /> Yêu cầu đổi trả
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/vouchers"
                className="mb-2 nav-link-admin"
              >
                <Gift className="me-2" /> Mã khuyến mãi
              </Nav.Link>
              <Nav.Link
                as={NavLink}
                to="/admin/reviews"
                className="mb-2 nav-link-admin"
              >
                <StarFill className="me-2" /> Đánh giá
              </Nav.Link>
            </Nav>
          </div>
        </Col>

        {/* Nội dung Admin - Scrollable */}
        <Col md={9} lg={10} className="d-flex flex-column" style={{ height: "100vh", overflow: "hidden" }}>
          {/* Top Bar - Fixed */}
          <div className="bg-body border-bottom shadow-sm p-3 d-flex justify-content-end align-items-center gap-3 flex-shrink-0">
            {/* 2. Nút Theme Toggle */}
            <ThemeToggle />

            <Dropdown align="end">
              <Dropdown.Toggle
                variant="link"
                id="dropdown-admin-user"
                className="text-decoration-none text-body border-0 bg-transparent d-flex align-items-center gap-2"
              >
                <PersonCircle size={24} />
                <span className="fw-bold">
                  Xin chào, {user?.hoTen || "Quản Trị Viên"}
                </span>
              </Dropdown.Toggle>

              <Dropdown.Menu>
                <Dropdown.Item onClick={logout} className="text-danger">
                  Đăng xuất
                </Dropdown.Item>
              </Dropdown.Menu>
            </Dropdown>
          </div>

          {/* Content Area - Scrollable */}
          <div className="px-4 pb-5 flex-grow-1" style={{ overflowY: "auto" }}>
            {children}
          </div>
        </Col>
      </Row>
    </Container>
  );
};

export default AdminLayout;
