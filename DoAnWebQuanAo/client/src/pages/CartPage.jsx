// client/src/pages/CartPage.jsx - REDESIGNED v3

import React, { useContext, useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Form, Spinner } from "react-bootstrap";
import { X, Trash, Cart, ArrowLeft, ShieldCheck } from "react-bootstrap-icons";
import CartContext from "../context/CartContext";
import "./CartPage.css";

const CartPage = () => {
  const {
    cartItems,
    updateCartQuantity,
    removeFromCart,
    loading,
    selectItemsForCheckout,
  } = useContext(CartContext);
  const navigate = useNavigate();

  const [selectedItems, setSelectedItems] = useState([]);

  // Auto-select all items on load
  useEffect(() => {
    setSelectedItems(cartItems.map((item) => item.PhienBanID));
  }, [cartItems]);

  const itemsToCheckout = cartItems.filter((item) =>
    selectedItems.includes(item.PhienBanID)
  );

  const subtotal = itemsToCheckout.reduce(
    (acc, item) => acc + item.SoLuong * parseFloat(item.GiaBan),
    0
  );

  const handleQuantityChange = (item, newQty) => {
    if (newQty > 0) {
      updateCartQuantity(item.PhienBanID, newQty);
    } else if (newQty === 0) {
      removeFromCart(item.PhienBanID);
    }
  };

  const handleSelectItem = (phienBanID) => {
    setSelectedItems((prev) =>
      prev.includes(phienBanID)
        ? prev.filter((id) => id !== phienBanID)
        : [...prev, phienBanID]
    );
  };

  const handleSelectAll = (e) => {
    if (e.target.checked) {
      setSelectedItems(cartItems.map((item) => item.PhienBanID));
    } else {
      setSelectedItems([]);
    }
  };

  const handleCheckout = () => {
    selectItemsForCheckout(itemsToCheckout);
    navigate("/checkout");
  };

  if (loading) {
    return (
      <div className="cart-page cart-page--loading">
        <Spinner animation="border" />
        <span>Đang tải giỏ hàng...</span>
      </div>
    );
  }

  // Empty Cart State
  if (cartItems.length === 0) {
    return (
      <div className="cart-page">
        <div className="cart-empty">
          <div className="cart-empty__icon">
            <Cart size={64} />
          </div>
          <h2 className="cart-empty__title">Giỏ hàng trống</h2>
          <p className="cart-empty__text">
            Bạn chưa có sản phẩm nào trong giỏ hàng.
          </p>
          <Link to="/products" className="cart-empty__btn">
            <ArrowLeft size={18} />
            Tiếp tục mua sắm
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="cart-page">
      {/* Header */}
      <div className="cart-header">
        <h1 className="cart-header__title">Giỏ hàng</h1>
        <span className="cart-header__count">{cartItems.length} sản phẩm</span>
      </div>

      <div className="cart-container">
        {/* Items Column */}
        <div className="cart-items">
          {/* Select All */}
          <div className="cart-select-all">
            <Form.Check
              type="checkbox"
              id="select-all"
              label={`Chọn tất cả (${cartItems.length})`}
              checked={selectedItems.length === cartItems.length}
              onChange={handleSelectAll}
            />
          </div>

          {/* Cart Items */}
          {cartItems.map((item) => (
            <div 
              key={item.PhienBanID} 
              className={`cart-item ${selectedItems.includes(item.PhienBanID) ? 'cart-item--selected' : ''}`}
            >
              {/* Checkbox */}
              <div className="cart-item__checkbox">
                <Form.Check
                  type="checkbox"
                  checked={selectedItems.includes(item.PhienBanID)}
                  onChange={() => handleSelectItem(item.PhienBanID)}
                />
              </div>

              {/* Image */}
              <Link to={`/product/${item.Slug}`} className="cart-item__image">
                <img src={item.HinhAnh} alt={item.TenSanPham} />
              </Link>

              {/* Details */}
              <div className="cart-item__details">
                <Link to={`/product/${item.Slug}`} className="cart-item__name">
                  {item.TenSanPham}
                </Link>
                <div className="cart-item__variant">{item.ThuocTinh}</div>
                <div className="cart-item__price-mobile">
                  {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
                </div>
              </div>

              {/* Price (Desktop) */}
              <div className="cart-item__price">
                {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
              </div>

              {/* Quantity */}
              <div className="cart-item__quantity">
                <button
                  className="qty-btn"
                  onClick={() => handleQuantityChange(item, item.SoLuong - 1)}
                >
                  −
                </button>
                <span className="qty-value">{item.SoLuong}</span>
                <button
                  className="qty-btn"
                  onClick={() => handleQuantityChange(item, item.SoLuong + 1)}
                >
                  +
                </button>
              </div>

              {/* Subtotal (Desktop) */}
              <div className="cart-item__subtotal">
                {(item.SoLuong * parseFloat(item.GiaBan)).toLocaleString("vi-VN")} ₫
              </div>

              {/* Delete */}
              <button
                className="cart-item__delete"
                onClick={() => removeFromCart(item.PhienBanID)}
                title="Xóa sản phẩm"
              >
                <Trash size={18} />
              </button>
            </div>
          ))}
        </div>

        {/* Summary Column */}
        <div className="cart-summary">
          <div className="cart-summary__card">
            <h3 className="cart-summary__title">Tóm tắt đơn hàng</h3>
            
            <div className="cart-summary__row">
              <span>Sản phẩm đã chọn</span>
              <span>{itemsToCheckout.length} sản phẩm</span>
            </div>
            
            <div className="cart-summary__row">
              <span>Tạm tính</span>
              <span>{subtotal.toLocaleString("vi-VN")} ₫</span>
            </div>
            
            <div className="cart-summary__row cart-summary__row--total">
              <span>Tổng cộng</span>
              <span className="cart-summary__total">
                {subtotal.toLocaleString("vi-VN")} ₫
              </span>
            </div>

            <button
              className="cart-summary__btn"
              disabled={itemsToCheckout.length === 0}
              onClick={handleCheckout}
            >
              Tiến hành đặt hàng
            </button>

            <div className="cart-summary__secure">
              <ShieldCheck size={16} />
              <span>Thanh toán an toàn & bảo mật</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CartPage;
