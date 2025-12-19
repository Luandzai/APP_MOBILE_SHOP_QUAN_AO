// client/src/pages/ContactPage.jsx (Refactored)
import React from "react";
import { Container, Row, Col, Alert } from "react-bootstrap";
import { useContactForm } from "../hooks/useContactForm";
import ContactForm from "../components/ContactForm";

const ContactPage = () => {
    const { formData, loading, error, success, onChange, onSubmit } = useContactForm();

    return (
        <Container className="py-5">
            <Row className="justify-content-center">
                <Col md={8} lg={6}>
                    <h1 className="text-center mb-4">Liên Hệ Với Chúng Tôi</h1>
                    <p className="text-center text-muted mb-4">
                        Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào, đừng ngần ngại gửi cho
                        chúng tôi. Chúng tôi luôn sẵn lòng lắng nghe!
                    </p>
                    {error && <Alert variant="danger">{error}</Alert>}
                    {success && <Alert variant="success">{success}</Alert>}
                    
                    <ContactForm
                        formData={formData}
                        onChange={onChange}
                        onSubmit={onSubmit}
                        loading={loading}
                    />
                </Col>
            </Row>
        </Container>
    );
};

export default ContactPage;
