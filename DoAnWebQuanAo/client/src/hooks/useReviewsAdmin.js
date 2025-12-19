// client/src/hooks/useReviewsAdmin.js
import { useState, useEffect, useContext, useCallback } from "react";
import { toast } from "react-toastify";
import AuthContext from "../context/AuthContext";

export const useReviewsAdmin = () => {
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [pagination, setPagination] = useState({ total: 0, totalPages: 0 });

  // Filter & Pagination
  const [searchTerm, setSearchTerm] = useState("");
  const [ratingFilter, setRatingFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);

  // Actions
  const [isProcessing, setIsProcessing] = useState(false);

  const { api } = useContext(AuthContext);

  const fetchReviews = useCallback(
    async (page = 1) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();
        params.append("page", page);
        params.append("limit", 10);
        if (searchTerm) params.append("search", searchTerm);
        if (ratingFilter) params.append("rating", ratingFilter);

        const { data } = await api.get(`/admin/reviews?${params.toString()}`);
        setReviews(data.reviews || []);
        setPagination(data.pagination || { total: 0, totalPages: 0 });
        setError(null);
      } catch (err) {
        const errMsg =
          err.response?.data?.message || "Không thể tải danh sách đánh giá.";
        setError(errMsg);
        toast.error(errMsg);
      } finally {
        setLoading(false);
      }
    },
    [api, searchTerm, ratingFilter]
  );

  useEffect(() => {
    // Reset to page 1 when filters change
    if (currentPage !== 1) {
      setCurrentPage(1);
    } else {
      fetchReviews(1);
    }
  }, [searchTerm, ratingFilter]);

  useEffect(() => {
    fetchReviews(currentPage);
  }, [currentPage, fetchReviews]);

  const deleteReview = async (reviewId) => {
    setIsProcessing(true);
    try {
      await api.delete(`/admin/reviews/${reviewId}`);
      toast.success("Đã xóa đánh giá thành công.");
      // Refresh current page
      fetchReviews(currentPage);
    } catch (err) {
      toast.error(err.response?.data?.message || "Xóa đánh giá thất bại.");
    } finally {
      setIsProcessing(false);
    }
  };
  // [MỚI] Hàm trả lời đánh giá
  const replyReview = async (reviewId, content) => {
    setIsProcessing(true);
    try {
      await api.put(`/admin/reviews/${reviewId}/reply`, { noiDung: content });
      toast.success("Đã gửi câu trả lời.");
      fetchReviews(currentPage); // Tải lại danh sách
      return true; // Trả về true nếu thành công
    } catch (err) {
      toast.error(err.response?.data?.message || "Gửi trả lời thất bại.");
      return false;
    } finally {
      setIsProcessing(false);
    }
  };

  return {
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
  };
};
