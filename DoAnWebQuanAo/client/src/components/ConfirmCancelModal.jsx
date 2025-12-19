// client/src/components/ConfirmCancelModal.jsx

import React from "react";
import { Modal, Button, Spinner } from "react-bootstrap";
import { ExclamationTriangleFill } from "react-bootstrap-icons"; // Icon cảnh báo

const ConfirmCancelModal = ({ show, onHide, onConfirm, isCancelling }) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>
          <ExclamationTriangleFill color="orange" className="me-2" />
          Xác nhận hủy đơn hàng
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể
        hoàn tác.
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isCancelling}>
          Hủy bỏ
        </Button>
        <Button variant="danger" onClick={onConfirm} disabled={isCancelling}>
          {isCancelling ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                role="status"
                aria-hidden="true"
              />
              <span className="ms-2">Đang xử lý...</span>
            </>
          ) : (
            "Xác nhận hủy"
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmCancelModal;
