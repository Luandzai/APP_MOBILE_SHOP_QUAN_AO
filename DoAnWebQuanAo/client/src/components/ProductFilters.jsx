// client/src/components/ProductFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup, Button } from 'react-bootstrap';
import { Search, Plus } from 'react-bootstrap-icons';

const ProductFilters = ({
    searchTerm,
    setSearchTerm,
    sortBy,
    setSortBy,
    statusFilter,
    setStatusFilter,
    pageSize,
    setPageSize,
    sortOptions,
    statusOptions,
    totalProducts,
    onShowAddModal,
}) => {
    return (
        <Row className="align-items-center gy-2">
            <Col lg={4} md={6}>
                <h5 className="mb-0">Quản lý Sản phẩm ({totalProducts})</h5>
            </Col>

            <Col lg={3} md={6}>
                <InputGroup size="sm">
                    <InputGroup.Text><Search /></InputGroup.Text>
                    <Form.Control
                        placeholder="Tìm theo ID, tên, SKU..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </InputGroup>
            </Col>

            <Col lg={2} md={4}>
                <Form.Select
                    size="sm"
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                >
                    {Object.values(statusOptions).map((option) => (
                        <option key={option.key} value={option.key}>
                            {option.name}
                        </option>
                    ))}
                </Form.Select>
            </Col>

            <Col lg={2} md={4}>
                <Form.Select
                    size="sm"
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value)}
                >
                    {Object.values(sortOptions).map((option) => (
                        <option key={option.key} value={option.key}>
                            {option.name}
                        </option>
                    ))}
                </Form.Select>
            </Col>

            <Col lg={1} md={4} className="d-flex justify-content-end align-items-center">
                <Form.Select
                    size="sm"
                    value={pageSize}
                    onChange={(e) => setPageSize(Number(e.target.value))}
                    className="me-2"
                    style={{ width: 'auto' }}
                >
                    {[10, 20, 50].map((size) => (
                        <option key={size} value={size}>
                            {size}
                        </option>
                    ))}
                </Form.Select>
                <Button variant="primary" size="sm" onClick={onShowAddModal}>
                    <Plus />
                </Button>
            </Col>
        </Row>
    );
};

export default ProductFilters;
