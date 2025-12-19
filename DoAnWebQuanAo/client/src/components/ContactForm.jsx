// client/src/components/ContactForm.jsx
import React from 'react';
import { Form, Button, Spinner } from 'react-bootstrap';

const ContactForm = ({ formData, onChange, onSubmit, loading }) => {
    const { name, email, phone, message } = formData;

    return (
        <Form onSubmit={onSubmit}>
            <Form.Group className="mb-3" controlId="contactName">
                <Form.Label>Họ và Tên</Form.Label>
                <Form.Control
                    type="text"
                    placeholder="Nhập họ và tên của bạn"
                    name="name"
                    value={name}
                    onChange={onChange}
                    required
                />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactEmail">
                <Form.Label>Email</Form.Label>
                <Form.Control
                    type="email"
                    placeholder="Nhập địa chỉ email"
                    name="email"
                    value={email}
                    onChange={onChange}
                    required
                />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactPhone">
                <Form.Label>Số điện thoại (Không bắt buộc)</Form.Label>
                <Form.Control
                    type="tel"
                    placeholder="Nhập số điện thoại"
                    name="phone"
                    value={phone}
                    onChange={onChange}
                />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactMessage">
                <Form.Label>Nội dung</Form.Label>
                <Form.Control
                    as="textarea"
                    rows={5}
                    placeholder="Nội dung bạn muốn gửi..."
                    name="message"
                    value={message}
                    onChange={onChange}
                    required
                />
            </Form.Group>
            <div className="d-grid">
                <Button variant="dark" type="submit" disabled={loading}>
                    {loading ? (
                        <>
                            <Spinner as="span" animation="border" size="sm" role="status" aria-hidden="true" />
                            {' '}Đang gửi...
                        </>
                    ) : (
                        "Gửi Tin Nhắn"
                    )}
                </Button>
            </div>
        </Form>
    );
};

export default ContactForm;
