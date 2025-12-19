// client/src/pages/AdminReturnListPage.jsx (Refactored)
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import ReturnFilters from "../components/ReturnFilters";
import ReturnRequestTable from "../components/ReturnRequestTable";
import ReturnDetailModal from "../components/ReturnDetailModal";
import { useReturnsAdmin } from "../hooks/useReturnsAdmin";

const AdminReturnListPage = () => {
    const {
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
    } = useReturnsAdmin();

    // UI State for Detail Modal
    const [showDetailModal, setShowDetailModal] = useState(false);
    const [selectedReturnId, setSelectedReturnId] = useState(null);

    const handleViewDetail = (returnId) => {
        setSelectedReturnId(returnId);
        setShowDetailModal(true);
    };

    const handleModalClose = () => {
        setShowDetailModal(false);
        setSelectedReturnId(null);
    }
    
    // Callback for the detail modal to trigger a list refresh
    const handleReturnUpdated = () => {
        refreshReturns();
    }

    return (
        <AdminLayout>
            <h2 className="mb-4">Quản lý Yêu cầu Đổi/Trả</h2>

            <Card className="shadow-sm">
                <Card.Header className="bg-white">
                    <ReturnFilters
                        searchTerm={searchTerm}
                        setSearchTerm={setSearchTerm}
                        statusFilter={statusFilter}
                        setStatusFilter={setStatusFilter}
                        totalReturns={pagination.total}
                    />
                </Card.Header>

                <Card.Body className="p-0">
                    <ReturnRequestTable
                        returnsList={returnsList}
                        loading={loading}
                        error={error}
                        pagination={pagination}
                        setCurrentPage={setCurrentPage}
                        onViewDetail={handleViewDetail}
                    />
                </Card.Body>
            </Card>
            
            <ReturnDetailModal
                show={showDetailModal}
                onHide={handleModalClose}
                returnId={selectedReturnId}
                onUpdate={handleReturnUpdated}
            />
        </AdminLayout>
    );
};

export default AdminReturnListPage;
