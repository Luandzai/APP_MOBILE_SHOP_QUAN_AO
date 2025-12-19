// client/src/components/ProductTable.jsx
import React from 'react';
import { Table, Spinner, Alert, Pagination, Button, Image, Badge } from 'react-bootstrap';
import { EyeFill, PencilSquare, Trash, ArrowDownUp, ArrowCounterclockwise } from 'react-bootstrap-icons';
import { Link } from 'react-router-dom';

const ProductTable = ({
    products,
    loading,
    error,
    pagination,
    setCurrentPage,
    onEdit,
    onDelete,
    onRestore,
    deletingId,
    restoringId,
}) => {

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
        }).format(amount || 0);
    };

    const getStatusBadge = (status) => {
        switch (status) {
            case 'ACTIVE':
                return <Badge bg="success">Đang bán</Badge>;
            case 'ARCHIVED':
                return <Badge bg="secondary">Đã ẩn</Badge>;
            case 'HET_HANG':
                return <Badge bg="danger">Hết hàng</Badge>;
            default:
                return <Badge bg="light" text="dark">{status}</Badge>;
        }
    };

    const renderPagination = () => {
        if (!pagination.totalPages || pagination.totalPages <= 1) return null;

        const { page, totalPages } = pagination;
        const items = [];
        const maxVisiblePages = 5; // Số trang hiển thị tối đa (không tính First/Last/Prev/Next)
        const sidePages = Math.floor(maxVisiblePages / 2);

        // Tính toán phạm vi trang cần hiển thị
        let startPage = Math.max(1, page - sidePages);
        let endPage = Math.min(totalPages, page + sidePages);

        // Điều chỉnh để luôn hiển thị đủ số trang
        if (endPage - startPage + 1 < maxVisiblePages) {
            if (startPage === 1) {
                endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
            } else if (endPage === totalPages) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
        }

        // Thêm trang đầu và dấu "..."
        if (startPage > 1) {
            items.push(
                <Pagination.Item key={1} onClick={() => setCurrentPage(1)}>1</Pagination.Item>
            );
            if (startPage > 2) {
                items.push(<Pagination.Ellipsis key="ellipsis-start" disabled />);
            }
        }

        // Thêm các trang giữa
        for (let number = startPage; number <= endPage; number++) {
            items.push(
                <Pagination.Item
                    key={number}
                    active={number === page}
                    onClick={() => setCurrentPage(number)}
                >
                    {number}
                </Pagination.Item>
            );
        }

        // Thêm dấu "..." và trang cuối
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                items.push(<Pagination.Ellipsis key="ellipsis-end" disabled />);
            }
            items.push(
                <Pagination.Item key={totalPages} onClick={() => setCurrentPage(totalPages)}>{totalPages}</Pagination.Item>
            );
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
        return <div className="text-center py-5"><Spinner animation="border" /> Đang tải...</div>;
    }

    if (error) {
        return <Alert variant="danger" className="m-3">{error}</Alert>;
    }

    if (products.length === 0) {
        return <div className="text-center py-5"><p className="mb-0 text-muted">Không tìm thấy sản phẩm nào</p></div>;
    }

    return (
        <>
            <div key={pagination.page} className="table-content-wrapper">
                <Table hover responsive className="align-middle mb-0">
                    <thead className="bg-light">
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tên Sản phẩm</th>
                            <th><div className="d-flex align-items-center">Giá bán<ArrowDownUp className="ms-1" /></div></th>
                            <th><div className="d-flex align-items-center">Tồn kho<ArrowDownUp className="ms-1" /></div></th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        {products.map((p) => (
                        <tr key={p.SanPhamID} className={p.TrangThai === 'ARCHIVED' ? 'table-secondary' : ''}>
                            <td>{p.SanPhamID}</td>
                            <td>
                                <Image
                                    src={p.HinhAnhChinh || "https://placehold.co/50x50?text=No+Img"}
                                    style={{ width: "50px", height: "50px", objectFit: "cover" }}
                                    thumbnail
                                />
                            </td>
                            <td style={{ maxWidth: '250px' }}>
                                <span className="d-block text-truncate" title={p.TenSanPham}>
                                    {p.TenSanPham}
                                </span>
                            </td>
                            <td>{formatCurrency(p.GiaBanThapNhat)}</td>
                            <td>{p.TongTonKho}</td>
                            <td>{getStatusBadge(p.TrangThai)}</td>
                            <td>
                                <Button 
                                    as={Link} 
                                    to={`/product/${p.Slug}`} 
                                    variant="info" 
                                    size="sm" 
                                    className="me-1" 
                                    title="Xem trên website"
                                    disabled={p.TrangThai === 'ARCHIVED'}
                                >
                                    <EyeFill />
                                </Button>
                                <Button variant="warning" size="sm" className="me-1" onClick={() => onEdit(p)} title="Chỉnh sửa">
                                    <PencilSquare />
                                </Button>
                                {p.TrangThai === 'ARCHIVED' ? (
                                    <Button 
                                        variant="success" 
                                        size="sm" 
                                        onClick={() => onRestore(p.SanPhamID)} 
                                        disabled={restoringId === p.SanPhamID}
                                        title="Khôi phục sản phẩm"
                                    >
                                        {restoringId === p.SanPhamID ? (
                                            <Spinner as="span" size="sm" animation="border" />
                                        ) : (
                                            <ArrowCounterclockwise />
                                        )}
                                    </Button>
                                ) : (
                                    <Button 
                                        variant="danger" 
                                        size="sm" 
                                        onClick={() => onDelete(p.SanPhamID)} 
                                        disabled={deletingId === p.SanPhamID}
                                        title="Ẩn sản phẩm"
                                    >
                                        {deletingId === p.SanPhamID ? (
                                            <Spinner as="span" size="sm" animation="border" />
                                        ) : (
                                            <Trash />
                                        )}
                                    </Button>
                                )}
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

export default ProductTable;
