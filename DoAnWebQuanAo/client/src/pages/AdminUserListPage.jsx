// client/src/pages/AdminUserListPage.jsx (Refactored)
import React, { useState, useMemo } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import ConfirmModal from "../components/ConfirmModal";
import UserFilters from "../components/UserFilters";
import UserTable from "../components/UserTable";
import { useUsersAdmin } from "../hooks/useUsersAdmin";

const AdminUserListPage = () => {
    const {
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
    } = useUsersAdmin();

    // Modal state
    const [showConfirmModal, setShowConfirmModal] = useState(false);
    const [pendingUpdate, setPendingUpdate] = useState(null);

    const handleStatusChange = (userId, currentStatus) => {
        const newStatus = currentStatus === 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
        setPendingUpdate({ userId, newStatus, type: 'status' });
        setShowConfirmModal(true);
    };

    const handleRoleChange = (userId, currentRole) => {
        const newRole = currentRole === 'ADMIN' ? 'KHACHHANG' : 'ADMIN';
        setPendingUpdate({ userId, newRole, type: 'role' });
        setShowConfirmModal(true);
    };

    const handleConfirm = async () => {
        if (!pendingUpdate) return;
        
        if (pendingUpdate.type === 'status') {
            await updateUserStatus(pendingUpdate.userId, pendingUpdate.newStatus);
        } else if (pendingUpdate.type === 'role') {
            await updateUserRole(pendingUpdate.userId, pendingUpdate.newRole);
        }

        setShowConfirmModal(false);
        setPendingUpdate(null);
    };

    const modalContent = useMemo(() => {
        if (!pendingUpdate) return {};
        const { type, newStatus, newRole, userId } = pendingUpdate;

        if (type === 'status') {
            const action = newStatus === 'INACTIVE' ? 'KHÓA' : 'MỞ KHÓA';
            return {
                title: `Xác nhận ${action} Tài khoản`,
                message: `Bạn có chắc chắn muốn ${action} tài khoản #${userId}?`,
                confirmText: action,
                variant: newStatus === 'INACTIVE' ? 'danger' : 'success',
            };
        }
        if (type === 'role') {
            const action = newRole === 'ADMIN' ? 'NÂNG CẤP' : 'HẠ CẤP';
            const roleName = newRole === 'ADMIN' ? 'Quản trị viên' : 'Khách hàng';
            return {
                title: `Xác nhận ${action} Vai trò`,
                message: `Bạn có chắc muốn ${action} tài khoản #${userId} thành ${roleName}?`,
                confirmText: action,
                variant: 'warning',
            };
        }
        return {};
    }, [pendingUpdate]);

    return (
        <AdminLayout>
            <Card className="shadow-sm">
                <Card.Header className="bg-white">
                    <UserFilters
                        searchTerm={searchTerm}
                        setSearchTerm={setSearchTerm}
                        roleFilter={roleFilter}
                        setRoleFilter={setRoleFilter}
                        statusFilter={statusFilter}
                        setStatusFilter={setStatusFilter}
                        sortBy={sortBy}
                        setSortBy={setSortBy}
                        pageSize={pageSize}
                        setPageSize={setPageSize}
                        sortOptions={SORT_OPTIONS}
                        totalUsers={pagination.total}
                    />
                </Card.Header>
                <Card.Body className="p-0">
                    <UserTable
                        users={users}
                        loading={loading}
                        error={error}
                        pagination={pagination}
                        setCurrentPage={setCurrentPage}
                        onRoleChange={handleRoleChange}
                        onStatusChange={handleStatusChange}
                        updatingId={updatingId}
                        currentUserId={currentUser?.NguoiDungID}
                    />
                </Card.Body>
            </Card>

            <ConfirmModal
                show={showConfirmModal}
                onHide={() => setShowConfirmModal(false)}
                onConfirm={handleConfirm}
                title={modalContent.title}
                message={modalContent.message}
                confirmText={modalContent.confirmText}
                confirmVariant={modalContent.variant}
                isProcessing={!!updatingId}
            />
        </AdminLayout>
    );
};

export default AdminUserListPage;
