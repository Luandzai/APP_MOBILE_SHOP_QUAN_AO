// client/src/components/ProfileUpdate.jsx (ĐÃ SỬA LỖI STALE STATE & CASING)

import React, { useState, useEffect, useContext } from "react";
import { Form, Button, Alert, Row, Col } from "react-bootstrap";
import AuthContext from "../context/AuthContext";

const ProfileUpdate = () => {
  const { api, user, updateUserInContext } = useContext(AuthContext);

  // 1. SỬA LỖI TÊN BIẾN:
  // Đọc 'user.hoTen' (viết thường) từ Context
  // Nhưng lưu vào state 'HoTen' (viết hoa) để gửi cho API
  const [formData, setFormData] = useState({
    HoTen: user?.hoTen || "",
    DienThoai: user?.dienThoai || "",
    NgaySinh: user?.ngaySinh
      ? new Date(user.ngaySinh).toISOString().split("T")[0]
      : "",
    GioiTinh: user?.gioiTinh || "",
  });

  const [message, setMessage] = useState({ type: "", text: "" });
  const [loading, setLoading] = useState(false);

  // 2. THÊM useEffect ĐỂ SỬA LỖI "STALE STATE":
  // useEffect này sẽ "theo dõi" [user].
  // Khi 'user' thay đổi (do đăng nhập/đăng xuất), nó sẽ chạy lại
  // và cập nhật 'formData' với thông tin mới.
  useEffect(() => {
    setFormData({
      HoTen: user?.hoTen || "",
      DienThoai: user?.dienThoai || "",
      NgaySinh: user?.ngaySinh
        ? new Date(user.ngaySinh).toISOString().split("T")[0]
        : "",
      GioiTinh: user?.gioiTinh || "",
    });
  }, [user]); // <-- Chìa khóa là ở đây

  const { HoTen, DienThoai, NgaySinh, GioiTinh } = formData;

  const onChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage({ type: "", text: "" });

    try {
      await api.put("/user/profile", formData);

      // 3. Cập nhật lại Context (Giữ nguyên)
      updateUserInContext(formData);

      setLoading(false);
      setMessage({ type: "success", text: "Cập nhật thông tin thành công!" });
    } catch (err) {
      setLoading(false);
      setMessage({
        type: "danger",
        text: err.response?.data?.message || "Cập nhật thất bại.",
      });
    }
  };

  return (
    <>
      <h3 className="mb-4">Cập nhật tài khoản</h3>
      {message.text && <Alert variant={message.type}>{message.text}</Alert>}

      <Form onSubmit={onSubmit}>
        <Row>
          <Col md={6}>
            <Form.Group className="mb-3">
              <Form.Label>Họ Tên</Form.Label>
              <Form.Control
                type="text"
                name="HoTen"
                value={HoTen}
                onChange={onChange}
              />
            </Form.Group>
          </Col>
          <Col md={6}>
            <Form.Group className="mb-3">
              <Form.Label>Email</Form.Label>
              <Form.Control
                type="email"
                value={user?.email || ""} // 4. SỬA LỖI TÊN BIẾN
                readOnly
                disabled
              />
            </Form.Group>
          </Col>
        </Row>

        <Row>
          <Col md={6}>
            <Form.Group className="mb-3">
              <Form.Label>Số điện thoại</Form.Label>
              <Form.Control
                type="text"
                name="DienThoai"
                value={DienThoai}
                onChange={onChange}
              />
            </Form.Group>
          </Col>
          <Col md={6}>
            <Form.Group className="mb-3">
              <Form.Label>Ngày sinh</Form.Label>
              <Form.Control
                type="date"
                name="NgaySinh"
                value={NgaySinh}
                onChange={onChange}
              />
            </Form.Group>
          </Col>
        </Row>

        <Form.Group className="mb-3">
          <Form.Label>Giới tính</Form.Label>
          <Form.Select name="GioiTinh" value={GioiTinh} onChange={onChange}>
            <option value="">Chọn...</option>
            <option value="Nam">Nam</option>
            <option value="Nu">Nữ</option>
            <option value="Khac">Khác</option>
          </Form.Select>
        </Form.Group>

        <Button type="submit" variant="primary" disabled={loading}>
          {loading ? "Đang cập nhật..." : "Cập nhật"}
        </Button>
      </Form>
    </>
  );
};

export default ProfileUpdate;
