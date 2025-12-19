// client/src/components/ReplyReviewModal.jsx
import React, { useState, useEffect } from "react";
import { Modal, Button, Form, Spinner } from "react-bootstrap";

const ReplyReviewModal = ({ show, onHide, review, onSubmit, isProcessing }) => {
  const [replyText, setReplyText] = useState("");

  // Khi mở modal, nếu đã có phản hồi trước đó thì điền vào (để sửa)
  useEffect(() => {
    if (show && review) {
      setReplyText(review.PhanHoi || "");
    }
  }, [show, review]);

  const handleSubmit = () => {
    onSubmit(review.DanhGiaID, replyText);
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>Trả lời đánh giá #{review?.DanhGiaID}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <div className="mb-3 p-3 bg-light rounded">
          <strong>Khách hàng:</strong> {review?.TenNguoiDung} <br />
          <strong>Nội dung:</strong> "{review?.BinhLuan}"
        </div>
        <Form.Group>
          <Form.Label>Nội dung trả lời từ Shop:</Form.Label>
          <Form.Control
            as="textarea"
            rows={4}
            value={replyText}
            onChange={(e) => setReplyText(e.target.value)}
            placeholder="Cảm ơn bạn đã ủng hộ shop..."
          />
        </Form.Group>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isProcessing}>
          Đóng
        </Button>
        <Button
          variant="primary"
          onClick={handleSubmit}
          disabled={isProcessing || !replyText.trim()}
        >
          {isProcessing ? (
            <Spinner size="sm" animation="border" />
          ) : (
            "Gửi trả lời"
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ReplyReviewModal;
