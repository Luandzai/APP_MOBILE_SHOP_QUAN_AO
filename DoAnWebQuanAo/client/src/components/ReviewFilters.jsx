// client/src/components/ReviewFilters.jsx
import React from 'react';
import { Row, Col, Form, InputGroup } from 'react-bootstrap';
import { Search } from 'react-bootstrap-icons';

const ReviewFilters = ({
    searchTerm,
    setSearchTerm,
    ratingFilter,
    setRatingFilter,
    totalReviews
}) => {
    return (
        <Row className="align-items-center">
            <Col md={5}>
                <InputGroup size="sm">
                    <InputGroup.Text><Search /></InputGroup.Text>
                    <Form.Control
                        placeholder="Tìm theo Tên SP, User, Email, Bình luận..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </InputGroup>
            </Col>
            <Col md={3}>
                <Form.Select
                    size="sm"
                    value={ratingFilter}
                    onChange={(e) => setRatingFilter(e.target.value)}
                >
                    <option value="">Tất cả Điểm số</option>
                    {[5, 4, 3, 2, 1].map(star => (
                        <option key={star} value={star}>{star} Sao</option>
                    ))}
                </Form.Select>
            </Col>
            <Col md={4} className="text-end">
                <span className="text-muted small">
                    Tổng số: {totalReviews}
                </span>
            </Col>
        </Row>
    );
};

export default ReviewFilters;
