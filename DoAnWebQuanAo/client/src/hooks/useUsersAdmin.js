// client/src/hooks/useUsersAdmin.js
import { useState, useEffect, useContext, useCallback } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';

const SORT_OPTIONS = {
    DATE_DESC: { key: 'DATE_DESC', name: 'Mới nhất trước' },
    DATE_ASC: { key: 'DATE_ASC', name: 'Cũ nhất trước' },
    NAME_ASC: { key: 'NAME_ASC', name: 'Tên (A-Z)' },
    NAME_DESC: { key: 'NAME_DESC', name: 'Tên (Z-A)' },
};

export const useUsersAdmin = () => {
    // Data states
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [pagination, setPagination] = useState({ total: 0, page: 1, limit: 10, totalPages: 0 });

    // Filter & Sort states
    const [searchTerm, setSearchTerm] = useState('');
    const [statusFilter, setStatusFilter] = useState('');
    const [roleFilter, setRoleFilter] = useState('');
    const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
    const [pageSize, setPageSize] = useState(10);
    const [currentPage, setCurrentPage] = useState(1);

    // Action states
    const [updatingId, setUpdatingId] = useState(null);

    const { api, user: currentUser } = useContext(AuthContext);

    const fetchUsers = useCallback(async (filters) => {
        setLoading(true);
        try {
            const params = new URLSearchParams();
            if (filters.search) params.append('search', filters.search);
            if (filters.status) params.append('status', filters.status);
            if (filters.role) params.append('role', filters.role);
            if (filters.sortBy) params.append('sortBy', filters.sortBy);
            if (filters.page) params.append('page', filters.page);
            if (filters.limit) params.append('limit', filters.limit);

            const { data } = await api.get(`/admin/users?${params.toString()}`);
            setUsers(data.users || []);
            setPagination(data.pagination || { total: 0, page: 1, limit: 10, totalPages: 0 });
            setError(null);
        } catch (err) {
            const errMsg = err.response?.data?.message || "Không thể tải danh sách người dùng.";
            setError(errMsg);
            toast.error(errMsg);
        } finally {
            setLoading(false);
        }
    }, [api]);
    
    // Debounced effect for filters
    useEffect(() => {
        const handler = setTimeout(() => {
            if (currentPage !== 1) {
                setCurrentPage(1);
            } else {
                fetchUsers({
                    search: searchTerm,
                    status: statusFilter,
                    role: roleFilter,
                    sortBy: sortBy,
                    page: 1,
                    limit: pageSize,
                });
            }
        }, 500);
        return () => clearTimeout(handler);
    }, [searchTerm, statusFilter, roleFilter, sortBy, pageSize]);
    
    // Effect for page changes
    useEffect(() => {
        fetchUsers({
            search: searchTerm,
            status: statusFilter,
            role: roleFilter,
            sortBy: sortBy,
            page: currentPage,
            limit: pageSize,
        });
    }, [currentPage, fetchUsers]);

    const updateUserStatus = async (userId, newStatus) => {
        setUpdatingId(userId);
        try {
            await api.put(`/admin/users/${userId}/status`, { trangThaiMoi: newStatus });
            toast.success("Cập nhật trạng thái thành công.");
            fetchUsers({ search: searchTerm, status: statusFilter, role: roleFilter, sortBy: sortBy, page: currentPage, limit: pageSize });
        } catch (err) {
            toast.error(err.response?.data?.message || "Cập nhật trạng thái thất bại.");
        } finally {
            setUpdatingId(null);
        }
    };
    
    const updateUserRole = async (userId, newRole) => {
        setUpdatingId(userId);
        try {
            await api.put(`/admin/users/${userId}/role`, { vaiTroMoi: newRole });
            toast.success("Cập nhật vai trò thành công.");
            fetchUsers({ search: searchTerm, status: statusFilter, role: roleFilter, sortBy: sortBy, page: currentPage, limit: pageSize });
        } catch (err) {
            toast.error(err.response?.data?.message || "Cập nhật vai trò thất bại.");
        } finally {
            setUpdatingId(null);
        }
    };

    return {
        users,
        loading,
        error,
        pagination,
        searchTerm,
        setSearchTerm,
        statusFilter,
        setStatusFilter,
        roleFilter,
        setRoleFilter,
        sortBy,
        setSortBy,
        pageSize,
        setPageSize,
        currentPage,
        setCurrentPage,
        updatingId,
        updateUserStatus,
        updateUserRole,
        currentUser,
        SORT_OPTIONS,
    };
};
