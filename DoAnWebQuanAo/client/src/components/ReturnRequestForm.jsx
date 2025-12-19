// client/src/components/ReturnRequestForm.jsx
import React from 'react';
import { Form, Button, Spinner, ListGroup, Image } from 'react-bootstrap';

const ReturnRequestForm = ({
    order,
    itemsToReturn,
    reason,
    onQuantityChange,
    onReasonChange,
    onSubmit,
    loading
}) => {
    return (
        <Form onSubmit={onSubmit}>
            <ListGroup variant="flush" className="mb-3">
                {order.items.map((item) => (
                    <ListGroup.Item key={item.PhienBanID} className="d-flex align-items-center">
                        <Image src={item.HinhAnh} style={{ width: "60px" }} className="me-3" rounded />
                        <div className="flex-grow-1">
                            <strong>{item.TenSanPham}</strong>
                            <div className="text-muted small">{item.ThuocTinh}</div>
                        </div>
                        <Form.Control
                            type="number"
                            style={{ width: "80px" }}
                            min={0}
                            max={item.SoLuong}
                            value={itemsToReturn[item.PhienBanID] || 0}
                            onChange={(e) => onQuantityChange(item.PhienBanID, item.SoLuong, e.target.value)}
                        />
                        <span className="ms-2">/ {item.SoLuong}</span>
                    </ListGroup.Item>
                ))}
            </ListGroup>

            <Form.Group className="mb-3">
                <Form.Label className="fw-bold">Lý do đổi/trả:</Form.Label>
                <Form.Control
                    as="textarea"
                    rows={3}
                    value={reason}
                    onChange={(e) => onReasonChange(e.target.value)}
                    required
                    placeholder="Ví dụ: Sản phẩm bị lỗi, sai kích thước..."
                />
            </Form.Group>

            <Button type="submit" variant="primary" disabled={loading}>
                {loading ? <><Spinner as="span" size="sm" animation="border" /> Đang gửi...</> : "Gửi Yêu Cầu"}
            </Button>
        </Form>
    );
};

export default ReturnRequestForm;
