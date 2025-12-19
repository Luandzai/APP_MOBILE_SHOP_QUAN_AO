// client/src/components/OrderFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup } from 'react-bootstrap';
import { Search } from 'react-bootstrap-icons';

const STATUS_OPTIONS = {
    CHUA_THANH_TOAN: { name: "Chưa thanh toán", icon: "💳" },
    DANG_XU_LY: { name: "Đang xử lý", icon: "⏳" },
    DANG_GIAO: { name: "Đang giao hàng", icon: "🚚" },
    DA_GIAO: { name: "Đã hoàn thành", icon: "✅" },
    DA_HUY: { name: "Đã hủy", icon: "❌" },
    DOI_TRA: { name: "Đổi/Trả hàng", icon: "🔄" },
};

const OrderFilters = ({
    searchTerm,
    setSearchTerm,
    statusFilter,
    setStatusFilter,
    sortBy,
    setSortBy,
    pageSize,
    setPageSize,
    sortOptions,
    totalOrders,
}) => {
    return (
        <Row className="align-items-center">
            <Col md={3}>
                <h5 className="mb-0">Quản lý Đơn hàng ({totalOrders})</h5>
            </Col>

            <Col md={3}>
                <InputGroup size="sm">
                    <InputGroup.Text>
                        <Search />
                    </InputGroup.Text>
                    <Form.Control
                        placeholder="Tìm đơn hàng..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </InputGroup>
            </Col>

            <Col md={2}>
                <Form.Select
                    size="sm"
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                >
                    <option value="">Tất cả trạng thái</option>
                    {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                        <option key={key} value={key}>
                            {value.icon} {value.name}
                        </option>
                    ))}
                </Form.Select>
            </Col>

            <Col md={2}>
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

            <Col md={2}>
                <Form.Select
                    size="sm"
                    value={pageSize}
                    onChange={(e) => setPageSize(Number(e.target.value))}
                >
                    {[10, 20, 50, 100].map((size) => (
                        <option key={size} value={size}>
                            {size} dòng / trang
                        </option>
                    ))}
                </Form.Select>
            </Col>
        </Row>
    );
};

export default OrderFilters;
