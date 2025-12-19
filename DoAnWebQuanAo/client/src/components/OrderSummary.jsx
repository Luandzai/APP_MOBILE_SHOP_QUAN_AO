// client/src/components/OrderSummary.jsx
import React from "react";
import { Card, ListGroup, Image, Row, Col, Form } from "react-bootstrap";

const OrderSummary = ({
  items,
  subtotal,
  shippingFee,
  discountAmount,
  total,
  vouchers,
  vouchersLoading,
  selectedVoucherCode,
  onVoucherChange,
  voucherError,
}) => {
  return (
    <>
      <Card className="shadow-sm mb-3">
        <Card.Header as="h5">Tóm tắt đơn hàng</Card.Header>
        <ListGroup variant="flush" style={{ maxHeight: "400px", overflowY: "auto" }}>
          {items.map((item) => (
            <ListGroup.Item key={item.PhienBanID}>
              <Row className="align-items-center">
                <Col xs={3}>
                  <Image src={item.HinhAnh} fluid thumbnail />
                </Col>
                <Col xs={9}>
                  <p className="mb-0 fw-bold">{item.TenSanPham}</p>
                  <small className="text-muted">{item.ThuocTinh}</small>
                  <p className="mb-0">
                    {item.SoLuong} x {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
                  </p>
                </Col>
              </Row>
            </ListGroup.Item>
          ))}
        </ListGroup>
      </Card>
      <Card className="shadow-sm">
        <Card.Body>
          <Form.Group className="mb-3">
            <Form.Label className="fw-bold">Mã giảm giá</Form.Label>
            <Form.Select
              value={selectedVoucherCode}
              onChange={(e) => onVoucherChange(e.target.value)}
              disabled={vouchersLoading || vouchers.length === 0}
            >
              <option value="">
                {vouchersLoading
                  ? "Đang tải voucher..."
                  : vouchers.length === 0
                  ? "Bạn không có voucher nào"
                  : "-- Chọn mã khuyến mãi --"}
              </option>
              {vouchers.map((v) => (
                <option key={v.MaKhuyenMai} value={v.MaKhuyenMai}>
                  {v.TenKhuyenMai} (Mã: {v.MaKhuyenMai})
                </option>
              ))}
            </Form.Select>
            {voucherError && <small className="text-danger">{voucherError}</small>}
          </Form.Group>

          <ListGroup variant="flush">
            <ListGroup.Item className="d-flex justify-content-between">
              <span>Tạm tính:</span>
              <strong>{subtotal.toLocaleString("vi-VN")} ₫</strong>
            </ListGroup.Item>
            <ListGroup.Item className="d-flex justify-content-between">
              <span>Phí vận chuyển:</span>
              <strong>{shippingFee.toLocaleString("vi-VN")} ₫</strong>
            </ListGroup.Item>
            {discountAmount > 0 && (
              <ListGroup.Item className="d-flex justify-content-between text-success">
                <span>Tiền khuyến mãi:</span>
                <strong>- {discountAmount.toLocaleString("vi-VN")} ₫</strong>
              </ListGroup.Item>
            )}
            <ListGroup.Item className="fs-5">
              <div className="text-end mb-2">
                <span className="text-muted fst-italic small">Hóa đơn này đã bao gồm thuế theo luật hiện hành</span>
              </div>
            </ListGroup.Item>
            <ListGroup.Item className="fs-5">
              <div className="d-flex justify-content-between align-items-center">
                <strong>Tổng cộng:</strong>
                <strong className="text-danger">{total.toLocaleString("vi-VN")} ₫</strong>
              </div>
            </ListGroup.Item>
          </ListGroup>
        </Card.Body>
      </Card>
    </>
  );
};

export default OrderSummary;
