// client/src/components/ReturnFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup } from 'react-bootstrap';
import { Search } from 'react-bootstrap-icons';

const STATUS_OPTIONS = {
    PENDING: { name: "Chờ xử lý" },
    APPROVED: { name: "Đã phê duyệt" },
    REJECTED: { name: "Đã từ chối" },
    COMPLETED: { name: "Đã hoàn tất" },
};

const ReturnFilters = ({
    searchTerm,
    setSearchTerm,
    statusFilter,
    setStatusFilter,
    totalReturns
}) => {
    return (
        <Row className="align-items-center">
            <Col md={4}>
                <h5 className="mb-0">Yêu cầu Đổi/Trả ({totalReturns})</h5>
            </Col>

            <Col md={4}>
                <InputGroup size="sm">
                    <InputGroup.Text><Search /></InputGroup.Text>
                    <Form.Control
                        placeholder="Tìm theo Mã ĐH, Email..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </InputGroup>
            </Col>

            <Col md={4}>
                <Form.Select
                    size="sm"
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                >
                    <option value="">Tất cả trạng thái</option>
                    {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                        <option key={key} value={key}>
                            {value.name}
                        </option>
                    ))}
                </Form.Select>
            </Col>
        </Row>
    );
};

export default ReturnFilters;
