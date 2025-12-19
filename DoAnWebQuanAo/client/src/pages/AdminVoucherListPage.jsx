// client/src/pages/AdminVoucherListPage.jsx (Refactored)
import React, { useState, useMemo } from "react";
import { Card, Button } from "react-bootstrap";
import { Plus } from "react-bootstrap-icons";
import AdminLayout from "../components/AdminLayout";
import AdminVoucherModal from "../components/AdminVoucherModal.jsx";
import ConfirmModal from "../components/ConfirmModal";
import VoucherTable from "../components/VoucherTable";
import { useVouchersAdmin } from "../hooks/useVouchersAdmin";

const AdminVoucherListPage = () => {
    const {
        vouchers,
        loading,
        error,
        isProcessing,
        updateVoucherStatus,
        refreshVouchers
    } = useVouchersAdmin();

    // Modal states
    const [showModal, setShowModal] = useState(false);
    const [isEditMode, setIsEditMode] = useState(false);
    const [voucherToEdit, setVoucherToEdit] = useState(null);
    const [showConfirmModal, setShowConfirmModal] = useState(false);
    const [pendingAction, setPendingAction] = useState(null); // { code, action: 'disable' | 'enable' }

    const handleShowAddModal = () => {
        setIsEditMode(false);
        setVoucherToEdit(null);
        setShowModal(true);
    };

    const handleShowEditModal = (voucher) => {
        setIsEditMode(true);
        setVoucherToEdit(voucher);
        setShowModal(true);
    };

    const handleVoucherUpdated = () => {
        refreshVouchers();
    };
    
    const handleStatusChange = (voucherCode, action) => {
        setPendingAction({ code: voucherCode, action });
        setShowConfirmModal(true);
    };

    const handleConfirm = async () => {
        if (!pendingAction) return;
        await updateVoucherStatus(pendingAction.code, pendingAction.action);
        setShowConfirmModal(false);
        setPendingAction(null);
    };
    
    const modalConfig = useMemo(() => {
        if (!pendingAction) return {};
        if (pendingAction.action === 'disable') {
            return {
                title: "Xác nhận Vô hiệu hóa Voucher",
                message: `Bạn có chắc chắn muốn VÔ HIỆU HÓA voucher "${pendingAction.code}"?`,
                confirmText: "Vô hiệu hóa",
                variant: "danger",
            };
        }
        return {
            title: "Xác nhận Kích hoạt Voucher",
            message: `Bạn có chắc chắn muốn KÍCH HOẠT LẠI voucher "${pendingAction.code}"?`,
            confirmText: "Kích hoạt",
            variant: "success",
        };
    }, [pendingAction]);

    return (
        <AdminLayout>
            <Card className="shadow-sm">
                <Card.Header className="d-flex justify-content-between align-items-center">
                    <h5>Quản lý Khuyến mãi/Voucher ({vouchers.length})</h5>
                    <Button variant="primary" size="sm" onClick={handleShowAddModal}>
                        <Plus /> Thêm Voucher
                    </Button>
                </Card.Header>
                <Card.Body className="p-0">
                    <VoucherTable
                        vouchers={vouchers}
                        loading={loading}
                        error={error}
                        onEdit={handleShowEditModal}
                        onStatusChange={handleStatusChange}
                        isProcessing={isProcessing}
                    />
                </Card.Body>
            </Card>

            <AdminVoucherModal
                show={showModal}
                onHide={() => setShowModal(false)}
                onVoucherUpdated={handleVoucherUpdated}
                isEdit={isEditMode}
                voucherToEdit={voucherToEdit}
            />

            <ConfirmModal
                show={showConfirmModal}
                onHide={() => setShowConfirmModal(false)}
                onConfirm={handleConfirm}
                title={modalConfig.title}
                message={modalConfig.message}
                confirmText={modalConfig.confirmText}
                confirmVariant={modalConfig.variant}
                isProcessing={isProcessing}
            />
        </AdminLayout>
    );
};

export default AdminVoucherListPage;
