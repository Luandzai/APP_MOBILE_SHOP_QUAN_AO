// client/src/hooks/useReturnsAdmin.js
import { useState, useEffect, useContext, useCallback } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';

export const useReturnsAdmin = () => {
    // Data states
    const [returnsList, setReturnsList] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [pagination, setPagination] = useState({ total: 0, page: 1, limit: 10, totalPages: 0 });

    // Filter & Pagination states
    const [searchTerm, setSearchTerm] = useState('');
    const [statusFilter, setStatusFilter] = useState('');
    const [pageSize] = useState(10); // Keep it constant for now
    const [currentPage, setCurrentPage] = useState(1);
    
    const { api } = useContext(AuthContext);

    const fetchReturns = useCallback(async (filters) => {
        setLoading(true);
        try {
            const params = new URLSearchParams();
            if (filters.search) params.append('search', filters.search);
            if (filters.status) params.append('status', filters.status);
            if (filters.page) params.append('page', filters.page);
            if (filters.limit) params.append('limit', filters.limit);

            const { data } = await api.get(`/admin/returns?${params.toString()}`);
            setReturnsList(data.returns || []);
            setPagination(data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 });
            setError(null);
        } catch (err) {
            const errMsg = err.response?.data?.message || "Không thể tải danh sách yêu cầu đổi/trả.";
            setError(errMsg);
            toast.error(errMsg);
        } finally {
            setLoading(false);
        }
    }, [api]);

    // Effect for handling filter changes with debounce
    useEffect(() => {
        const handler = setTimeout(() => {
            if (currentPage !== 1) {
                setCurrentPage(1);
            } else {
                 fetchReturns({
                    search: searchTerm,
                    status: statusFilter,
                    page: 1,
                    limit: pageSize,
                });
            }
        }, 500);
        return () => clearTimeout(handler);
    }, [searchTerm, statusFilter, pageSize]);

    // Effect for handling page changes
    useEffect(() => {
        fetchReturns({
            search: searchTerm,
            status: statusFilter,
            page: currentPage,
            limit: pageSize,
        });
    }, [currentPage, fetchReturns]);

    const refreshReturns = () => {
        fetchReturns({
            search: searchTerm,
            status: statusFilter,
            page: currentPage,
            limit: pageSize,
        });
    }

    return {
        returnsList,
        loading,
        error,
        pagination,
        searchTerm,
        setSearchTerm,
        statusFilter,
        setStatusFilter,
        currentPage,
        setCurrentPage,
        refreshReturns,
    };
};
