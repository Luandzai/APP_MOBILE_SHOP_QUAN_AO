// client/src/components/ConfirmModal.jsx (ĐÃ SỬA LỖI HYDRATION)

import React from "react";
import { Modal, Button, Spinner } from "react-bootstrap";

const ConfirmModal = ({
  show,
  onHide,
  onConfirm,
  title,
  message,
  confirmText = "Xác nhận",
  confirmVariant = "primary",
  isProcessing = false,
}) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>

      {/* KHẮC PHỤC LỖI: Loại bỏ thẻ <p> bao bọc message 
          Điều này cho phép truyền JSX phức tạp (như Form.Group, div) 
          mà không vi phạm quy tắc lồng ghép của HTML. 
      */}
      <Modal.Body>
        {/* Nếu message là string, ta bọc bằng <p> để giữ định dạng đoạn văn */}
        {typeof message === "string" ? <p>{message}</p> : message}
      </Modal.Body>

      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isProcessing}>
          Hủy
        </Button>
        <Button
          variant={confirmVariant}
          onClick={onConfirm}
          disabled={isProcessing}
        >
          {isProcessing ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                role="status"
                aria-hidden="true"
                className="me-1"
              />
              Đang xử lý...
            </>
          ) : (
            confirmText
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmModal;
