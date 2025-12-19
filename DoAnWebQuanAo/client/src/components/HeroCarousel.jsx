// client/src/components/HeroCarousel.jsx
import React from "react";
import { Carousel } from "react-bootstrap";

const HeroCarousel = () => {
  // Style để chữ có bóng, dễ đọc trên mọi nền ảnh
  const captionStyle = {
    textShadow: "0 2px 4px rgba(0,0,0,0.6)",
    color: "#ffffff",
  };

  return (
    <Carousel fade>
      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://images.unsplash.com/photo-1556905055-8f358a7a47b2?fit=crop&w=1920&q=80"
          alt="First slide"
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        {/* Thêm style trực tiếp vào Caption */}
        <Carousel.Caption style={captionStyle}>
          <h3 className="fw-bold">Phụ Kiện Thời Trang</h3>
          <p className="fs-5">Hoàn thiện phong cách của bạn.</p>
        </Carousel.Caption>
      </Carousel.Item>

      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://images.unsplash.com/photo-1483985988355-763728e1935b?fit=crop&w=1920&q=80"
          alt="Second slide"
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        <Carousel.Caption style={captionStyle}>
          <h3 className="fw-bold">Sale Mùa Hè</h3>
          <p className="fs-5">Giảm giá lên đến 50% cho tất cả sản phẩm.</p>
        </Carousel.Caption>
      </Carousel.Item>

      <Carousel.Item>
        <img
          className="d-block w-100"
          src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?fit=crop&w=1920&q=80"
          alt="Third slide"
          style={{ maxHeight: "550px", objectFit: "cover" }}
        />
        <Carousel.Caption style={captionStyle}>
          <h3 className="fw-bold">Hàng Mới Về</h3>
          <p className="fs-5">Khám phá bộ sưu tập Thu-Đông mới nhất.</p>
        </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
};

export default HeroCarousel;
