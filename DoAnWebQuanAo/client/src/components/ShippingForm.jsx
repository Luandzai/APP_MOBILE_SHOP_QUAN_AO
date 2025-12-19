// client/src/components/ShippingForm.jsx
import React from "react";
import { Card, Form, Row, Col } from "react-bootstrap";

const ShippingForm = ({
  shippingInfo,
  provinces,
  districts,
  wards,
  selectedProvinceId,
  selectedDistrictId,
  selectedWardCode,
  onInputChange,
  onProvinceChange,
  onDistrictChange,
  onWardChange,
  notes,
  onNotesChange,
}) => {
  return (
    <Card className="shadow-sm mb-3">
      <Card.Header as="h5">1. Thông tin giao hàng</Card.Header>
      <Card.Body>
        <Form>
          <Form.Group className="mb-3">
            <Form.Label>Họ và tên</Form.Label>
            <Form.Control
              type="text"
              name="TenNguoiNhan"
              value={shippingInfo.TenNguoiNhan}
              onChange={onInputChange}
            />
          </Form.Group>
          <Row>
            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  name="Email"
                  value={shippingInfo.Email}
                  onChange={onInputChange}
                />
              </Form.Group>
            </Col>
            <Col md={6}>
              <Form.Group className="mb-3">
                <Form.Label>Số điện thoại</Form.Label>
                <Form.Control
                  type="text"
                  name="DienThoaiNhan"
                  value={shippingInfo.DienThoaiNhan}
                  onChange={onInputChange}
                />
              </Form.Group>
            </Col>
          </Row>

          <Row>
            <Col md={4}>
              <Form.Group className="mb-3">
                <Form.Label>Tỉnh/Thành phố</Form.Label>
                <Form.Select
                  value={selectedProvinceId}
                  onChange={(e) => onProvinceChange(e.target.value)}
                >
                  <option value="">Chọn Tỉnh/Thành</option>
                  {provinces.map((p) => (
                    <option key={p.ProvinceID} value={p.ProvinceID}>
                      {p.ProvinceName}
                    </option>
                  ))}
                </Form.Select>
              </Form.Group>
            </Col>
            <Col md={4}>
              <Form.Group className="mb-3">
                <Form.Label>Quận/Huyện</Form.Label>
                <Form.Select
                  value={selectedDistrictId}
                  onChange={(e) => onDistrictChange(e.target.value)}
                  disabled={districts.length === 0}
                >
                  <option value="">Chọn Quận/Huyện</option>
                  {districts.map((d) => (
                    <option key={d.DistrictID} value={d.DistrictID}>
                      {d.DistrictName}
                    </option>
                  ))}
                </Form.Select>
              </Form.Group>
            </Col>
            <Col md={4}>
              <Form.Group className="mb-3">
                <Form.Label>Phường/Xã</Form.Label>
                <Form.Select
                  value={selectedWardCode}
                  onChange={onWardChange}
                  disabled={wards.length === 0}
                >
                  <option value="">Chọn Phường/Xã</option>
                  {wards.map((w) => (
                    <option key={w.WardCode} value={w.WardCode}>
                      {w.WardName}
                    </option>
                  ))}
                </Form.Select>
              </Form.Group>
            </Col>
          </Row>

          <Form.Group className="mb-3">
            <Form.Label>Số nhà, tên đường</Form.Label>
            <Form.Control
              type="text"
              name="SoNha"
              value={shippingInfo.SoNha}
              onChange={onInputChange}
              placeholder="Ví dụ: 123 Nguyễn Văn Cừ"
            />
          </Form.Group>

          <Form.Group className="mb-3">
            <Form.Label>Ghi chú</Form.Label>
            <Form.Control
              as="textarea"
              rows={2}
              value={notes}
              onChange={(e) => onNotesChange(e.target.value)}
            />
          </Form.Group>
        </Form>
      </Card.Body>
    </Card>
  );
};

export default ShippingForm;
