// client/src/components/ProductReviews.jsx
import React, { useState } from "react";
import { Alert, Image, Modal } from "react-bootstrap";
import { Link } from "react-router-dom";
import { PlayCircleFill } from "react-bootstrap-icons";
import StarRating from "./StarRating";
import "./ProductReviews.css";

const ProductReviews = ({ reviews }) => {
  const [showImageModal, setShowImageModal] = useState(false);
  const [modalImageUrl, setModalImageUrl] = useState("");
  const [showVideoModal, setShowVideoModal] = useState(false);
  const [modalVideoUrl, setModalVideoUrl] = useState("");

  const handleShowImageModal = (url) => {
    setModalImageUrl(url);
    setShowImageModal(true);
  };

  const handleShowVideoModal = (url) => {
    setModalVideoUrl(url);
    setShowVideoModal(true);
  };

  return (
    <div className="mt-3">
      <h4 className="mb-4 fw-bold">Đánh giá sản phẩm</h4>
      {reviews && reviews.length > 0 ? (
        reviews.map((review) => (
          <div key={review.DanhGiaID} className="review-card">
            <div className="review-header">
              <div>
                <div className="review-user-name">{review.HoTen}</div>
                <StarRating value={review.DiemSo} size={14} />
              </div>
              <div className="review-date">
                {new Date(
                  review.NgayCapNhat || review.NgayTao
                ).toLocaleDateString("vi-VN")}
                {review.NgayCapNhat && (
                  <span className="fst-italic"> (đã chỉnh sửa)</span>
                )}
              </div>
            </div>

            {review.ThuocTinh && (
              <p className="text-muted small mb-2 fst-italic">
                Phân loại: {review.ThuocTinh}
              </p>
            )}

            <p className="review-content mb-3">{review.BinhLuan}</p>

            <div className="review-media-grid">
              {review.HinhAnhURL && (
                <div
                  className="review-media-thumbnail"
                  onClick={() => handleShowImageModal(review.HinhAnhURL)}
                >
                  <Image src={review.HinhAnhURL} thumbnail />
                </div>
              )}
              {review.VideoURL && (
                <div
                  className="review-media-thumbnail video-thumbnail"
                  onClick={() => handleShowVideoModal(review.VideoURL)}
                >
                  <video src={review.VideoURL} />
                  <PlayCircleFill className="play-icon-overlay" />
                </div>
              )}
            </div>
            {/* [MỚI] PHẦN TRẢ LỜI CỦA SHOP */}
            {review.PhanHoi && (
              <div className="shop-reply-container mt-3 p-3 rounded">
                <div className="d-flex align-items-center mb-1">
                  <strong className="text-primary me-2">
                    Phản hồi từ Người bán
                  </strong>
                  {review.NgayPhanHoi && (
                    <small className="text-muted">
                      {new Date(review.NgayPhanHoi).toLocaleDateString("vi-VN")}
                    </small>
                  )}
                </div>
                <p
                  className="mb-0 text-secondary small"
                  style={{ whiteSpace: "pre-line" }}
                >
                  {review.PhanHoi}
                </p>
              </div>
            )}
          </div>
        ))
      ) : (
        <p className="text-center text-muted py-4">
          Hiện chưa có đánh giá nào.
        </p>
      )}
      <Alert variant="info" className="mt-4">
        Để lại đánh giá? Vui lòng mua hàng và đánh giá từ trang{" "}
        <Link to="/profile/orders">Đơn hàng của tôi</Link>.
      </Alert>

      {/* Media Modals */}
      <Modal
        show={showImageModal}
        onHide={() => setShowImageModal(false)}
        centered
        size="lg"
      >
        <Modal.Body>
          <Image src={modalImageUrl} fluid />
        </Modal.Body>
      </Modal>
      <Modal
        show={showVideoModal}
        onHide={() => setShowVideoModal(false)}
        centered
        size="lg"
      >
        <Modal.Body>
          <video
            src={modalVideoUrl}
            controls
            autoPlay
            style={{ width: "100%" }}
          />
        </Modal.Body>
      </Modal>
    </div>
  );
};

export default ProductReviews;
