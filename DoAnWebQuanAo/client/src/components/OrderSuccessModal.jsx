// client/src/components/OrderSuccessModal.jsx

import React from "react";
import { Modal, Button } from "react-bootstrap";
// (Nếu chưa cài 'react-bootstrap-icons', hãy chạy: npm install react-bootstrap-icons)
import { CheckCircleFill } from "react-bootstrap-icons";
import { useNavigate } from "react-router-dom";
import "./OrderSuccessModal.css"; // Import CSS

const OrderSuccessModal = ({ show, onHide }) => {
  const navigate = useNavigate();

  // Hàm xử lý khi bấm "Quay về trang chủ"
  const handleGoToHome = () => {
    onHide(); // Đóng modal
    navigate("/");
  };

  // Hàm xử lý khi bấm "Đơn hàng của bạn"
  const handleGoToOrders = () => {
    onHide(); // Đóng modal
    navigate("/profile/orders"); // Điều hướng đến trang đơn hàng
  };

  return (
    // backdrop="static" và keyboard={false} ngăn người dùng bấm ra ngoài để tắt
    <Modal
      show={show}
      onHide={onHide}
      centered
      backdrop="static"
      keyboard={false}
    >
      <Modal.Body className="text-center p-4">
        {/* Icon dấu tích */}
        <div className="success-modal-icon">
          <CheckCircleFill />
        </div>

        <h3 className="fw-bold mb-3">Đặt hàng thành công!</h3>

        <p className="text-muted">
          Cảm ơn bạn đã đặt hàng, bộ phận chăm sóc khách hàng sẽ liên hệ với bạn
          trong vòng 24h để xác nhận, hãy để ý điện thoại bạn nhé!
        </p>

        {/* Hai nút bấm */}
        <div className="d-grid gap-2 d-sm-flex justify-content-sm-center mt-4">
          <Button
            variant="warning"
            onClick={handleGoToHome}
            className="fw-bold px-4"
          >
            Quay về trang chủ
          </Button>
          <Button
            variant="primary"
            onClick={handleGoToOrders}
            className="fw-bold px-4"
          >
            Đơn hàng của bạn
          </Button>
        </div>
      </Modal.Body>
    </Modal>
  );
};

export default OrderSuccessModal;
