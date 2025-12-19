// client/src/pages/ReturnRequestPage.jsx (Refactored)
import React from "react";
import { useParams } from "react-router-dom";
import { Container, Row, Col, Spinner, Alert } from "react-bootstrap";
import { useReturnRequest } from "../hooks/useReturnRequest";
import ReturnRequestForm from "../components/ReturnRequestForm";

const ReturnRequestPage = () => {
    const { orderId } = useParams();
    const {
        order,
        loading,
        error,
        reason,
        setReason,
        itemsToReturn,
        handleQuantityChange,
        handleSubmit,
    } = useReturnRequest(orderId);

    if (loading && !order) {
        return (
            <Container className="py-5 text-center">
                <Spinner animation="border" />
            </Container>
        );
    }
    
    // Show a global error if the order couldn't be fetched.
    if (error && !order) {
        return (
            <Container className="py-5">
                <Alert variant="danger">{error}</Alert>
            </Container>
        );
    }

    if (!order) {
        return null; // Don't render anything if order is not loaded
    }

    return (
        <Container fluid className="py-5">
            <Row className="justify-content-center">
                <Col md={8}>
                    <h2 className="mb-4">Yêu cầu Đổi/Trả hàng</h2>
                    <h5>Đơn hàng: ORD_{order.DonHangID}</h5>
                    <p>Chọn sản phẩm và số lượng bạn muốn trả:</p>
                    
                    {error && <Alert variant="danger">{error}</Alert>}
                    
                    <ReturnRequestForm
                        order={order}
                        itemsToReturn={itemsToReturn}
                        reason={reason}
                        onQuantityChange={handleQuantityChange}
                        onReasonChange={setReason}
                        onSubmit={handleSubmit}
                        loading={loading}
                    />
                </Col>
            </Row>
        </Container>
    );
};

export default ReturnRequestPage;
