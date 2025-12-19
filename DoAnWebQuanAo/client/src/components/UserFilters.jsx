// client/src/components/UserFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup } from 'react-bootstrap';
import { Search } from 'react-bootstrap-icons';

const ROLE_OPTIONS = {
    KHACHHANG: { name: "Khách hàng" },
    ADMIN: { name: "Quản trị viên" },
};

const STATUS_OPTIONS = {
    ACTIVE: { name: "Hoạt động" },
    INACTIVE: { name: "Đã khóa" },
};

const UserFilters = ({
    searchTerm,
    setSearchTerm,
    roleFilter,
    setRoleFilter,
    statusFilter,
    setStatusFilter,
    sortBy,
    setSortBy,
    pageSize,
    setPageSize,
    sortOptions,
    totalUsers
}) => {
    return (
        <>
            <Row className="align-items-center">
                <Col md={3}><h5 className="mb-0">Quản lý Người dùng ({totalUsers})</h5></Col>
                <Col md={3}>
                    <InputGroup size="sm">
                        <InputGroup.Text><Search /></InputGroup.Text>
                        <Form.Control
                            placeholder="Tìm theo tên, email, SĐT..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </InputGroup>
                </Col>
                <Col md={2}>
                    <Form.Select size="sm" value={roleFilter} onChange={(e) => setRoleFilter(e.target.value)}>
                        <option value="">Tất cả Vai trò</option>
                        {Object.entries(ROLE_OPTIONS).map(([key, value]) => (
                            <option key={key} value={key}>{value.name}</option>
                        ))}
                    </Form.Select>
                </Col>
                <Col md={2}>
                    <Form.Select size="sm" value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
                        <option value="">Tất cả Trạng thái</option>
                        {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                            <option key={key} value={key}>{value.name}</option>
                        ))}
                    </Form.Select>
                </Col>
                <Col md={2} className="d-flex justify-content-end align-items-center">
                     <Form.Select size="sm" value={sortBy} onChange={(e) => setSortBy(e.target.value)}>
                        {Object.values(sortOptions).map((option) => (
                            <option key={option.key} value={option.key}>{option.name}</option>
                        ))}
                    </Form.Select>
                </Col>
            </Row>
            <Row className="mt-2">
                <Col md={12} className="d-flex justify-content-end">
                    <Form.Select size="sm" value={pageSize} onChange={(e) => setPageSize(Number(e.target.value))} style={{ width: "150px" }}>
                        {[10, 20, 50].map((size) => (
                            <option key={size} value={size}>{size} dòng / trang</option>
                        ))}
                    </Form.Select>
                </Col>
            </Row>
        </>
    );
};

export default UserFilters;
