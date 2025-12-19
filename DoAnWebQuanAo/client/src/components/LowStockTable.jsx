// client/src/components/LowStockTable.jsx
import React from 'react';
import { Card, Spinner, Table } from 'react-bootstrap';
import { ExclamationTriangleFill } from 'react-bootstrap-icons';
import { Link } from 'react-router-dom';

const LowStockTable = ({ products, loading }) => {
    const formatNumber = (num) => {
        return new Intl.NumberFormat("vi-VN").format(num);
    };

    return (
        <Card className="shadow-sm">
            <Card.Header className="d-flex align-items-center">
                <ExclamationTriangleFill className="me-2 text-danger" />
                Top 10 Sản phẩm tồn kho thấp
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
                                <th className="text-center">Tồn kho</th>
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
                                    <td className="text-center fw-bold text-danger">
                                        {formatNumber(product.totalStock)}
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>
                ) : (
                    <p className="text-muted text-center p-3 mb-0">
                        Không có sản phẩm nào có tồn kho thấp.
                    </p>
                )}
            </Card.Body>
        </Card>
    );
};

export default LowStockTable;
