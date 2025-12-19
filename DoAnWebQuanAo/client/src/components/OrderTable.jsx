// client/src/components/OrderTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Badge, Dropdown, Button } from 'react-bootstrap';
import { EyeFill, ArrowDownUp, Calendar2Check } from 'react-bootstrap-icons';

const STATUS_OPTIONS = {
    CHUA_THANH_TOAN: { name: "Chưa thanh toán", color: "secondary", icon: "💳" },
    DANG_XU_LY: { name: "Đang xử lý", color: "info", icon: "⏳" },
    DANG_GIAO: { name: "Đang giao hàng", color: "warning", icon: "🚚" },
    DA_GIAO: { name: "Đã hoàn thành", color: "success", icon: "✅" },
    DA_HUY: { name: "Đã hủy", color: "danger", icon: "❌" },
    DOI_TRA: { name: "Đổi/Trả hàng", color: "dark", icon: "🔄" },
};

const STATUS_TRANSITIONS = {
    CHUA_THANH_TOAN: ["DANG_XU_LY", "DA_HUY"],
    DANG_XU_LY: ["DANG_GIAO", "DA_HUY"],
    DANG_GIAO: ["DA_GIAO", "DA_HUY"],
    DA_GIAO: [],
    DA_HUY: [],
    DOI_TRA: [],
};

const OrderTable = ({
    orders,
    loading,
    error,
    pagination,
    setCurrentPage,
    onViewDetail,
    onStatusUpdate,
    updatingId,
}) => {

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
            minimumFractionDigits: 0,
        }).format(amount);
    };

    const formatDate = (dateString) => {
        return new Date(dateString).toLocaleString("vi-VN", {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
        });
    };

    const renderPagination = () => {
        if (!pagination.totalPages || pagination.totalPages <= 1) return null;

        const { page, totalPages } = pagination;
        const items = [];
        const maxVisiblePages = 5;
        const sidePages = Math.floor(maxVisiblePages / 2);

        let startPage = Math.max(1, page - sidePages);
        let endPage = Math.min(totalPages, page + sidePages);

        if (endPage - startPage + 1 < maxVisiblePages) {
            if (startPage === 1) {
                endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
            } else if (endPage === totalPages) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
        }

        if (startPage > 1) {
            items.push(<Pagination.Item key={1} onClick={() => setCurrentPage(1)}>1</Pagination.Item>);
            if (startPage > 2) {
                items.push(<Pagination.Ellipsis key="ellipsis-start" disabled />);
            }
        }

        for (let number = startPage; number <= endPage; number++) {
            items.push(
                <Pagination.Item key={number} active={number === page} onClick={() => setCurrentPage(number)}>
                    {number}
                </Pagination.Item>
            );
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                items.push(<Pagination.Ellipsis key="ellipsis-end" disabled />);
            }
            items.push(<Pagination.Item key={totalPages} onClick={() => setCurrentPage(totalPages)}>{totalPages}</Pagination.Item>);
        }

        return (
            <div className="d-flex justify-content-center p-3">
                <Pagination>
                    <Pagination.First onClick={() => setCurrentPage(1)} disabled={page === 1} />
                    <Pagination.Prev onClick={() => setCurrentPage(page - 1)} disabled={page === 1} />
                    {items}
                    <Pagination.Next onClick={() => setCurrentPage(page + 1)} disabled={page === totalPages} />
                    <Pagination.Last onClick={() => setCurrentPage(totalPages)} disabled={page === totalPages} />
                </Pagination>
            </div>
        );
    };

    if (loading) {
        return (
            <div className="text-center py-5">
                <Spinner animation="border" className="mb-2" />
                <p className="mb-0">Đang tải danh sách đơn hàng...</p>
            </div>
        );
    }

    if (error) {
        return (
            <Alert variant="danger" className="m-3">
                <Alert.Heading>Không thể tải dữ liệu</Alert.Heading>
                <p className="mb-0">{error}</p>
            </Alert>
        );
    }

    if (orders.length === 0) {
        return (
            <div className="text-center py-5">
                <p className="mb-0 text-muted">Không tìm thấy đơn hàng nào</p>
            </div>
        );
    }

    return (
        <>
            <div key={pagination.page} className="table-content-wrapper">
                <Table hover responsive className="align-middle mb-0">
                    <thead className="bg-light">
                        <tr>
                            <th className="text-nowrap">Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th><div className="d-flex align-items-center">Ngày đặt<Calendar2Check className="ms-1" /></div></th>
                            <th><div className="d-flex align-items-center">Tổng tiền<ArrowDownUp className="ms-1" /></div></th>
                            <th>Trạng thái</th>
                            <th style={{ width: "180px" }}>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        {orders.map((order) => (
                            <tr key={order.DonHangID}>
                                <td><strong className="text-primary">#{order.DonHangID}</strong></td>
                                <td>
                                    <div>{order.HoTen}</div>
                                    <small className="text-muted">{order.Email}</small>
                                </td>
                                <td>{formatDate(order.NgayDatHang)}</td>
                                <td><strong>{formatCurrency(order.TongThanhToan)}</strong></td>
                                <td>
                                    <Badge bg={STATUS_OPTIONS[order.TrangThai]?.color} className="d-inline-flex align-items-center">
                                        <span className="me-1">{STATUS_OPTIONS[order.TrangThai]?.icon}</span>
                                        {STATUS_OPTIONS[order.TrangThai]?.name}
                                    </Badge>
                                </td>
                                <td>
                                    <Dropdown size="sm" className="d-inline me-1">
                                        <Dropdown.Toggle
                                            variant="primary"
                                            id={`dropdown-${order.DonHangID}`}
                                            disabled={updatingId === order.DonHangID || !STATUS_TRANSITIONS[order.TrangThai]?.length}
                                        >
                                            {updatingId === order.DonHangID ? (
                                                <><Spinner as="span" animation="border" size="sm" className="me-1" />Cập nhật</>
                                            ) : ( "Cập nhật" )}
                                        </Dropdown.Toggle>

                                        <Dropdown.Menu>
                                            {STATUS_TRANSITIONS[order.TrangThai]?.map((status) => (
                                                <Dropdown.Item key={status} onClick={() => onStatusUpdate(order.DonHangID, status)}>
                                                    {STATUS_OPTIONS[status].icon}{" "}{STATUS_OPTIONS[status].name}
                                                </Dropdown.Item>
                                            ))}
                                        </Dropdown.Menu>
                                    </Dropdown>
                                    <Button variant="info" size="sm" onClick={() => onViewDetail(order.DonHangID)}>
                                        <EyeFill className="me-1" />Chi tiết
                                    </Button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </Table>
            </div>
            {renderPagination()}
        </>
    );
};

export default OrderTable;
