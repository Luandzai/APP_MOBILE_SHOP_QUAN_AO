// client/src/pages/CheckoutPage.jsx (Refactored)
import React, { useContext } from "react";
import { Container, Row, Col, Button, Alert, Spinner } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import CartContext from "../context/CartContext";
import OrderSuccessModal from "../components/OrderSuccessModal";
import { useCheckout } from "../hooks/useCheckout";
import OrderSummary from "../components/OrderSummary";
import ShippingForm from "../components/ShippingForm";
import PaymentOptions from "../components/PaymentOptions";

import "./CheckoutPage.css";

const CheckoutPage = () => {
  const navigate = useNavigate();
  const { checkoutItems } = useContext(CartContext);
  const {
    // Data & State
    shippingInfo,
    provinces,
    districts,
    wards,
    selectedProvinceId,
    selectedDistrictId,
    selectedWardCode,
    shippingOptions,
    selectedShipping,
    paymentMethod,
    notes,
    myVouchers,
    myVouchersLoading,
    selectedVoucherCode,
    discountAmount,
    voucherError,
    error,
    loading,
    cartLoading,
    showSuccessModal,
    subtotal,
    shippingFee,
    total,

    // Setters & Handlers
    handleInputChange,
    setSelectedProvinceId,
    setSelectedDistrictId,
    handleWardChange,
    setSelectedShipping,
    setPaymentMethod,
    setNotes,
    setSelectedVoucherCode,
    placeOrderHandler,
    setShowSuccessModal,
  } = useCheckout();

  if (cartLoading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  return (
    <Container fluid className="py-5">
      <Row>
        <Col md={5}>
          <OrderSummary
            items={checkoutItems}
            subtotal={subtotal}
            shippingFee={shippingFee}
            discountAmount={discountAmount}
            total={total}
            vouchers={myVouchers}
            vouchersLoading={myVouchersLoading}
            selectedVoucherCode={selectedVoucherCode}
            onVoucherChange={setSelectedVoucherCode}
            voucherError={voucherError}
          />
        </Col>

        <Col md={7}>
          {error && <Alert variant="danger">{error}</Alert>}

          <ShippingForm
            shippingInfo={shippingInfo}
            provinces={provinces}
            districts={districts}
            wards={wards}
            selectedProvinceId={selectedProvinceId}
            selectedDistrictId={selectedDistrictId}
            selectedWardCode={selectedWardCode}
            onInputChange={handleInputChange}
            onProvinceChange={setSelectedProvinceId}
            onDistrictChange={setSelectedDistrictId}
            onWardChange={handleWardChange}
            notes={notes}
            onNotesChange={setNotes}
          />

          <PaymentOptions
            shippingOptions={shippingOptions}
            selectedShipping={selectedShipping}
            onShippingChange={setSelectedShipping}
            paymentMethod={paymentMethod}
            onPaymentChange={setPaymentMethod}
          />

          <div className="d-flex justify-content-between align-items-center">
            <Button variant="link" onClick={() => navigate("/cart")}>
              Quay lại giỏ hàng
            </Button>
            <Button
              variant="primary"
              size="lg"
              onClick={placeOrderHandler}
              disabled={loading || checkoutItems.length === 0}
            >
              {loading ? (
                <Spinner as="span" animation="border" size="sm" />
              ) : (
                "Hoàn tất Đặt hàng"
              )}
            </Button>
          </div>
        </Col>
      </Row>

      <OrderSuccessModal
        show={showSuccessModal}
        onHide={() => setShowSuccessModal(false)}
      />
    </Container>
  );
};

export default CheckoutPage;
