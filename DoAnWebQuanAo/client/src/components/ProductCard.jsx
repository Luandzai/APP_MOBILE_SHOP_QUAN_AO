// client/src/components/ProductCard.jsx - REDESIGNED v3

import React, { useContext } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Heart, HeartFill, Cart } from "react-bootstrap-icons";

// Context
import AuthContext from "../context/AuthContext";
import WishlistContext from "../context/WishlistContext";
import CartContext from "../context/CartContext";

// CSS
import "./ProductCard.css";

const ProductCard = ({ product }) => {
  const { user } = useContext(AuthContext);
  const { addWishlist, removeWishlist, isFavorited } = useContext(WishlistContext);
  const { addToCart } = useContext(CartContext);
  const navigate = useNavigate();

  const favorited = isFavorited(product.SanPhamID);

  // Format price to VND
  const formatPrice = (price) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(price);
  };

  // Price calculation
  const giaBanNum = parseFloat(product.GiaBan);
  const giaGocNum = parseFloat(product.GiaGoc);
  const displayPrice = giaBanNum > 0 ? giaBanNum : giaGocNum;
  const showOldPrice = giaBanNum > 0 && giaBanNum < giaGocNum;
  
  let discountPercent = 0;
  if (showOldPrice) {
    discountPercent = Math.round(((giaGocNum - giaBanNum) / giaGocNum) * 100);
  }

  // Handlers
  const handleWishlistClick = (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (!user) {
      navigate("/auth");
      return;
    }
    if (favorited) {
      removeWishlist(product.SanPhamID);
    } else {
      addWishlist(product.SanPhamID);
    }
  };

  const handleAddToCart = (e) => {
    e.preventDefault();
    e.stopPropagation();
    if (!user) {
      navigate("/auth");
      return;
    }
    // Navigate to product detail to select variant
    navigate(`/product/${product.Slug}`);
  };

  return (
    <article className="product-card">
      {/* Image Section */}
      <Link to={`/product/${product.Slug}`} className="product-card__image-wrapper">
        {/* Badges */}
        <div className="product-card__badges">
          {showOldPrice && discountPercent > 0 && (
            <span className="product-card__badge product-card__badge--discount">
              -{discountPercent}%
            </span>
          )}
          {product.IsNew == 1 && (
            <span className="product-card__badge product-card__badge--new">
              New
            </span>
          )}
          {product.HasVoucher == 1 && (
            <span className="product-card__badge product-card__badge--voucher">
              Voucher
            </span>
          )}
        </div>

        {/* Wishlist Button */}
        <button
          className={`product-card__wishlist ${favorited ? 'product-card__wishlist--active' : ''}`}
          onClick={handleWishlistClick}
          aria-label={favorited ? "Remove from wishlist" : "Add to wishlist"}
        >
          {favorited ? <HeartFill /> : <Heart />}
        </button>

        {/* Product Image */}
        <img
          src={product.HinhAnhChinh || "https://placehold.co/500x500?text=No+Image"}
          alt={product.TenSanPham}
          className="product-card__image"
          loading="lazy"
        />
      </Link>

      {/* Content Section */}
      <div className="product-card__content">
        <Link to={`/product/${product.Slug}`} className="product-card__title">
          {product.TenSanPham}
        </Link>

        {/* Price Section */}
        <div className="product-card__price-section">
          <div className="product-card__price-row">
            <span className="product-card__price-current">
              {formatPrice(displayPrice)}
            </span>
            <button
              className="product-card__cart-btn"
              onClick={handleAddToCart}
              aria-label="Add to cart"
            >
              <Cart />
            </button>
          </div>
          
          {/* Old Price - Always render for consistent height */}
          <div className={`product-card__price-old ${!showOldPrice ? 'invisible' : ''}`}>
            {showOldPrice ? formatPrice(giaGocNum) : '\u00A0'}
          </div>
        </div>
      </div>
    </article>
  );
};

export default ProductCard;
