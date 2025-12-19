// client/src/pages/ProductDetailPage.jsx (Refactored & Updated)
import React from "react";
import { useParams, Link } from "react-router-dom";
import {
  Container,
  Row,
  Col,
  Spinner,
  Alert,
  Tabs,
  Tab,
  Button,
} from "react-bootstrap";
import { useProductDetail } from "../hooks/useProductDetail";
import ProductGallery from "../components/ProductGallery";
import ProductInfo from "../components/ProductInfo";
import ProductReviews from "../components/ProductReviews";
import ProductCard from "../components/ProductCard";
import "./ProductDetailPage.css";

const ProductDetailPage = () => {
  const { slug } = useParams();
  const {
    product,
    loading,
    error,
    relatedProducts,
    vouchers,
    availableAttributes,
    selectedOptions,
    selectedVariant,
    quantity,
    selectedImage,
    currentImageIndex,
    avgRating,
    reviewCount,
    totalSold,
    handleOptionSelect,
    handleQuantityChange,
    setCurrentImageIndex,
    handleAddToCart,
    handleClaimVoucher,
    getAvailableOptionsForAttribute,
  } = useProductDetail(slug);

  if (loading) {
    return (
      <Container
        fluid
        className="py-5 text-center"
        style={{ minHeight: "80vh" }}
      >
        <Spinner animation="border" />
      </Container>
    );
  }

  if (error) {
    return (
      <Container fluid className="py-5 text-center">
        <Alert variant="danger">{error}</Alert>
        <Button as={Link} to="/">
          Quay về Trang chủ
        </Button>
      </Container>
    );
  }

  if (!product) {
    return null;
  }

  return (
    <Container className="py-5 product-detail-container">
      <Row className="g-5">
        {/* Product Gallery */}
        <Col lg={7} md={6}>
          <ProductGallery
            images={product.HinhAnh}
            selectedImage={selectedImage}
            onThumbnailClick={setCurrentImageIndex}
            onPrev={() =>
              setCurrentImageIndex(
                (prev) =>
                  (prev - 1 + product.HinhAnh.length) % product.HinhAnh.length
              )
            }
            onNext={() =>
              setCurrentImageIndex(
                (prev) => (prev + 1) % product.HinhAnh.length
              )
            }
          />
        </Col>

        {/* Product Info */}
        <Col lg={5} md={6} className="product-info-col">
          <ProductInfo
            product={product}
            categoryId={product.DanhMucID}
            selectedVariant={selectedVariant}
            avgRating={avgRating}
            reviewCount={reviewCount}
            totalSold={totalSold}
            availableAttributes={availableAttributes}
            selectedOptions={selectedOptions}
            onOptionSelect={handleOptionSelect}
            getAvailableOptionsForAttribute={getAvailableOptionsForAttribute}
            quantity={quantity}
            onQuantityChange={handleQuantityChange}
            onAddToCart={handleAddToCart}
            vouchers={vouchers}
            onClaimVoucher={handleClaimVoucher}
          />
        </Col>
      </Row>

      {/* Description and Reviews Tabs */}
      <Row className="mt-5">
        <Col>
          <div className="product-tabs-premium">
            <Tabs
              defaultActiveKey="description"
              id="product-tabs"
              className="mb-3 justify-content-center"
              justify
            >
              <Tab eventKey="description" title="MÔ TẢ CHI TIẾT">
                <div
                  className="product-description-content"
                  dangerouslySetInnerHTML={{ __html: product.MoTa }}
                />
              </Tab>
              <Tab eventKey="reviews" title={`ĐÁNH GIÁ (${reviewCount})`}>
                <ProductReviews reviews={product.DanhGia} />
              </Tab>
            </Tabs>
          </div>
        </Col>
      </Row>

      {/* Related Products */}
      <Row className="mt-5">
        <Col>
          <h2 className="related-products-title">CÓ THỂ BẠN SẼ THÍCH</h2>
          <Row className="g-4">
            {relatedProducts
              .filter((p) => p.SanPhamID !== product.SanPhamID)
              .slice(0, 4)
              .map((p) => (
                <Col key={p.SanPhamID} sm={6} md={4} lg={3}>
                  <ProductCard product={p} />
                </Col>
              ))}
          </Row>
        </Col>
      </Row>
    </Container>
  );
};

export default ProductDetailPage;
