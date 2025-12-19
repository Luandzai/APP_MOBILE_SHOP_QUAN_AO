// client/src/components/OrderDetailModal.jsx
import React, { useState, useEffect, useContext } from "react";
// SỬA LỖI: Thêm 'Table' vào dòng import này
import {
  Modal,
  Spinner,
  Alert,
  Tabs,
  Tab,
  Row,
  Col,
  Card,
  ListGroup,
  Image,
  Badge,
  Table,
} from "react-bootstrap";
import { toast } from "react-toastify";
import AuthContext from "../context/AuthContext";

const STATUS_OPTIONS = {
  CHUA_THANH_TOAN: { name: "Chưa thanh toán", color: "secondary" },
  DANG_XU_LY: { name: "Đang xử lý", color: "info" },
  DANG_GIAO: { name: "Đang giao hàng", color: "warning" },
  DA_GIAO: { name: "Đã hoàn thành", color: "success" },
  DA_HUY: { name: "Đã hủy", color: "danger" },
  DOI_TRA: { name: "Đổi/Trả hàng", color: "dark" },
};

const OrderDetailModal = ({ show, onHide, orderId }) => {
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    const fetchOrderDetail = async () => {
      if (!orderId) return;

      setLoading(true);
      setError(null);
      setOrder(null);

      try {
        const { data } = await api.get(`/admin/orders/${orderId}`);
        setOrder(data.data);
      } catch (err) {
        const errMsg =
          err.response?.data?.message || "Không thể tải chi tiết đơn hàng.";
        setError(errMsg);
        toast.error(errMsg);
      } finally {
        setLoading(false);
      }
    };

    if (show) {
      fetchOrderDetail();
    }
  }, [show, orderId, api]);

  const formatCurrency = (amount) =>
    new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount || 0);
  const formatDate = (dateString) =>
    new Date(dateString).toLocaleString("vi-VN");

  return (
    <Modal show={show} onHide={onHide} size="lg" scrollable centered>
      <Modal.Header closeButton>
        <Modal.Title>Chi tiết đơn hàng #{orderId}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading && (
          <div className="text-center py-5">
            <Spinner animation="border" /> Đang tải...
          </div>
        )}
        {error && <Alert variant="danger">{error}</Alert>}
        {order && (
          <Tabs
            defaultActiveKey="details"
            id="order-detail-tabs"
            className="mb-3"
          >
            <Tab eventKey="details" title="Chi tiết Đơn hàng">
              <Row>
                <Col md={6} className="mb-4">
                  <Card className="h-100">
                    <Card.Header className="bg-light">
                      <h6 className="mb-0">Thông tin khách hàng & Địa chỉ</h6>
                    </Card.Header>
                    <Card.Body>
                      <p>
                        <strong>Khách hàng:</strong> {order.TenKhachHang} (
                        {order.EmailKhachHang})
                      </p>
                      <p>
                        <strong>Người nhận:</strong> {order.TenNguoiNhan}
                      </p>
                      <p>
                        <strong>Địa chỉ:</strong> {order.DiaChiChiTiet}
                      </p>
                      <p>
                        <strong>Ghi chú:</strong> {order.GhiChu || "Không có"}
                      </p>
                    </Card.Body>
                  </Card>
                </Col>
                <Col md={6} className="mb-4">
                  <Card className="h-100">
                    <Card.Header className="bg-light">
                      <h6 className="mb-0">Tổng kết & Thanh toán</h6>
                    </Card.Header>
                    <Card.Body>
                      <p>
                        <strong>PT Vận chuyển:</strong> {order.TenPhuongThuc}
                      </p>
                      <p>
                        <strong>Voucher:</strong>{" "}
                        {order.TenKhuyenMai || "Không sử dụng"}
                      </p>
                      <p>
                        <strong>Phí VC:</strong>{" "}
                        {formatCurrency(order.PhiVanChuyen)}
                      </p>
                      <p>
                        <strong>Tổng tiền hàng:</strong>{" "}
                        {formatCurrency(order.TongTienHang)}
                      </p>
                    </Card.Body>
                    <Card.Footer className="text-end">
                      <h5>
                        Tổng thanh toán:{" "}
                        <strong className="text-danger">
                          {formatCurrency(order.TongThanhToan)}
                        </strong>
                      </h5>
                    </Card.Footer>
                  </Card>
                </Col>
              </Row>
              <Card>
                <Card.Header className="bg-light">
                  <h6 className="mb-0">Danh sách Sản phẩm</h6>
                </Card.Header>
                <Card.Body className="p-0">
                  <ListGroup variant="flush">
                    {order.items?.map((item) => (
                      <ListGroup.Item
                        key={item.PhienBanID}
                        className="d-flex align-items-center"
                      >
                        <Col xs={2} md={1}>
                          <Image
                            src={item.HinhAnh}
                            alt={item.TenSanPham}
                            fluid
                            rounded
                          />
                        </Col>
                        <Col>
                          <h6 className="mb-1">{item.TenSanPham}</h6>
                          <p className="mb-0 small text-muted">
                            {item.ThuocTinh}
                          </p>
                        </Col>
                        <Col xs="auto" className="text-end">
                          <p className="mb-0">
                            {item.SoLuong} x {formatCurrency(item.GiaLucMua)}
                          </p>
                          <strong className="text-danger">
                            = {formatCurrency(item.SoLuong * item.GiaLucMua)}
                          </strong>
                        </Col>
                      </ListGroup.Item>
                    ))}
                  </ListGroup>
                </Card.Body>
              </Card>
            </Tab>
            <Tab
              eventKey="history"
              title={`Lịch sử (${order.history?.length || 0})`}
            >
              <Table striped bordered size="sm" className="mt-3">
                <thead>
                  <tr>
                    <th>Thời gian</th>
                    <th>Trạng thái Cũ</th>
                    <th>Trạng thái Mới</th>
                    <th>Ghi chú</th>
                  </tr>
                </thead>
                <tbody>
                  {order.history?.length > 0 ? (
                    order.history.map((h) => (
                      <tr key={h.LichSuID}>
                        <td>{formatDate(h.ThoiGian)}</td>
                        <td>
                          <Badge
                            bg={
                              STATUS_OPTIONS[h.TrangThaiCu]?.color ||
                              "secondary"
                            }
                          >
                            {h.TrangThaiCu}
                          </Badge>
                        </td>
                        <td>
                          <Badge
                            bg={
                              STATUS_OPTIONS[h.TrangThaiMoi]?.color ||
                              "secondary"
                            }
                          >
                            {h.TrangThaiMoi}
                          </Badge>
                        </td>
                        <td>{h.GhiChu}</td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan="4" className="text-center">
                        Chưa có lịch sử trạng thái.
                      </td>
                    </tr>
                  )}
                </tbody>
              </Table>
            </Tab>
          </Tabs>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default OrderDetailModal;
