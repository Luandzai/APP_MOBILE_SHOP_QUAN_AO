// client/src/hooks/useOrders.js
import { useState, useEffect, useContext, useCallback } from "react";
import { toast } from "react-toastify";
import AuthContext from "../context/AuthContext";

const SORT_OPTIONS = {
  DATE_DESC: { key: "DATE_DESC", name: "Mới nhất trước" },
  DATE_ASC: { key: "DATE_ASC", name: "Cũ nhất trước" },
  TOTAL_DESC: { key: "TOTAL_DESC", name: "Tổng tiền giảm dần" },
  TOTAL_ASC: { key: "TOTAL_ASC", name: "Tổng tiền tăng dần" },
};

export const useOrders = () => {
  // Data states
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [pagination, setPagination] = useState({
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  });

  // Filter states
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
  const [pageSize, setPageSize] = useState(10);
  const [currentPage, setCurrentPage] = useState(1);

  // Update/Processing states
  const [updatingId, setUpdatingId] = useState(null);

  const { api } = useContext(AuthContext);

  const fetchOrders = useCallback(
    async (filters) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();
        if (filters.search) params.append("search", filters.search);
        if (filters.status) params.append("status", filters.status);
        if (filters.sortBy) params.append("sortBy", filters.sortBy);
        if (filters.page) params.append("page", filters.page);
        if (filters.limit) params.append("limit", filters.limit);

        const { data } = await api.get(`/admin/orders?${params.toString()}`);
        setOrders(data.orders || []);
        setPagination(
          data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 }
        );
        setError(null);
      } catch (error) {
        const errMsg =
          error.response?.data?.message || "Không thể tải danh sách đơn hàng";
        setError(errMsg);
        toast.error(errMsg);
      } finally {
        setLoading(false);
      }
    },
    [api]
  );

  // Effect for handling filter changes with debounce
  useEffect(() => {
    const fetchDebounced = () => {
      fetchOrders({
        search: searchTerm,
        status: statusFilter,
        sortBy: sortBy,
        page: currentPage,
        limit: pageSize,
      });
    };

    const timeoutId = setTimeout(fetchDebounced, 500);
    return () => clearTimeout(timeoutId);
  }, [searchTerm, statusFilter, sortBy, currentPage, pageSize, fetchOrders]);

  // Effect to reset to page 1 when filters change (but not page itself)
  useEffect(() => {
    if (currentPage !== 1) {
      setCurrentPage(1);
    }
  }, [searchTerm, statusFilter, sortBy, pageSize]);

  // === CẬP NHẬT HÀM NÀY ĐỂ NHẬN SHIPPING DATA ===
  const updateOrderStatus = async (orderId, newStatus, shippingData = {}) => {
    setUpdatingId(orderId);
    try {
      const response = await api.put(`/admin/orders/${orderId}/status`, {
        trangThaiMoi: newStatus,
        ...shippingData, // Spread shipping info (maVanDon, tenDonViVC)
      });
      toast.success(
        response.data.message || `Đã cập nhật trạng thái đơn hàng #${orderId}`
      );
      // Refresh orders
      fetchOrders({
        search: searchTerm,
        status: statusFilter,
        sortBy: sortBy,
        page: currentPage,
        limit: pageSize,
      });
    } catch (error) {
      toast.error(
        error.response?.data?.message || "Không thể cập nhật trạng thái."
      );
    } finally {
      setUpdatingId(null);
    }
  };

  return {
    orders,
    loading,
    error,
    pagination,
    searchTerm,
    setSearchTerm,
    statusFilter,
    setStatusFilter,
    sortBy,
    setSortBy,
    pageSize,
    setPageSize,
    currentPage,
    setCurrentPage,
    updatingId,
    updateOrderStatus,
    SORT_OPTIONS,
  };
};
