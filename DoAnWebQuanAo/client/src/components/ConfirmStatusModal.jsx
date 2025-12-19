// client/src/components/ConfirmStatusModal.jsx
import React from "react";
import { Modal, Button, Spinner } from "react-bootstrap";

const ConfirmStatusModal = ({
  show,
  onHide,
  onConfirm,
  title,
  message,
  isProcessing,
}) => {
  // Đã xóa form nhập liệu liên quan đến vận chuyển

  const handleConfirm = () => {
    // Không còn dữ liệu vận chuyển để gửi đi
    onConfirm();
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>{message}</p>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isProcessing}>
          Hủy bỏ
        </Button>
        <Button
          variant="primary"
          onClick={handleConfirm}
          disabled={isProcessing}
        >
          {isProcessing ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                className="me-2"
              />
              Đang xử lý...
            </>
          ) : (
            "Xác nhận"
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmStatusModal;
