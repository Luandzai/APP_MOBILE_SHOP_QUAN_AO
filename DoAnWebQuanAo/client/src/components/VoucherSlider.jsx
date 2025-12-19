// client/src/components/VoucherSlider.jsx - REDESIGNED v3

import React from "react";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation, Pagination } from "swiper/modules";
import { ChevronLeft, ChevronRight, Ticket, Clock } from "react-bootstrap-icons";

import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";
import "./VoucherSlider.css";

const VoucherSlider = ({
  vouchers,
  onVoucherClick,
  appliedVoucher,
  onClaimVoucher,
}) => {
  if (!vouchers || vouchers.length === 0) {
    return null;
  }

  const handleClaimClick = (e, maKhuyenMai) => {
    e.stopPropagation();
    if (onClaimVoucher) {
      onClaimVoucher(maKhuyenMai);
    }
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString("vi-VN");
  };

  return (
    <div className="voucher-slider">
      {/* Header */}
      <div className="voucher-slider__header">
        <Ticket size={16} />
        <span>Mã khuyến mãi</span>
        {vouchers.length > 1 && (
          <span className="voucher-slider__count">{vouchers.length}</span>
        )}
      </div>

      {/* Swiper Container */}
      <Swiper
        modules={[Navigation, Pagination]}
        spaceBetween={8}
        slidesPerView={1}
        navigation={{
          prevEl: '.voucher-nav-prev',
          nextEl: '.voucher-nav-next',
        }}
        pagination={{ clickable: true }}
        className="voucher-slider__swiper"
      >
        {vouchers.map((voucher) => {
          const isApplied = appliedVoucher?.MaKhuyenMai === voucher.MaKhuyenMai;
          
          return (
            <SwiperSlide key={voucher.MaKhuyenMai}>
              <div
                className={`voucher-card ${isApplied ? 'voucher-card--applied' : ''}`}
                onClick={onVoucherClick}
              >
                {/* Left: Icon Badge */}
                <div className="voucher-card__badge">
                  <span className="voucher-card__icon">🎁</span>
                </div>

                {/* Middle: Details */}
                <div className="voucher-card__content">
                  <div className="voucher-card__code">{voucher.MaKhuyenMai}</div>
                  <div className="voucher-card__name">{voucher.TenKhuyenMai}</div>
                  <div className="voucher-card__expiry">
                    <Clock size={10} />
                    <span>HSD: {formatDate(voucher.NgayKetThuc)}</span>
                  </div>
                </div>

                {/* Right: Action */}
                <button
                  className={`voucher-card__btn ${isApplied ? 'voucher-card__btn--applied' : ''}`}
                  onClick={(e) => handleClaimClick(e, voucher.MaKhuyenMai)}
                  disabled={isApplied}
                >
                  {isApplied ? '✓' : 'Lưu'}
                </button>
              </div>
            </SwiperSlide>
          );
        })}
      </Swiper>

      {/* Custom Navigation */}
      {vouchers.length > 1 && (
        <>
          <button className="voucher-nav voucher-nav-prev">
            <ChevronLeft size={14} />
          </button>
          <button className="voucher-nav voucher-nav-next">
            <ChevronRight size={14} />
          </button>
        </>
      )}
    </div>
  );
};

export default VoucherSlider;
