// client/src/pages/HomePage.jsx (Redesigned)
import React from "react";
import { Container, Row, Col, Spinner, Alert } from "react-bootstrap";
import { useHomePageData } from '../hooks/useHomePageData';

// Import UI components
import HeroCarousel from "../components/HeroCarousel";
import PromoBanners from "../components/PromoBanners";
import ProductCard from "../components/ProductCard";
import CategoryProductSlider from "../components/CategoryProductSlider";

import "./HomePage.css";

// Helper component to render product grids with styled section
const ProductSection = ({ title, items }) => (
    <section className="product-section">
        <Container>
            <div className="section-title">
                <h2>{title}</h2>
            </div>
            {items && items.length > 0 ? (
                <Row>
                    {items.map((product) => (
                        <Col key={product.SanPhamID} xs={6} sm={6} md={4} lg={3} className="mb-4">
                            <ProductCard product={product} />
                        </Col>
                    ))}
                </Row>
            ) : (
                <p className="text-center text-muted">Không có sản phẩm nào để hiển thị.</p>
            )}
        </Container>
    </section>
);

const HomePage = () => {
    const {
        bestSellingProducts,
        newestProducts,
        categories,
        loading,
        error
    } = useHomePageData();

    return (
        <>
            <HeroCarousel />
            
            {loading ? (
                <Container className="py-5">
                    <div className="text-center" style={{ minHeight: '50vh' }}>
                        <Spinner animation="border" />
                    </div>
                </Container>
            ) : error ? (
                <Container className="py-5">
                    <Alert variant="danger">{error}</Alert>
                </Container>
            ) : (
                <>
                    <ProductSection title="SẢN PHẨM BÁN CHẠY 🔥" items={bestSellingProducts} />
                    <ProductSection title="SẢN PHẨM MỚI NHẤT ⚡" items={newestProducts} />
                    
                    <Container>
                        {categories.map((category) => (
                            <CategoryProductSlider key={category.DanhMucID} category={category} />
                        ))}
                    </Container>

                    <Container>
                        <PromoBanners />
                    </Container>
                </>
            )}
        </>
    );
};

export default HomePage;

