// client/src/components/ReturnRequestTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button, Badge } from 'react-bootstrap';
import { EyeFill } from 'react-bootstrap-icons';

const STATUS_OPTIONS = {
    PENDING: { name: "Chờ xử lý", color: "warning" },
    APPROVED: { name: "Đã phê duyệt", color: "primary" },
    REJECTED: { name: "Đã từ chối", color: "danger" },
    COMPLETED: { name: "Đã hoàn tất", color: "success" },
};

const ReturnRequestTable = ({
    returnsList,
    loading,
    error,
    pagination,
    setCurrentPage,
    onViewDetail
}) => {

    const formatCurrency = (amount) => new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0);
    const formatDate = (dateString) => new Date(dateString).toLocaleDateString("vi-VN");

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
            <div className="d-flex justify-content-center p-3 border-top">
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
        return <div className="text-center py-5"><Spinner animation="border" /> Đang tải...</div>;
    }

    if (error) {
        return <Alert variant="danger" className="m-3">{error}</Alert>;
    }

    if (returnsList.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy yêu cầu nào.</p></div>;
    }

    return (
        <>
            <div key={pagination.page} className="table-content-wrapper">
                <Table hover responsive className="align-middle mb-0">
                    <thead className="bg-light">
                        <tr>
                            <th>Mã YC</th>
                            <th>Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th>Ngày YC</th>
                            <th>Hoàn trả</th>
                            <th>Trạng thái</th>
                            <th style={{ width: "150px" }}>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        {returnsList.map((req) => (
                            <tr key={req.ReturnID}>
                                <td><strong className="text-primary">#{req.ReturnID}</strong></td>
                                <td>#{req.DonHangID}</td>
                                <td>
                                    <div>{req.TenKhachHang}</div>
                                    <small className="text-muted">{req.Email}</small>
                                </td>
                                <td>{formatDate(req.NgayYeuCau)}</td>
                                <td>
                                    {req.RefundAmount ? (
                                        <strong className="text-success">{formatCurrency(req.RefundAmount)}</strong>
                                    ) : (
                                        <span className="text-muted">Chưa xác định</span>
                                    )}
                                </td>
                                <td>
                                    <Badge bg={STATUS_OPTIONS[req.Status]?.color}>{STATUS_OPTIONS[req.Status]?.name}</Badge>
                                </td>
                                <td>
                                    <Button variant="info" size="sm" onClick={() => onViewDetail(req.ReturnID)} className="me-2">
                                        <EyeFill /> Chi tiết
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

export default ReturnRequestTable;
