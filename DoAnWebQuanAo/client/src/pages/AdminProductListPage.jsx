// client/src/pages/AdminProductListPage.jsx (Refactored)
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AdminProductModal from "../components/AdminProductModal.jsx";
import ConfirmModal from "../components/ConfirmModal.jsx";
import ProductFilters from "../components/ProductFilters.jsx";
import ProductTable from "../components/ProductTable.jsx";
import { useProductsAdmin } from "../hooks/useProductsAdmin.js";

const AdminProductListPage = () => {
    const {
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
    } = useProductsAdmin();

    // State for modals
    const [showModal, setShowModal] = useState(false);
    const [isEditMode, setIsEditMode] = useState(false);
    const [productToEdit, setProductToEdit] = useState(null);
    const [showConfirmDelete, setShowConfirmDelete] = useState(false);
    const [productToDeleteId, setProductToDeleteId] = useState(null);
    const [showConfirmRestore, setShowConfirmRestore] = useState(false);
    const [productToRestoreId, setProductToRestoreId] = useState(null);

    const handleShowAddModal = () => {
        setIsEditMode(false);
        setProductToEdit(null);
        setShowModal(true);
    };

    const handleShowEditModal = (product) => {
        setIsEditMode(true);
        setProductToEdit(product);
        setShowModal(true);
    };
    
    const handleProductUpdated = () => {
        refreshProducts();
    };

    const handleDeleteClick = (productId) => {
        setProductToDeleteId(productId);
        setShowConfirmDelete(true);
    };

    const handleConfirmDelete = () => {
        deleteProduct(productToDeleteId);
        setShowConfirmDelete(false);
        setProductToDeleteId(null);
    };

    const handleRestoreClick = (productId) => {
        setProductToRestoreId(productId);
        setShowConfirmRestore(true);
    };

    const handleConfirmRestore = () => {
        restoreProduct(productToRestoreId);
        setShowConfirmRestore(false);
        setProductToRestoreId(null);
    };

    return (
        <AdminLayout>
            <Card className="shadow-sm">
                <Card.Header className="bg-white">
                    <ProductFilters
                        searchTerm={searchTerm}
                        setSearchTerm={setSearchTerm}
                        sortBy={sortBy}
                        setSortBy={setSortBy}
                        statusFilter={statusFilter}
                        setStatusFilter={setStatusFilter}
                        pageSize={pageSize}
                        setPageSize={setPageSize}
                        sortOptions={SORT_OPTIONS}
                        statusOptions={STATUS_OPTIONS}
                        totalProducts={pagination.total}
                        onShowAddModal={handleShowAddModal}
                    />
                </Card.Header>

                <Card.Body className="p-0">
                    <ProductTable
                        products={products}
                        loading={loading}
                        error={error}
                        pagination={pagination}
                        setCurrentPage={setCurrentPage}
                        onEdit={handleShowEditModal}
                        onDelete={handleDeleteClick}
                        onRestore={handleRestoreClick}
                        deletingId={deletingId}
                        restoringId={restoringId}
                    />
                </Card.Body>
            </Card>

            <AdminProductModal
                show={showModal}
                onHide={() => setShowModal(false)}
                onProductUpdated={handleProductUpdated}
                isEdit={isEditMode}
                productToEdit={productToEdit}
            />

            <ConfirmModal
                show={showConfirmDelete}
                onHide={() => setShowConfirmDelete(false)}
                onConfirm={handleConfirmDelete}
                title="Xác nhận Ẩn Sản phẩm"
                message="Bạn có chắc chắn muốn ẩn sản phẩm này không? Sản phẩm sẽ không hiển thị trên trang người dùng nhưng vẫn có thể khôi phục lại."
                confirmText="Ẩn"
                confirmVariant="danger"
                isProcessing={!!deletingId}
            />

            <ConfirmModal
                show={showConfirmRestore}
                onHide={() => setShowConfirmRestore(false)}
                onConfirm={handleConfirmRestore}
                title="Xác nhận Khôi phục Sản phẩm"
                message="Bạn có chắc chắn muốn khôi phục sản phẩm này không? Sản phẩm sẽ hiển thị lại trên trang người dùng."
                confirmText="Khôi phục"
                confirmVariant="success"
                isProcessing={!!restoringId}
            />
        </AdminLayout>
    );
};

export default AdminProductListPage;
