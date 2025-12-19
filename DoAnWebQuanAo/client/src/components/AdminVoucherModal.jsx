// client/src/components/AdminVoucherModal.jsx (HOÀN CHỈNH CRUD)

import React, { useState, useEffect, useContext } from "react";
import {
  Modal,
  Button,
  Form,
  Spinner,
  Alert,
  Row,
  Col,
  InputGroup,
} from "react-bootstrap";
import { toast } from "react-toastify";
import AuthContext from "../context/AuthContext"; // Import Context

const AdminVoucherModal = ({
  show,
  onHide,
  onVoucherUpdated,
  isEdit,
  voucherToEdit,
}) => {
  // Sử dụng AuthContext để truy cập API
  const { api } = useContext(AuthContext);

  const [formData, setFormData] = useState({
    MaKhuyenMai: "",
    TenKhuyenMai: "",
    LoaiGiamGia: "PHANTRAM", // Mặc định
    GiaTriGiam: 0,
    ApDungToiThieu: 0,
    DanhMucID: "",
    SanPhamID: "",
    NgayBatDau: "",
    NgayKetThuc: "",
    SoLuongToiDa: 0,
  });
  const [processing, setProcessing] = useState(false);
  const [localError, setLocalError] = useState(null);

  // Hàm chuyển đổi Date object hoặc string sang định dạng input type="date" (YYYY-MM-DD)
  const formatDateForInput = (date) => {
    if (!date) return "";
    const d = new Date(date);
    // Lấy ngày tháng năm theo UTC để tránh sai lệch múi giờ
    return d.toISOString().substring(0, 10);
  };

  // Xử lý khi modal mở (Làm đầy form khi sửa)
  useEffect(() => {
    if (show) {
      setLocalError(null);
      if (isEdit && voucherToEdit) {
        // Đổ dữ liệu từ voucherToEdit vào formData
        setFormData({
          ...voucherToEdit,
          // Đảm bảo dữ liệu số là số và chuyển date sang định dạng YYYY-MM-DD
          GiaTriGiam: parseFloat(voucherToEdit.GiaTriGiam || 0),
          ApDungToiThieu: parseFloat(voucherToEdit.ApDungToiThieu || 0),
          SoLuongToiDa: parseInt(voucherToEdit.SoLuongToiDa || 0),
          NgayBatDau: formatDateForInput(voucherToEdit.NgayBatDau),
          NgayKetThuc: formatDateForInput(voucherToEdit.NgayKetThuc),
          // Xử lý giá trị null/undefined cho ID thành chuỗi rỗng
          DanhMucID: voucherToEdit.DanhMucID || "",
          SanPhamID: voucherToEdit.SanPhamID || "",
        });
      } else if (!isEdit) {
        // Reset form khi thêm mới
        setFormData({
          MaKhuyenMai: "",
          TenKhuyenMai: "",
          LoaiGiamGia: "PHANTRAM",
          GiaTriGiam: 0,
          ApDungToiThieu: 0,
          DanhMucID: "",
          SanPhamID: "",
          NgayBatDau: formatDateForInput(new Date()), // Mặc định ngày hôm nay
          NgayKetThuc: "",
          SoLuongToiDa: 0,
        });
      }
    }
  }, [show, isEdit, voucherToEdit]);

  const handleChange = (e) => {
    const { name, value, type } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]:
        type === "number" || name.endsWith("ID")
          ? value
            ? Number(value)
            : ""
          : value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setProcessing(true);
    setLocalError(null);

    const finalData = {
      ...formData,
      // Chuyển đổi ID rỗng thành null cho Backend SQL
      DanhMucID: formData.DanhMucID === "" ? null : formData.DanhMucID,
      SanPhamID: formData.SanPhamID === "" ? null : formData.SanPhamID,
    };

    const url = isEdit
      ? `/vouchers/admin/${formData.MaKhuyenMai}`
      : "/vouchers/admin";

    try {
      const method = isEdit ? "put" : "post";
      await api({
        method: method,
        url: url,
        data: finalData,
      });

      toast.success(
        `Voucher đã được ${isEdit ? "cập nhật" : "tạo mới"} thành công!`
      );
      onVoucherUpdated(); // Tải lại danh sách trên trang List
      onHide();
    } catch (error) {
      console.error("Lỗi CRUD Voucher:", error);
      setLocalError(
        error.response?.data?.message ||
          `Thao tác ${isEdit ? "sửa" : "thêm"} thất bại.`
      );
      toast.error(`Thao tác ${isEdit ? "sửa" : "thêm"} thất bại.`);
    } finally {
      setProcessing(false);
    }
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>{isEdit ? "Sửa Voucher" : "Thêm Voucher Mới"}</Modal.Title>
      </Modal.Header>
      <Form onSubmit={handleSubmit}>
        <Modal.Body>
          {localError && <Alert variant="danger">{localError}</Alert>}

          {/* Mã Khuyến mãi */}
          <Form.Group controlId="MaKhuyenMai" className="mb-3">
            <Form.Label>Mã Khuyến mãi</Form.Label>
            <Form.Control
              name="MaKhuyenMai"
              value={formData.MaKhuyenMai}
              onChange={handleChange}
              required
              disabled={isEdit} // Không cho sửa mã khi edit
              placeholder="Ví dụ: SALE20K"
            />
          </Form.Group>

          {/* Tên Chương trình */}
          <Form.Group controlId="TenKhuyenMai" className="mb-3">
            <Form.Label>Tên Chương trình</Form.Label>
            <Form.Control
              name="TenKhuyenMai"
              value={formData.TenKhuyenMai}
              onChange={handleChange}
              required
            />
          </Form.Group>

          {/* Loại giảm giá và Giá trị */}
          <Row>
            <Col>
              <Form.Group controlId="LoaiGiamGia" className="mb-3">
                <Form.Label>Loại giảm giá</Form.Label>
                <Form.Select
                  name="LoaiGiamGia"
                  value={formData.LoaiGiamGia}
                  onChange={handleChange}
                  required
                >
                  <option value="PHANTRAM">Phần trăm (%)</option>
                  <option value="SOTIEN">Số tiền (₫)</option>
                </Form.Select>
              </Form.Group>
            </Col>
            <Col>
              <Form.Group controlId="GiaTriGiam" className="mb-3">
                <Form.Label>Giá trị giảm</Form.Label>
                <Form.Control
                  name="GiaTriGiam"
                  type="number"
                  value={formData.GiaTriGiam}
                  onChange={handleChange}
                  required
                  min={0}
                  step={formData.LoaiGiamGia === "PHANTRAM" ? 1 : 1000}
                />
              </Form.Group>
            </Col>
          </Row>

          {/* Ngày bắt đầu và Ngày kết thúc */}
          <Row>
            <Col>
              <Form.Group controlId="NgayBatDau" className="mb-3">
                <Form.Label>Ngày bắt đầu</Form.Label>
                <Form.Control
                  name="NgayBatDau"
                  type="date"
                  value={formData.NgayBatDau}
                  onChange={handleChange}
                  required
                />
              </Form.Group>
            </Col>
            <Col>
              <Form.Group controlId="NgayKetThuc" className="mb-3">
                <Form.Label>Ngày kết thúc</Form.Label>
                <Form.Control
                  name="NgayKetThuc"
                  type="date"
                  value={formData.NgayKetThuc}
                  onChange={handleChange}
                  required
                />
              </Form.Group>
            </Col>
          </Row>

          {/* Số lượng Tối đa và Điều kiện Tối thiểu */}
          <Row>
            <Col>
              <Form.Group controlId="SoLuongToiDa" className="mb-3">
                <Form.Label>Số lượng tối đa</Form.Label>
                <Form.Control
                  name="SoLuongToiDa"
                  type="number"
                  value={formData.SoLuongToiDa}
                  onChange={handleChange}
                  required
                  min={0}
                />
              </Form.Group>
            </Col>
            <Col>
              <Form.Group controlId="ApDungToiThieu" className="mb-3">
                <Form.Label>Áp dụng tối thiểu (VND)</Form.Label>
                <Form.Control
                  name="ApDungToiThieu"
                  type="number"
                  value={formData.ApDungToiThieu}
                  onChange={handleChange}
                  required
                  min={0}
                />
              </Form.Group>
            </Col>
          </Row>

          {/* Phạm vi áp dụng Voucher */}
          <Form.Group controlId="DanhMucID" className="mb-3">
            <Form.Label>Danh mục ID</Form.Label>
            <Form.Control
              name="DanhMucID"
              type="number"
              value={formData.DanhMucID || ""}
              onChange={handleChange}
              placeholder="Ví dụ: 401"
              min={1}
            />
            <Form.Text className="text-muted">
              Bỏ trống nếu voucher chỉ áp dụng cho một sản phẩm cụ thể
            </Form.Text>
          </Form.Group>
          <Form.Group controlId="SanPhamID" className="mb-3">
            <Form.Label>Sản phẩm ID</Form.Label>
            <Form.Control
              name="SanPhamID"
              type="number"
              value={formData.SanPhamID || ""}
              onChange={handleChange}
              placeholder="Ví dụ: 201"
              min={1}
            />
            <Form.Text className="text-muted">
              Bỏ trống nếu voucher áp dụng cho tất cả sản phẩm trong danh mục
            </Form.Text>
          </Form.Group>
          <Alert variant="info" className="mb-0">
            <strong>💡 Lưu ý:</strong> Bỏ trống cả Danh mục ID và Sản phẩm ID để voucher áp dụng cho <strong>tất cả sản phẩm</strong>.
          </Alert>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={onHide} disabled={processing}>
            Hủy
          </Button>
          <Button variant="primary" type="submit" disabled={processing}>
            {processing ? (
              <Spinner as="span" animation="border" size="sm" />
            ) : isEdit ? (
              "Lưu Thay Đổi"
            ) : (
              "Tạo Voucher"
            )}
          </Button>
        </Modal.Footer>
      </Form>
    </Modal>
  );
};

export default AdminVoucherModal;
