// client/src/components/ProductReviewModal.jsx (ĐÃ NÂNG CẤP MEDIA)

import React, { useState, useEffect, useContext } from "react";
import { Modal, Button, Form, Alert, Spinner, Image } from "react-bootstrap";
import { toast } from "react-toastify";
import AuthContext from "../context/AuthContext";
import "./ProductReviewModal.css";
import { XCircleFill, Paperclip } from "react-bootstrap-icons"; // <-- IMPORT MỚI

// Component sao (copy từ StarRating.jsx)
const StarSelector = ({ rating, setRating }) => {
  return (
    <div className="fs-3 star-selector">
      {[1, 2, 3, 4, 5].map((star) => (
        <span
          key={star}
          style={{
            color: star <= rating ? "#f8e825" : "#e4e5e9",
          }}
          onClick={() => setRating(star)}
        >
          ★
        </span>
      ))}
    </div>
  );
};

const ProductReviewModal = ({ show, onHide, product, onReviewSubmitted }) => {
  const { api } = useContext(AuthContext);

  // States cho dữ liệu cũ
  const [existingReview, setExistingReview] = useState(null);
  const [existingImageURL, setExistingImageURL] = useState(null);
  const [existingVideoURL, setExistingVideoURL] = useState(null);

  // States cho dữ liệu mới
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState("");
  const [imageFile, setImageFile] = useState(null);
  const [videoFile, setVideoFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [videoPreview, setVideoPreview] = useState(null);

  // States cho cờ xóa (khi user bấm "X")
  const [xoaHinhAnh, setXoaHinhAnh] = useState(false);
  const [xoaVideo, setXoaVideo] = useState(false);

  // States logic
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [submitLoading, setSubmitLoading] = useState(false);

  // Hàm dọn dẹp (reset)
  const resetForm = () => {
    setExistingReview(null);
    setExistingImageURL(null);
    setExistingVideoURL(null);
    setRating(0);
    setComment("");
    setImageFile(null);
    setVideoFile(null);
    setImagePreview(null);
    setVideoPreview(null);
    setXoaHinhAnh(false);
    setXoaVideo(false);
    setLoading(true);
    setError(null);
    setSubmitLoading(false);
  };

  // 1. Khi modal mở, tải đánh giá cũ (nếu có)
  useEffect(() => {
    if (show && product) {
      resetForm(); // Xóa sạch form cũ

      const fetchReview = async () => {
        try {
          const { data } = await api.get(
            `/reviews/my-review/${product.PhienBanID}`
          );
          if (data) {
            // Đã có đánh giá -> Điền form
            setExistingReview(data);
            setRating(data.DiemSo);
            setComment(data.BinhLuan);
            setExistingImageURL(data.HinhAnhURL);
            setExistingVideoURL(data.VideoURL);
          }
          // Nếu data = null (chưa có), form vẫn rỗng
        } catch {
          setError("Không thể tải đánh giá cũ.");
        } finally {
          setLoading(false);
        }
      };
      fetchReview();
    }
  }, [show, product, api]);

  // 2. Hàm xử lý khi chọn file (Tạo Preview)
  const handleFileChange = (e, fileType) => {
    const file = e.target.files[0];
    if (!file) return;

    const previewURL = URL.createObjectURL(file);

    if (fileType === "image") {
      setImageFile(file);
      setImagePreview(previewURL);
      setExistingImageURL(null); // Xóa ảnh cũ (nếu có)
      setXoaHinhAnh(false);
    } else if (fileType === "video") {
      setVideoFile(file);
      setVideoPreview(previewURL);
      setExistingVideoURL(null); // Xóa video cũ (nếu có)
      setXoaVideo(false);
    }
  };

  // 3. Hàm xử lý khi Xóa preview
  const removeMedia = (mediaType) => {
    if (mediaType === "image") {
      if (imageFile) URL.revokeObjectURL(imagePreview); // Dọn dẹp
      setImageFile(null);
      setImagePreview(null);
      setExistingImageURL(null);
      setXoaHinhAnh(true); // Đánh cờ "Xóa ảnh"
    }
    if (mediaType === "video") {
      if (videoFile) URL.revokeObjectURL(videoPreview);
      setVideoFile(null);
      setVideoPreview(null);
      setExistingVideoURL(null);
      setXoaVideo(true); // Đánh cờ "Xóa video"
    }
  };

  // 4. Hàm Gửi (Sử dụng FormData)
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (rating === 0) {
      setError("Vui lòng chọn số sao đánh giá.");
      return;
    }
    setSubmitLoading(true);
    setError(null);

    // Tạo FormData
    const formData = new FormData();
    formData.append("DiemSo", rating);
    formData.append("BinhLuan", comment);
    formData.append("PhienBanID", product.PhienBanID); // Cần cho createReview

    // Thêm file (nếu có)
    if (imageFile) formData.append("image", imageFile);
    if (videoFile) formData.append("video", videoFile);

    // Thêm cờ Xóa (nếu có)
    if (xoaHinhAnh) formData.append("XoaHinhAnh", "true");
    if (xoaVideo) formData.append("XoaVideo", "true");

    try {
      if (existingReview) {
        // --- CHẾ ĐỘ CẬP NHẬT (Sửa) ---
        await api.put(`/reviews/${existingReview.DanhGiaID}`, formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        toast.success("Đã cập nhật đánh giá!");
      } else {
        // --- CHẾ ĐỘ TẠO MỚI ---
        await api.post("/reviews", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        toast.success("Cảm ơn bạn đã đánh giá!");
      }

      onReviewSubmitted(); // Tải lại UserOrders
      onHide(); // Đóng modal
    } catch (err) {
      setError(err.response?.data?.message || "Đã xảy ra lỗi");
    } finally {
      setSubmitLoading(false);
    }
  };

  // Cleanup effect khi component unmount
  useEffect(() => {
    return () => {
      if (imagePreview) URL.revokeObjectURL(imagePreview);
      if (videoPreview) URL.revokeObjectURL(videoPreview);
    };
  }, [imagePreview, videoPreview]);

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>
          {existingReview ? "Sửa Đánh Giá" : "Viết Đánh Giá"}
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading ? (
          <div className="text-center">
            <Spinner animation="border" />
          </div>
        ) : (
          <>
            <div className="d-flex align-items-center mb-3">
              <Image
                src={product.HinhAnh}
                style={{ width: "60px", height: "60px", objectFit: "cover" }}
                className="me-3"
              />
              <div>
                <strong className="d-block">{product.TenSanPham}</strong>
                <small className="text-muted">{product.ThuocTinh}</small>
              </div>
            </div>
            <hr />

            <Form onSubmit={handleSubmit}>
              {error && <Alert variant="danger">{error}</Alert>}
              <Form.Group className="mb-3 text-center">
                <Form.Label className="fw-bold">Chất lượng sản phẩm</Form.Label>
                <StarSelector rating={rating} setRating={setRating} />
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label>Bình luận của bạn</Form.Label>
                <Form.Control
                  as="textarea"
                  rows={4}
                  value={comment}
                  onChange={(e) => setComment(e.target.value)}
                  placeholder="Sản phẩm rất tuyệt vời..."
                />
              </Form.Group>

              {/* === KHU VỰC TẢI FILE MỚI === */}
              <Form.Group className="mb-3">
                <Form.Label>Thêm hình ảnh/video</Form.Label>
                <div className="d-flex gap-2">
                  <Button
                    as="label"
                    htmlFor="image-upload"
                    variant="outline-secondary"
                    className="flex-fill"
                  >
                    <Paperclip /> Thêm ảnh
                  </Button>
                  <Form.Control
                    type="file"
                    id="image-upload"
                    accept="image/*"
                    style={{ display: "none" }}
                    onChange={(e) => handleFileChange(e, "image")}
                  />

                  <Button
                    as="label"
                    htmlFor="video-upload"
                    variant="outline-secondary"
                    className="flex-fill"
                  >
                    <Paperclip /> Thêm video
                  </Button>
                  <Form.Control
                    type="file"
                    id="video-upload"
                    accept="video/*"
                    style={{ display: "none" }}
                    onChange={(e) => handleFileChange(e, "video")}
                  />
                </div>
              </Form.Group>

              {/* Khu vực Preview */}
              <div className="d-flex gap-2 mb-3">
                {/* Preview Ảnh (Mới hoặc Cũ) */}
                {(imagePreview || existingImageURL) && (
                  <div className="media-preview-container">
                    <Image src={imagePreview || existingImageURL} fluid />
                    <Button
                      variant="danger"
                      size="sm"
                      className="media-remove-btn"
                      onClick={() => removeMedia("image")}
                    >
                      <XCircleFill />
                    </Button>
                  </div>
                )}
                {/* Preview Video (Mới hoặc Cũ) */}
                {(videoPreview || existingVideoURL) && (
                  <div className="media-preview-container">
                    <video src={videoPreview || existingVideoURL} controls />
                    <Button
                      variant="danger"
                      size="sm"
                      className="media-remove-btn"
                      onClick={() => removeMedia("video")}
                    >
                      <XCircleFill />
                    </Button>
                  </div>
                )}
              </div>
              {/* === KẾT THÚC KHU VỰC TẢI FILE === */}

              <Button
                variant="primary"
                type="submit"
                className="w-100"
                disabled={submitLoading}
              >
                {submitLoading ? (
                  <Spinner as="span" animation="border" size="sm" />
                ) : existingReview ? (
                  "Cập nhật Đánh giá"
                ) : (
                  "Gửi Đánh giá"
                )}
              </Button>
            </Form>
          </>
        )}
      </Modal.Body>
    </Modal>
  );
};

export default ProductReviewModal;
