// client/src/components/PaymentOptions.jsx
import React from "react";
import { Card, Form } from "react-bootstrap";
import { CreditCard2FrontFill, CashCoin, Paypal } from "react-bootstrap-icons";

// Mảng layout cho PT Thanh toán
const paymentCardOptions = [
  {
    id: "701",
    name: "Thanh toán khi nhận hàng (COD)",
    description: "Nhận, kiểm tra rồi thanh toán",
    icon: <CashCoin />,
  },
  {
    id: "702",
    name: "VNPAY",
    description: "Thanh toán qua VNPAY (Thẻ/QR)",
    icon: <CreditCard2FrontFill />,
  },
  {
    id: "703",
    name: "Ví MoMo",
    description: "Thanh toán qua ví điện tử MoMo",
    icon: <Paypal />,
  }
];

const PaymentOptions = ({
  shippingOptions,
  selectedShipping,
  onShippingChange,
  paymentMethod,
  onPaymentChange,
}) => {
  return (
    <>
      <Card className="shadow-sm mb-3">
        <Card.Header as="h5">2. Phương thức vận chuyển</Card.Header>
        <Card.Body>
          {shippingOptions.length > 0 ? (
            shippingOptions.map((method) => (
              <Form.Check
                key={method.PhuongThucID}
                type="radio"
                id={`shipping-${method.PhuongThucID}`}
                label={`${method.TenPhuongThuc} (${parseFloat(
                  method.PhiCoDinh
                ).toLocaleString("vi-VN")} ₫)`}
                value={method.PhuongThucID}
                checked={selectedShipping?.PhuongThucID === method.PhuongThucID}
                onChange={() => onShippingChange(method)}
              />
            ))
          ) : (
            <p>Đang tải các phương thức vận chuyển...</p>
          )}
        </Card.Body>
      </Card>

      <Card className="shadow-sm mb-3">
        <Card.Header as="h5">3. Phương thức thanh toán</Card.Header>
        <Card.Body>
          {paymentCardOptions.map((option) => (
            <div
              key={option.id}
              className={`payment-method-card ${
                paymentMethod === option.id ? "active" : ""
              }`}
              onClick={() => onPaymentChange(option.id)}
            >
              <div className="payment-radio"></div>
              <div className="payment-method-info">
                <strong>{option.name}</strong>
                <small>{option.description}</small>
              </div>
              <div className="payment-method-logos">{option.icon}</div>
            </div>
          ))}
        </Card.Body>
      </Card>
    </>
  );
};

export default PaymentOptions;
