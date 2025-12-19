// client/src/components/ProductInfo.jsx (Updated)
import React, { useState, useContext } from "react";
import { Button, Badge, ButtonGroup, InputGroup, Form } from "react-bootstrap";
import { Heart, HeartFill } from "react-bootstrap-icons";
import StarRating from "./StarRating";
import VoucherSlider from "./VoucherSlider";
import SizeGuideModal from "./SizeGuideModal";
import WishlistContext from "../context/WishlistContext";

const ProductInfo = ({
  product,
  categoryId,
  selectedVariant,
  avgRating,
  reviewCount,
  totalSold,
  availableAttributes,
  selectedOptions,
  onOptionSelect,
  getAvailableOptionsForAttribute,
  quantity,
  onQuantityChange,
  onAddToCart,
  vouchers,
  onClaimVoucher,
}) => {
  const [showSizeModal, setShowSizeModal] = useState(false);
  const { wishlist, addWishlist, removeWishlist, isFavorited } =
    useContext(WishlistContext);

  // Check if product is in wishlist
  const isInWishlist = isFavorited(product.SanPhamID);

  // Handle wishlist toggle
  const handleWishlistToggle = () => {
    if (isInWishlist) {
      removeWishlist(product.SanPhamID);
    } else {
      addWishlist(product.SanPhamID);
    }
  };

  const formatCurrency = (amount) =>
    new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount || 0);

  const renderPrice = () => {
    if (!selectedVariant) {
      return (
        <span
          className="product-price-new text-muted"
          style={{ fontSize: "1.5rem" }}
        >
          Vui lòng chọn thuộc tính
        </span>
      );
    }
    const hasDiscount =
      parseFloat(selectedVariant.GiaBan) < parseFloat(product.GiaGoc);
    return (
      <div className="product-price-wrapper">
        <span className="product-price-new">
          {formatCurrency(selectedVariant.GiaBan)}
        </span>
        {hasDiscount && (
          <>
            <span className="product-price-old">
              {formatCurrency(product.GiaGoc)}
            </span>
            <span className="discount-badge">
              -
              {Math.round(
                ((product.GiaGoc - selectedVariant.GiaBan) / product.GiaGoc) *
                  100
              )}
              %
            </span>
          </>
        )}
      </div>
    );
  };

  return (
    <>
      <h1 className="product-detail-title">{product.TenSanPham}</h1>

      <div className="product-meta-row">
        <div className="product-rating-wrapper">
          <StarRating value={avgRating} />
          <span>({reviewCount} đánh giá)</span>
        </div>
        <div className="vr"></div>
        <span>Đã bán {totalSold}</span>
        <div className="vr"></div>
        <span>
          Tồn kho:
          {selectedVariant ? (
            <span className="text-success fw-bold ms-1">
              {selectedVariant.SoLuongTonKho}
            </span>
          ) : (
            <span className="text-danger fw-bold ms-1">--</span>
          )}
        </span>
      </div>

      {renderPrice()}

      {/* Vouchers */}
      <div className="mb-4">
        <VoucherSlider vouchers={vouchers} onClaimVoucher={onClaimVoucher} />
      </div>

      {/* Options */}
      {availableAttributes.map((attr) => (
        <div className="product-option-group" key={attr.name}>
          <div className="d-flex justify-content-between align-items-center">
            <span className="product-option-label">
              {attr.name}:{" "}
              <span className="text-dark">
                {selectedOptions[attr.name] || <span className="text-muted">Chọn {attr.name.toLowerCase()}</span>}
              </span>
            </span>
            {/* Chỉ hiện link nếu thuộc tính là Kích cỡ/Size */}
            {(attr.name.toLowerCase().includes("size") ||
              attr.name.includes("Kích")) && (
              <span
                className="size-guide-link"
                onClick={() => setShowSizeModal(true)}
              >
                Bảng quy đổi kích cỡ
              </span>
            )}
          </div>

          <div className="option-chips-wrapper">
            {attr.values.map((value) => {
              const availability = getAvailableOptionsForAttribute
                ? getAvailableOptionsForAttribute(attr.name)[value] || {}
                : {};
              const isSelected = selectedOptions[attr.name] === value;
              // "Disabled" = variant doesn't exist for current selection - BLOCK click
              const isDisabled = availability.disabled;
              // "Out of stock" = variant exists but no stock - BLOCK click
              const isOutOfStock = availability.outOfStock;
              // Block click if disabled or out of stock
              const isBlocked = isDisabled || isOutOfStock;

              return (
                <div
                  key={value}
                  className={`option-chip ${isSelected ? "active" : ""} ${isDisabled ? "disabled" : ""} ${isOutOfStock ? "out-of-stock" : ""}`}
                  onClick={() => !isBlocked && onOptionSelect(attr.name, value)}
                  title={isOutOfStock ? "Hết hàng" : isDisabled ? "Không khả dụng" : ""}
                >
                  {value}
                  {isOutOfStock && <span className="stock-badge">Hết</span>}
                </div>
              );
            })}
          </div>
        </div>
      ))}

      {/* Quantity & Add to Cart */}
      <div className="action-row">
        <div className="quantity-selector-v2">
          <button
            className="qty-btn"
            onClick={() => onQuantityChange(-1)}
            disabled={!selectedVariant || quantity <= 1}
          >
            -
          </button>
          <input type="text" className="qty-input" value={quantity} readOnly />
          <button
            className="qty-btn"
            onClick={() => onQuantityChange(1)}
            disabled={
              !selectedVariant || quantity >= selectedVariant.SoLuongTonKho
            }
          >
            +
          </button>
        </div>

        <button
          className="btn-add-cart-premium"
          disabled={!selectedVariant || selectedVariant.SoLuongTonKho === 0}
          onClick={onAddToCart}
        >
          {selectedVariant && selectedVariant.SoLuongTonKho > 0
            ? "Thêm vào giỏ hàng"
            : "Hết hàng"}
        </button>

        {/* Wishlist Button */}
        <button
          className="btn-wishlist-premium"
          onClick={handleWishlistToggle}
          title={isInWishlist ? "Xóa khỏi yêu thích" : "Thêm vào yêu thích"}
        >
          {isInWishlist ? (
            <HeartFill size={24} className="text-danger" />
          ) : (
            <Heart size={24} />
          )}
        </button>
      </div>

      {/* Truyền categoryId vào Modal */}
      <SizeGuideModal
        show={showSizeModal}
        onHide={() => setShowSizeModal(false)}
        categoryId={categoryId}
      />
    </>
  );
};

export default ProductInfo;
