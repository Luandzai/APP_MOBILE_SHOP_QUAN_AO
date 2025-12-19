// client/src/components/UserOrders.jsx
import React, { useState, useEffect, useContext, useCallback } from "react";
import {
  Card,
  Spinner,
  Alert,
  ListGroup,
  Image,
  Button,
  Modal,
  Row,
  Col,
  Badge,
} from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Link } from "react-router-dom";
import ProductReviewModal from "./ProductReviewModal";
import "./UserOrders.css";

// Hằng số timeout thanh toán (phút) - phải khớp với backend
const PAYMENT_TIMEOUT_MINUTES = 15;

const UserOrders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api, user } = useContext(AuthContext);

  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [orderToCancel, setOrderToCancel] = useState(null);
  const [cancellingOrder, setCancellingOrder] = useState(null);

  const [showReviewModal, setShowReviewModal] = useState(false);
  const [productToReview, setProductToReview] = useState(null);

  // State cho retry payment
  const [retryingOrder, setRetryingOrder] = useState(null);
  // State trigger re-render cho đếm ngược
  const [, setTick] = useState(0);

  // Hàm tải dữ liệu
  const fetchOrders = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const { data } = await api.get("/orders");
      setOrders(data);
    } catch (err) {
      setError("Không thể tải danh sách đơn hàng.");
    } finally {
      setLoading(false);
    }
  }, [api]);

  useEffect(() => {
    fetchOrders();
  }, [fetchOrders]);

  // Effect để refresh đếm ngược mỗi giây
  useEffect(() => {
    const hasUnpaidOrders = orders.some(
      (o) => o.TrangThai === "CHUA_THANH_TOAN"
    );
    if (!hasUnpaidOrders) return;

    const interval = setInterval(() => {
      setTick((prev) => prev + 1);
    }, 1000);

    return () => clearInterval(interval);
  }, [orders]);

  // Tính thời gian còn lại để thanh toán (15 phút)
  const getTimeRemaining = (ngayDatHang) => {
    const orderDate = new Date(ngayDatHang);
    const deadline = new Date(
      orderDate.getTime() + PAYMENT_TIMEOUT_MINUTES * 60 * 1000
    );
    const now = new Date();
    const diff = deadline - now;

    if (diff <= 0) return null;

    const minutes = Math.floor(diff / 60000);
    const seconds = Math.floor((diff % 60000) / 1000);
    return { minutes, seconds, total: diff };
  };

  // Hàm thanh toán lại
  const handleRetryPayment = async (orderId) => {
    setRetryingOrder(orderId);
    try {
      const { data } = await api.post(`/orders/${orderId}/retry-payment`);
      if (data.paymentUrl) {
        window.location.href = data.paymentUrl;
      }
    } catch (err) {
      toast.error(
        err.response?.data?.message || "Không thể tạo link thanh toán."
      );
      setRetryingOrder(null);
    }
  };

  const handleShowDetails = async (orderId) => {
    setShowDetailModal(true);
    setDetailLoading(true);
    try {
      const { data } = await api.get(`/orders/${orderId}`);
      setSelectedOrder(data);
    } catch (err) {
      console.error(err);
      toast.error("Không thể tải chi tiết đơn hàng");
    } finally {
      setDetailLoading(false);
    }
  };
  const handleCloseDetailModal = () => setShowDetailModal(false);

  const handleCancelOrder = (orderId) => {
    setOrderToCancel(orderId);
    setShowConfirmModal(true);
  };
  const handleCloseConfirmModal = () => {
    setShowConfirmModal(false);
    setOrderToCancel(null);
  };

  const confirmCancel = async () => {
    if (!orderToCancel) return;
    setCancellingOrder(orderToCancel);
    handleCloseConfirmModal();
    try {
      await api.put(`/orders/${orderToCancel}/cancel`);
      fetchOrders();
      toast.success("Đã hủy đơn hàng thành công!");
    } catch (err) {
      toast.error(err.response?.data?.message || "Hủy đơn thất bại.");
      setCancellingOrder(null);
    }
  };

  const handleShowReviewModal = (product) => {
    setProductToReview(product);
    setShowReviewModal(true);
  };

  const handleCloseReviewModal = () => {
    setShowReviewModal(false);
    setProductToReview(null);
  };

  const handleReviewSubmitted = () => {
    fetchOrders();
  };

  // Kiểm tra xem đơn hàng có thể hủy không
  const canCancelOrder = (order) => {
    if (order.TrangThai === "CHUA_THANH_TOAN") {
      return true; // Luôn cho phép hủy đơn chưa thanh toán
    }
    if (order.TrangThai === "DANG_XU_LY") {
      // Chỉ cho phép hủy COD (MethodID = 701)
      return order.MethodID == 701;
    }
    return false;
  };

  // Lấy tooltip cho nút hủy
  const getCancelButtonTitle = (order) => {
    if (order.TrangThai === "DANG_XU_LY" && order.MethodID != 701) {
      return "Không thể hủy đơn đã thanh toán online";
    }
    return undefined;
  };

  if (loading) {
    return (
      <div className="text-center">
        <Spinner animation="border" />
      </div>
    );
  }

  if (error) {
    return <Alert variant="danger">{error}</Alert>;
  }

  return (
    <>
      <h3 className="mb-4">Danh sách đơn hàng</h3>
      {orders.length === 0 ? (
        <p>Bạn chưa có đơn hàng nào.</p>
      ) : (
        <ListGroup variant="flush">
          {orders.map((order) => {
            let badgeBg = "secondary";
            if (order.TrangThai === "DANG_XU_LY") badgeBg = "info";
            if (order.TrangThai === "DANG_GIAO") badgeBg = "warning";
            if (order.TrangThai === "DA_GIAO") badgeBg = "success";
            if (order.TrangThai === "DA_HUY") badgeBg = "danger";
            if (order.TrangThai === "CHUA_THANH_TOAN") badgeBg = "warning";

            const timeRemaining =
              order.TrangThai === "CHUA_THANH_TOAN"
                ? getTimeRemaining(order.NgayDatHang)
                : null;

            return (
              <ListGroup.Item key={order.DonHangID} className="p-0 mb-3">
                <Card className="shadow-sm">
                  <Card.Header className="d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <span className="fw-bold">
                      Mã ĐH: ORD_{order.DonHangID}
                    </span>
                    <Badge bg={badgeBg}>
                      {order.TrangThai === "CHUA_THANH_TOAN"
                        ? "Chờ thanh toán"
                        : order.TrangThai}
                    </Badge>
                  </Card.Header>
                  <Card.Body>
                    <ListGroup variant="flush" className="mb-3">
                      {order.items &&
                        order.items.map((item, index) => (
                          <ListGroup.Item
                            key={index}
                            className="d-flex align-items-center p-2 border-0"
                          >
                            <Image
                              src={item.HinhAnh}
                              style={{
                                width: "60px",
                                height: "60px",
                                objectFit: "cover",
                              }}
                              className="me-3 rounded"
                            />
                            <div className="flex-grow-1">
                              <small className="fw-bold d-block order-item-name">
                                {item.TenSanPham}
                              </small>
                              <small className="text-muted d-block">
                                {item.ThuocTinh}
                              </small>
                              <small className="text-muted">
                                SL: {item.SoLuong}
                              </small>
                            </div>

                            {order.TrangThai === "DA_GIAO" && (
                              <Button
                                variant={
                                  item.DaDanhGia
                                    ? "outline-success"
                                    : "outline-primary"
                                }
                                size="sm"
                                onClick={() => handleShowReviewModal(item)}
                              >
                                {item.DaDanhGia
                                  ? "Xem Đánh giá"
                                  : "Viết Đánh giá"}
                              </Button>
                            )}
                          </ListGroup.Item>
                        ))}
                    </ListGroup>

                    <div className="d-flex justify-content-between align-items-center border-top pt-3 flex-wrap gap-2">
                      <small className="text-muted">
                        Ngày đặt:{" "}
                        {new Date(order.NgayDatHang).toLocaleDateString(
                          "vi-VN"
                        )}
                      </small>
                      <h5 className="mb-0">
                        <span className="fs-6 text-muted me-2">
                          Thành tiền:
                        </span>
                        <strong className="text-danger">
                          {parseFloat(order.TongThanhToan).toLocaleString(
                            "vi-VN"
                          )}{" "}
                          ₫
                        </strong>
                      </h5>
                    </div>

                    {/* Hiển thị thông báo thanh toán lại */}
                    {order.TrangThai === "CHUA_THANH_TOAN" && (
                      <div className="retry-payment-section mt-3 pt-3 border-top">
                        {timeRemaining ? (
                          <div className="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2">
                            <div className="countdown-wrapper">
                              <span className="text-warning fw-bold">
                                ⏰ Còn {timeRemaining.minutes}:
                                {String(timeRemaining.seconds).padStart(2, "0")}{" "}
                                để thanh toán
                              </span>
                            </div>
                            <Button
                              variant="warning"
                              size="sm"
                              className="retry-payment-btn"
                              onClick={() =>
                                handleRetryPayment(order.DonHangID)
                              }
                              disabled={retryingOrder === order.DonHangID}
                            >
                              {retryingOrder === order.DonHangID ? (
                                <Spinner
                                  as="span"
                                  animation="border"
                                  size="sm"
                                />
                              ) : (
                                <>💳 Thanh toán lại</>
                              )}
                            </Button>
                          </div>
                        ) : (
                          <div className="text-danger fw-bold">
                            ⚠️ Đã hết thời gian thanh toán. Đơn hàng sẽ tự động
                            hủy.
                          </div>
                        )}
                      </div>
                    )}
                  </Card.Body>
                  <Card.Footer className="bg-white">
                    <div className="order-actions d-flex flex-wrap justify-content-end gap-2">
                      {order.TrangThai === "DA_GIAO" && (
                        <Button
                          as={Link}
                          to={`/profile/return-request/${order.DonHangID}`}
                          variant="outline-secondary"
                          size="sm"
                          disabled={order.DaYeuCauTraHang == 1}
                          title={
                            order.DaYeuCauTraHang == 1
                              ? "Đơn hàng này đã có yêu cầu đổi/trả"
                              : "Yêu cầu đổi/trả"
                          }
                        >
                          {order.DaYeuCauTraHang == 1
                            ? "Đã yêu cầu Đổi/Trả"
                            : "Yêu cầu Đổi/Trả"}
                        </Button>
                      )}
                      <Button
                        variant="outline-danger"
                        size="sm"
                        onClick={() => handleCancelOrder(order.DonHangID)}
                        disabled={
                          !canCancelOrder(order) ||
                          cancellingOrder === order.DonHangID
                        }
                        title={getCancelButtonTitle(order)}
                      >
                        {cancellingOrder === order.DonHangID ? (
                          <Spinner as="span" animation="border" size="sm" />
                        ) : (
                          "Hủy đơn"
                        )}
                      </Button>
                      <Button
                        variant="primary"
                        size="sm"
                        onClick={() => handleShowDetails(order.DonHangID)}
                      >
                        Chi tiết
                      </Button>
                    </div>
                  </Card.Footer>
                </Card>
              </ListGroup.Item>
            );
          })}
        </ListGroup>
      )}

      {/* MODAL CHI TIẾT ĐƠN HÀNG (USER) */}
      <Modal
        show={showDetailModal}
        onHide={handleCloseDetailModal}
        size="lg"
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title>Chi tiết đơn hàng</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {detailLoading ? (
            <div className="text-center py-4">
              <Spinner animation="border" />
            </div>
          ) : selectedOrder ? (
            <Row>
              <Col md={6} className="mb-3">
                <h6 className="fw-bold border-bottom pb-2">
                  Thông tin nhận hàng
                </h6>
                <p className="mb-1">
                  <strong>Tên:</strong> {selectedOrder.TenNguoiNhan}
                </p>
                <p className="mb-1">
                  <strong>Email:</strong> {user?.email}
                </p>
                <p className="mb-1">
                  <strong>SĐT:</strong> {selectedOrder.DienThoaiNhan}
                </p>
                <p className="mb-1">
                  <strong>Địa chỉ:</strong> {selectedOrder.DiaChiChiTiet}
                </p>
                <p className="mb-1">
                  <strong>Thanh toán:</strong>{" "}
                  {selectedOrder.TenPhuongThucThanhToan}
                </p>
              </Col>
              <Col md={6}>
                <h6 className="fw-bold border-bottom pb-2">Sản phẩm</h6>
                <ListGroup variant="flush" className="mb-3">
                  {selectedOrder.items.map((item) => (
                    <ListGroup.Item
                      key={item.PhienBanID}
                      className="d-flex align-items-center px-0"
                    >
                      <Image
                        src={item.HinhAnh}
                        style={{
                          width: "50px",
                          height: "50px",
                          objectFit: "cover",
                        }}
                        className="me-2 rounded border"
                      />
                      <div>
                        <small className="fw-bold d-block order-item-name">
                          {item.TenSanPham}
                        </small>
                        <small
                          className="text-muted d-block"
                          style={{ fontSize: "0.8em" }}
                        >
                          {item.ThuocTinh}
                        </small>
                        <small className="text-muted">
                          {item.SoLuong} x{" "}
                          {parseFloat(item.GiaLucMua).toLocaleString("vi-VN")} ₫
                        </small>
                      </div>
                    </ListGroup.Item>
                  ))}
                </ListGroup>

                <div className="bg-light p-3 rounded">
                  <div className="d-flex justify-content-between mb-1">
                    <span>Tổng tiền hàng:</span>
                    <span>
                      {parseFloat(selectedOrder.TongTienHang).toLocaleString(
                        "vi-VN"
                      )}{" "}
                      ₫
                    </span>
                  </div>
                  <div className="d-flex justify-content-between mb-2">
                    <span>Phí vận chuyển:</span>
                    <span>
                      {parseFloat(selectedOrder.PhiVanChuyen).toLocaleString(
                        "vi-VN"
                      )}{" "}
                      ₫
                    </span>
                  </div>
                  <div className="d-flex justify-content-between border-top pt-2">
                    <strong className="fs-5">Tổng thanh toán:</strong>
                    <strong className="fs-5 text-danger">
                      {parseFloat(selectedOrder.TongThanhToan).toLocaleString(
                        "vi-VN"
                      )}{" "}
                      ₫
                    </strong>
                  </div>
                </div>
              </Col>
            </Row>
          ) : (
            <p className="text-center">Không thể tải chi tiết.</p>
          )}
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleCloseDetailModal}>
            Đóng
          </Button>
        </Modal.Footer>
      </Modal>

      {/* MODAL XÁC NHẬN HỦY */}
      <Modal show={showConfirmModal} onHide={handleCloseConfirmModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>Xác nhận hủy đơn hàng</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Bạn có chắc chắn muốn hủy đơn hàng{" "}
          <strong>ORD_{orderToCancel}</strong> không? Hành động này không thể
          hoàn tác.
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleCloseConfirmModal}>
            Không
          </Button>
          <Button variant="danger" onClick={confirmCancel}>
            Xác nhận hủy
          </Button>
        </Modal.Footer>
      </Modal>

      {productToReview && (
        <ProductReviewModal
          show={showReviewModal}
          onHide={handleCloseReviewModal}
          product={productToReview}
          onReviewSubmitted={handleReviewSubmitted}
        />
      )}
    </>
  );
};

export default UserOrders;
