// client/src/hooks/useProductsAdmin.js
import { useState, useEffect, useContext, useCallback } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';

const SORT_OPTIONS = {
    DATE_DESC: { key: 'DATE_DESC', name: 'Mới nhất trước' },
    DATE_ASC: { key: 'DATE_ASC', name: 'Cũ nhất trước' },
    PRICE_ASC: { key: 'PRICE_ASC', name: 'Giá tăng dần' },
    PRICE_DESC: { key: 'PRICE_DESC', name: 'Giá giảm dần' },
    STOCK_DESC: { key: 'STOCK_DESC', name: 'Tồn kho nhiều nhất' },
    STOCK_ASC: { key: 'STOCK_ASC', name: 'Tồn kho ít nhất' },
};

const STATUS_OPTIONS = {
    ALL: { key: '', name: 'Tất cả trạng thái' },
    ACTIVE: { key: 'ACTIVE', name: 'Đang bán' },
    ARCHIVED: { key: 'ARCHIVED', name: 'Đã ẩn' },
};

export const useProductsAdmin = () => {
    // Data states
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [pagination, setPagination] = useState({ total: 0, page: 1, limit: 10, totalPages: 0 });

    // Action states
    const [deletingId, setDeletingId] = useState(null);
    const [restoringId, setRestoringId] = useState(null);
    
    // Filter & Sort states
    const [searchTerm, setSearchTerm] = useState('');
    const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
    const [statusFilter, setStatusFilter] = useState('');
    const [pageSize, setPageSize] = useState(10);
    const [currentPage, setCurrentPage] = useState(1);

    const { api } = useContext(AuthContext);

    const fetchProducts = useCallback(async (filters) => {
        setLoading(true);
        try {
            const params = new URLSearchParams();
            if (filters.search) params.append('search', filters.search);
            if (filters.sortBy) params.append('sortBy', filters.sortBy);
            if (filters.status) params.append('status', filters.status);
            if (filters.page) params.append('page', filters.page);
            if (filters.limit) params.append('limit', filters.limit);

            const { data } = await api.get(`/admin/products?${params.toString()}`);
            setProducts(data.products || []);
            setPagination(data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 });
            setError(null);
        } catch (err) {
            const errMsg = err.response?.data?.message || "Không thể tải danh sách sản phẩm.";
            setError(errMsg);
            toast.error(errMsg);
        } finally {
            setLoading(false);
        }
    }, [api]);

    // Effect for handling filter changes with debounce
    useEffect(() => {
        const handler = setTimeout(() => {
             // Reset to page 1 whenever filters change
            if (currentPage !== 1) {
                setCurrentPage(1);
            } else {
                fetchProducts({
                    search: searchTerm,
                    sortBy: sortBy,
                    status: statusFilter,
                    page: 1, // Fetch page 1
                    limit: pageSize,
                });
            }
        }, 500);
        return () => clearTimeout(handler);
    }, [searchTerm, sortBy, statusFilter, pageSize]);


    // Effect for handling page changes
    useEffect(() => {
        fetchProducts({
            search: searchTerm,
            sortBy: sortBy,
            status: statusFilter,
            page: currentPage,
            limit: pageSize,
        });
    }, [currentPage, fetchProducts]);

    const deleteProduct = async (productId) => {
        setDeletingId(productId);
        try {
            await api.delete(`/products/${productId}`);
            toast.success("Đã xóa (lưu trữ) sản phẩm thành công.");
            // Refresh the list
            fetchProducts({
                search: searchTerm,
                sortBy: sortBy,
                status: statusFilter,
                page: currentPage,
                limit: pageSize,
            });
        } catch (err) {
            toast.error(err.response?.data?.message || "Xóa thất bại.");
        } finally {
            setDeletingId(null);
        }
    };

    const restoreProduct = async (productId) => {
        setRestoringId(productId);
        try {
            await api.patch(`/products/${productId}/restore`);
            toast.success("Khôi phục sản phẩm thành công!");
            // Refresh the list
            fetchProducts({
                search: searchTerm,
                sortBy: sortBy,
                status: statusFilter,
                page: currentPage,
                limit: pageSize,
            });
        } catch (err) {
            toast.error(err.response?.data?.message || "Khôi phục thất bại.");
        } finally {
            setRestoringId(null);
        }
    };
    
    // This function can be called after modal updates
    const refreshProducts = () => {
         fetchProducts({
            search: searchTerm,
            sortBy: sortBy,
            status: statusFilter,
            page: currentPage,
            limit: pageSize,
        });
    }

    return {
        products,
        loading,
        error,
        pagination,
        deletingId,
        restoringId,
        searchTerm,
        setSearchTerm,
        sortBy,
        setSortBy,
        statusFilter,
        setStatusFilter,
        pageSize,
        setPageSize,
        currentPage,
        setCurrentPage,
        deleteProduct,
        restoreProduct,
        refreshProducts,
        SORT_OPTIONS,
        STATUS_OPTIONS,
    };
};
