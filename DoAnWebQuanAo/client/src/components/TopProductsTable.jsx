// client/src/components/TopProductsTable.jsx
import React from 'react';
import { Card, Spinner, Table } from 'react-bootstrap';
import { TrophyFill } from 'react-bootstrap-icons';
import { Link } from 'react-router-dom';

const TopProductsTable = ({ products, loading }) => {
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat("vi-VN", {
            style: "currency",
            currency: "VND",
            minimumFractionDigits: 0,
        }).format(amount);
    };

    const formatNumber = (num) => {
        return new Intl.NumberFormat("vi-VN").format(num);
    };

    return (
        <Card className="shadow-sm">
            <Card.Header className="d-flex align-items-center">
                <TrophyFill className="me-2 text-warning" />
                Top 10 Sản phẩm bán chạy
            </Card.Header>
            <Card.Body className="p-0">
                {loading ? (
                    <div className="text-center py-5">
                        <Spinner animation="border" size="sm" />
                    </div>
                ) : products.length > 0 ? (
                    <Table hover responsive className="align-middle mb-0">
                        <thead className="bg-light">
                            <tr>
                                <th>#</th>
                                <th>Tên sản phẩm</th>
                                <th className="text-center">Đã bán</th>
                                <th className="text-end">Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            {products.map((product, index) => (
                                <tr key={product.Slug}>
                                    <td>{index + 1}</td>
                                    <td>
                                        <Link
                                            to={`/product/${product.Slug}`}
                                            target="_blank"
                                            className="text-decoration-none"
                                        >
                                            {product.TenSanPham}
                                        </Link>
                                    </td>
                                    <td className="text-center">
                                        {formatNumber(product.totalSold)}
                                    </td>
                                    <td className="text-end fw-bold text-success">
                                        {formatCurrency(product.totalRevenue)}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>
                ) : (
                    <p className="text-muted text-center p-3 mb-0">
                        Chưa có dữ liệu bán hàng.
                    </p>
                )}
            </Card.Body>
        </Card>
    );
};

export default TopProductsTable;
