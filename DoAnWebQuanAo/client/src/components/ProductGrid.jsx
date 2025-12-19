// client/src/components/ProductGrid.jsx
import React from 'react';
import { Row, Col, Spinner, Alert, Pagination } from 'react-bootstrap';
import ProductCard from './ProductCard';

const ProductGrid = ({ products, loading, error, pagination, onPageChange }) => {

    const renderPagination = () => {
        if (!pagination || !pagination.totalPages || pagination.totalPages <= 1) return null;
        
        const { currentPage, totalPages } = pagination;
        const items = [];
        const maxVisiblePages = 5;
        const sidePages = Math.floor(maxVisiblePages / 2);

        let startPage = Math.max(1, currentPage - sidePages);
        let endPage = Math.min(totalPages, currentPage + sidePages);

        if (endPage - startPage + 1 < maxVisiblePages) {
            if (startPage === 1) {
                endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
            } else if (endPage === totalPages) {
                startPage = Math.max(1, endPage - maxVisiblePages + 1);
            }
        }

        if (startPage > 1) {
            items.push(<Pagination.Item key={1} onClick={() => onPageChange(1)}>1</Pagination.Item>);
            if (startPage > 2) {
                items.push(<Pagination.Ellipsis key="ellipsis-start" disabled />);
            }
        }

        for (let number = startPage; number <= endPage; number++) {
            items.push(
                <Pagination.Item key={number} active={number === currentPage} onClick={() => onPageChange(number)}>
                    {number}
                </Pagination.Item>
            );
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                items.push(<Pagination.Ellipsis key="ellipsis-end" disabled />);
            }
            items.push(<Pagination.Item key={totalPages} onClick={() => onPageChange(totalPages)}>{totalPages}</Pagination.Item>);
        }

        return (
            <Pagination className="justify-content-center mt-4">
                <Pagination.First onClick={() => onPageChange(1)} disabled={currentPage === 1} />
                <Pagination.Prev onClick={() => onPageChange(currentPage - 1)} disabled={currentPage === 1} />
                {items}
                <Pagination.Next onClick={() => onPageChange(currentPage + 1)} disabled={currentPage === totalPages} />
                <Pagination.Last onClick={() => onPageChange(totalPages)} disabled={currentPage === totalPages} />
            </Pagination>
        );
    };

    if (loading) {
        return (
            <div className="text-center py-5" style={{ minHeight: "300px" }}>
                <Spinner animation="border" />
            </div>
        );
    }

    if (error) {
        return <Alert variant="danger">{error}</Alert>;
    }

    if (!products || products.length === 0) {
        return <p className="text-center text-muted">Không có sản phẩm nào khớp với tiêu chí của bạn.</p>;
    }

    return (
        <>
            <Row>
                {products.map((product) => (
                    <Col key={product.SanPhamID} xs={6} sm={6} lg={4} className="mb-4">
                        <ProductCard product={product} />
                    </Col>
                ))}
            </Row>
            {renderPagination()}
        </>
    );
};

export default ProductGrid;
