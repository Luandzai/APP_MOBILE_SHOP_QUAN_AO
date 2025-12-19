// client/src/pages/PaymentResultPage.jsx
import React, { useEffect, useState } from "react";
import { useSearchParams, Link } from "react-router-dom";
import {
  Container,
  Row,
  Col,
  Card,
  Spinner,
  Alert,
  Button,
} from "react-bootstrap";
import { CheckCircleFill, XCircleFill } from "react-bootstrap-icons";
import successImage from "../assets/success.png";
import failedImage from "../assets/failed.png";

const PaymentResultPage = () => {
  const [searchParams] = useSearchParams();
  const [message, setMessage] = useState("");
  const [isSuccess, setIsSuccess] = useState(false);
  const [loading, setLoading] = useState(true);
  const [orderId, setOrderId] = useState(null);

  useEffect(() => {
    const success = searchParams.get("success");
    const currentOrderId = searchParams.get("orderId");
    const vnpMessage = searchParams.get("message");

    setOrderId(currentOrderId); // Lưu Order ID vào state

    if (success === "true") {
      setIsSuccess(true);
      setMessage(`Đơn hàng #${currentOrderId} đã được thanh toán thành công.`);
    } else {
      setIsSuccess(false);
      if (vnpMessage === "InvalidSignature") {
        setMessage(
          "Có lỗi trong quá trình xác thực thanh toán. Vui lòng liên hệ bộ phận hỗ trợ."
        );
      } else if (currentOrderId) {
        setMessage(
          `Thanh toán cho đơn hàng #${currentOrderId} đã thất bại. Vui lòng thử lại.`
        );
      } else {
        setMessage(
          "Thanh toán của bạn không thành công. Vui lòng kiểm tra lại thông tin hoặc thử phương thức khác."
        );
      }
    }
    setLoading(false);
  }, [searchParams]);

  if (loading) {
    return (
      <Container
        className="d-flex justify-content-center align-items-center"
        style={{ minHeight: "60vh" }}
      >
        <Spinner animation="border" role="status">
          <span className="visually-hidden">Đang tải...</span>
        </Spinner>
      </Container>
    );
  }

  return (
    <Container className="py-5" style={{ minHeight: "70vh" }}>
      <Row className="justify-content-center">
        <Col md={8} lg={6}>
          <Card className="text-center shadow-lg border-0 rounded-4">
            <Card.Body className="p-5">
              {isSuccess ? (
                <>
                  <img
                    src={successImage}
                    alt="Thanh toán thành công"
                    className="mb-4"
                    style={{ maxWidth: "350px", width: "100%" }}
                  />
                  <h2 className="text-success fw-bold mb-3">
                    <CheckCircleFill className="me-2" /> Thanh toán Thành công!
                  </h2>
                  <p className="lead text-muted mb-4">{message}</p>
                </>
              ) : (
                <>
                  <img
                    src={failedImage}
                    alt="Thanh toán thất bại"
                    className="mb-4"
                    style={{ maxWidth: "350px", width: "100%" }}
                  />
                  <h2 className="text-danger fw-bold mb-3">
                    <XCircleFill className="me-2" /> Thanh toán Thất bại!
                  </h2>
                  <p className="lead text-muted mb-4">{message}</p>
                  {orderId && (
                    <Alert variant="info" className="mt-3">
                      Đơn hàng của bạn (`#${orderId}`) vẫn đang chờ thanh toán.
                      Bạn có thể thử lại hoặc chọn phương thức thanh toán khác.
                    </Alert>
                  )}
                </>
              )}

              <div className="mt-5 d-grid gap-3 d-md-block">
                {isSuccess && orderId && (
                  <Button
                    as={Link}
                    to={`/profile/orders`} // Link đến đơn hàng
                    variant="primary"
                    size="lg"
                    className="me-md-3 mb-2 mb-md-0"
                  >
                    Xem Đơn Hàng
                  </Button>
                )}
                <Button
                  as={Link}
                  to="/products"
                  variant="outline-secondary"
                  size="lg"
                >
                  Tiếp tục mua sắm
                </Button>
              </div>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default PaymentResultPage;
