// client/src/pages/AdminOrderListPage.jsx
import React, { useState } from "react";
import { Card } from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import ConfirmStatusModal from "../components/ConfirmStatusModal";
import OrderDetailModal from "../components/OrderDetailModal";
import OrderFilters from "../components/OrderFilters";
import OrderTable from "../components/OrderTable";
import { useOrders } from "../hooks/useOrders";

const AdminOrderListPage = () => {
  const {
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
    sortOptions,
    currentPage,
    setCurrentPage,
    updatingId,
    updateOrderStatus,
    SORT_OPTIONS,
  } = useOrders();

  // UI State for modals
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedOrderIdForDetail, setSelectedOrderIdForDetail] =
    useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [pendingStatusUpdate, setPendingStatusUpdate] = useState(null); // { orderId, newStatus }

  const handleViewDetail = (orderId) => {
    setSelectedOrderIdForDetail(orderId);
    setShowDetailModal(true);
  };

  const handleStatusUpdate = (orderId, newStatus) => {
    setPendingStatusUpdate({ orderId, newStatus });
    setShowConfirmModal(true);
  };

  // === ĐÃ SỬA: BỎ THAM SỐ shippingData ===
  const confirmStatusUpdate = async () => {
    if (!pendingStatusUpdate) return;

    await updateOrderStatus(
      pendingStatusUpdate.orderId,
      pendingStatusUpdate.newStatus
    );

    setShowConfirmModal(false);
    setPendingStatusUpdate(null);
  };

  const getStatusName = (statusKey) => {
    const statusMap = {
      CHUA_THANH_TOAN: "Chưa thanh toán",
      DANG_XU_LY: "Đang xử lý",
      DANG_GIAO: "Đang giao hàng",
      DA_GIAO: "Đã hoàn thành",
      DA_HUY: "Đã hủy",
      DOI_TRA: "Đổi/Trả hàng",
    };
    return statusMap[statusKey] || statusKey;
  };

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        <Card.Header className="bg-white">
          <OrderFilters
            searchTerm={searchTerm}
            setSearchTerm={setSearchTerm}
            statusFilter={statusFilter}
            setStatusFilter={setStatusFilter}
            sortBy={sortBy}
            setSortBy={setSortBy}
            pageSize={pageSize}
            setPageSize={setPageSize}
            sortOptions={SORT_OPTIONS}
            totalOrders={pagination.total}
          />
        </Card.Header>

        <Card.Body className="p-0">
          <OrderTable
            orders={orders}
            loading={loading}
            error={error}
            pagination={pagination}
            setCurrentPage={setCurrentPage}
            onViewDetail={handleViewDetail}
            onStatusUpdate={handleStatusUpdate}
            updatingId={updatingId}
          />
        </Card.Body>
      </Card>

      {/* Confirmation Modal for status updates */}
      <ConfirmStatusModal
        show={showConfirmModal}
        onHide={() => setShowConfirmModal(false)}
        onConfirm={confirmStatusUpdate}
        title="Xác nhận thay đổi trạng thái"
        message={
          pendingStatusUpdate
            ? `Bạn có chắc muốn chuyển đơn hàng #${
                pendingStatusUpdate.orderId
              } sang trạng thái "${getStatusName(
                pendingStatusUpdate.newStatus
              )}"?`
            : ""
        }
        isProcessing={!!updatingId}
        // targetStatus={pendingStatusUpdate?.newStatus} // KHÔNG CẦN TRUYỀN NỮA
      />

      {/* Order Detail Modal */}
      <OrderDetailModal
        show={showDetailModal}
        onHide={() => setShowDetailModal(false)}
        orderId={selectedOrderIdForDetail}
      />
    </AdminLayout>
  );
};

export default AdminOrderListPage;
