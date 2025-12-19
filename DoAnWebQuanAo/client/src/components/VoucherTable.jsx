// client/src/components/VoucherTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Button, Badge } from 'react-bootstrap';
import { PencilSquare, Trash, ArrowReturnLeft } from 'react-bootstrap-icons';

const LOAI_GIAM_GIA = {
    PHANTRAM: "%",
    SOTIEN: "₫",
};

const VoucherTable = ({
    vouchers,
    loading,
    error,
    onEdit,
    onStatusChange,
    isProcessing,
}) => {
    
    const formatCurrency = (amount) => new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0);
    const formatDate = (dateString) => new Date(dateString).toLocaleDateString("vi-VN");

    if (loading) {
        return <div className="text-center py-5"><Spinner animation="border" /> Đang tải...</div>;
    }

    if (error) {
        return <Alert variant="danger" className="m-3">{error}</Alert>;
    }

    return (
        <Table striped hover responsive size="sm" className="align-middle">
            <thead>
                <tr>
                    <th>Mã KM</th>
                    <th>Tên Chương trình</th>
                    <th>Giá trị</th>
                    <th>Hạn dùng</th>
                    <th>Tồn</th>
                    <th>Trạng Thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                {vouchers.map((v) => {
                    const isExpired = new Date(v.NgayKetThuc) < new Date();
                    const isOutOfStock = v.SoLuongToiDa === 0;
                    const isActive = v.TrangThai === "ACTIVE";
                    let stockBadge = "success";
                    if (isOutOfStock) stockBadge = "danger";
                    else if (v.SoLuongToiDa <= 5) stockBadge = "warning";

                    return (
                        <tr key={v.MaKhuyenMai} className={!isActive ? "table-secondary" : ""}>
                            <td>
                                <strong className={isExpired || !isActive ? "text-danger" : "text-primary"}>
                                    {v.MaKhuyenMai}
                                </strong>
                            </td>
                            <td>{v.TenKhuyenMai}</td>
                            <td>
                                {v.LoaiGiamGia === "PHANTRAM"
                                    ? `${v.GiaTriGiam}%`
                                    : formatCurrency(v.GiaTriGiam)}
                            </td>
                            <td>
                                <span className={isExpired ? "text-danger fw-bold" : ""}>{formatDate(v.NgayKetThuc)}</span>
                                {isExpired && <Badge bg="secondary" className="ms-1">Hết hạn</Badge>}
                            </td>
                            <td><Badge bg={stockBadge}>{isOutOfStock ? "Hết lượt" : v.SoLuongToiDa}</Badge></td>
                            <td><Badge bg={isActive ? "success" : "secondary"}>{isActive ? "Hoạt động" : "Vô hiệu hóa"}</Badge></td>
                            <td>
                                <Button
                                    variant="warning"
                                    size="sm"
                                    className="me-2"
                                    onClick={() => onEdit(v)}
                                    disabled={isProcessing}
                                >
                                    <PencilSquare />
                                </Button>
                                <Button
                                    variant={isActive ? "danger" : "success"}
                                    size="sm"
                                    onClick={() => onStatusChange(v.MaKhuyenMai, isActive ? 'disable' : 'enable')}
                                    disabled={isProcessing}
                                    title={isActive ? "Vô hiệu hóa" : "Kích hoạt lại"}
                                >
                                    {isProcessing ? <Spinner as="span" size="sm" animation="border" /> : (isActive ? <Trash /> : <ArrowReturnLeft />)}
                                </Button>
                            </td>
                        </tr>
                    );
                })}
            </tbody>
        </Table>
    );
};

export default VoucherTable;
