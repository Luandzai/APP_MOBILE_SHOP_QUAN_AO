// client/src/pages/AdminReviewListPage.jsx (Refactored)
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import ConfirmModal from "../components/ConfirmModal";
import ReviewFilters from "../components/ReviewFilters";
import ReviewTable from "../components/ReviewTable";
import ReplyReviewModal from "../components/ReplyReviewModal";
import { useReviewsAdmin } from "../hooks/useReviewsAdmin";

const AdminReviewListPage = () => {
  const {
    reviews,
    loading,
    error,
    pagination,
    searchTerm,
    setSearchTerm,
    ratingFilter,
    setRatingFilter,
    currentPage,
    setCurrentPage,
    isProcessing,
    deleteReview,
    replyReview,
  } = useReviewsAdmin();

  // Modal Confirm
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [selectedReviewId, setSelectedReviewId] = useState(null);
  // [MỚI] State Modal Trả lời
  const [showReplyModal, setShowReplyModal] = useState(false);
  const [reviewToReply, setReviewToReply] = useState(null);

  const handleDelete = (reviewId) => {
    setSelectedReviewId(reviewId);
    setShowConfirmModal(true);
  };

  const confirmDeletion = async () => {
    if (!selectedReviewId) return;
    await deleteReview(selectedReviewId);
    setShowConfirmModal(false);
    setSelectedReviewId(null);
  };
  // [MỚI] Xử lý Trả lời
  const handleReplyClick = (review) => {
    setReviewToReply(review);
    setShowReplyModal(true);
  };
  const handleReplySubmit = async (reviewId, content) => {
    const success = await replyReview(reviewId, content);
    if (success) {
      setShowReplyModal(false);
      setReviewToReply(null);
    }
  };

  return (
    <AdminLayout>
      <h2 className="mb-4">Quản lý Đánh giá</h2>

      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <ReviewFilters
            searchTerm={searchTerm}
            setSearchTerm={setSearchTerm}
            ratingFilter={ratingFilter}
            setRatingFilter={setRatingFilter}
            totalReviews={pagination.total}
          />
        </Card.Header>

        <Card.Body className="p-0">
          <ReviewTable
            reviews={reviews}
            loading={loading}
            error={error}
            pagination={pagination}
            setCurrentPage={setCurrentPage}
            onDelete={handleDelete}
            onReply={handleReplyClick}
            isProcessing={isProcessing}
          />
        </Card.Body>
      </Card>

      <ConfirmModal
        show={showConfirmModal}
        onHide={() => setShowConfirmModal(false)}
        onConfirm={confirmDeletion}
        title="Xác nhận Xóa Đánh giá"
        message={`Bạn có chắc chắn muốn XÓA vĩnh viễn đánh giá #${selectedReviewId}? Media trên Cloudinary cũng sẽ bị xóa.`}
        confirmText="Xóa vĩnh viễn"
        confirmVariant="danger"
        isProcessing={isProcessing}
      />
      {/* [MỚI] Modal Trả lời */}
      <ReplyReviewModal
        show={showReplyModal}
        onHide={() => setShowReplyModal(false)}
        review={reviewToReply}
        onSubmit={handleReplySubmit}
        isProcessing={isProcessing}
      />
    </AdminLayout>
  );
};

export default AdminReviewListPage;
