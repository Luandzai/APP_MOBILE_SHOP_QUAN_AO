// client/src/components/CategoryProductSlider.jsx (File MỚI)

import React, { useState, useEffect, useContext } from "react";
import { Row, Col, Spinner, Alert } from "react-bootstrap";
import { Link } from "react-router-dom";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation } from "swiper/modules";

// Import Swiper CSS
import "swiper/css";
import "swiper/css/navigation";

import AuthContext from "../context/AuthContext";
import ProductCard from "./ProductCard";
import "./CategoryProductSlider.css"; // CSS mới

// Component này nhận vào 1 danh mục (con)
const CategoryProductSlider = ({ category }) => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    // Tự động tải sản phẩm khi component được render
    const fetchProducts = async () => {
      if (!category || !category.Slug) return;

      setLoading(true);
      setError(null);
      try {
        // Gọi API /products?danhMuc=...&limit=10 (Back-end tự giới hạn 15)
        const { data } = await api.get(
          `/products?danhMuc=${category.Slug}&limit=10`
        );
        setProducts(data.products || []);
      } catch (err) {
        setError("Không thể tải sản phẩm cho danh mục này.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [api, category]); // Chạy lại nếu 'category' thay đổi

  if (error) {
    return <Alert variant="danger">{error}</Alert>;
  }

  // Không hiển thị gì nếu đang tải hoặc không có sản phẩm
  if (loading || products.length === 0) {
    return null;
  }

  return (
    <div className="category-slider-section my-5">
      {/* 1. Header (Giống trong ảnh) */}
      <div className="category-slider-header">
        <h2 className="mb-0">{category.TenDanhMuc.toUpperCase()}</h2>
        <Link
          to={`/products?category=${category.Slug}`}
          className="btn-view-all"
        >
          Xem tất cả »
        </Link>
      </div>

      {/* 2. Slider (Dùng Swiper) */}
      <Swiper
        modules={[Navigation]}
        spaceBetween={15} // Khoảng cách giữa các slide
        slidesPerView={4} // Hiển thị 4 sản phẩm
        navigation // Bật nút Next/Prev
        className="product-swiper-container"
        // Tùy chỉnh responsive
        breakpoints={{
          320: { slidesPerView: 2, spaceBetween: 10 },
          768: { slidesPerView: 3, spaceBetween: 15 },
          992: { slidesPerView: 4, spaceBetween: 15 },
        }}
      >
        {products.map((product) => (
          <SwiperSlide key={product.SanPhamID}>
            <ProductCard product={product} />
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  );
};

export default CategoryProductSlider;
