// client/src/components/Header.jsx
import React, { useContext, useState, useEffect } from "react";
import { Link, useNavigate, NavLink, useLocation } from "react-router-dom";
import { Search, Person, Cart, Heart, List, X } from "react-bootstrap-icons";
import "./Header.css";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";
import WishlistContext from "../context/WishlistContext";
import ThemeToggle from "./ThemeToggle";

const CATEGORIES = [
  { name: "TẤT CẢ SẢN PHẨM", category: "tat-ca", path: "/products" },
  { name: "ĐỒ NAM", category: "do-nam" },
  { name: "ĐỒ NỮ", category: "do-nu" },
  { name: "ĐỒ THỂ THAO", category: "do-the-thao" },
  { name: "ĐỒ DA", category: "do-da" },
  { name: "PHỤ KIỆN", category: "phu-kien" },
];

const isCategoryActive = (category, location) => {
  if (location.pathname !== "/products") return false;
  const searchParams = new URLSearchParams(location.search);
  const currentCategory = searchParams.get("danhMuc");
  if (category === "tat-ca") {
    return !currentCategory;
  }
  return currentCategory === category;
};

const Header = () => {
  const { user, logout } = useContext(AuthContext);
  const { cartItems } = useContext(CartContext);
  const { wishlist: wishlistItems } = useContext(WishlistContext);

  const [keyword, setKeyword] = useState("");
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [isUserDropdownOpen, setIsUserDropdownOpen] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  // Đóng sidebar và dropdown khi route thay đổi
  useEffect(() => {
    setIsSidebarOpen(false);
    setIsUserDropdownOpen(false);
  }, [location.pathname]);

  // Prevent scroll khi sidebar mở
  useEffect(() => {
    if (isSidebarOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [isSidebarOpen]);

  // Đóng dropdown khi click ra ngoài
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (isUserDropdownOpen && !e.target.closest('.user-dropdown')) {
        setIsUserDropdownOpen(false);
      }
    };
    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, [isUserDropdownOpen]);

  const searchHandler = (e) => {
    e.preventDefault();
    if (keyword.trim()) {
      navigate(`/products?search=${keyword}`);
      setKeyword("");
    } else {
      navigate("/products");
    }
    setIsSidebarOpen(false);
  };

  const handleCategoryClick = (category) => {
    if (category === "tat-ca") {
      navigate("/products");
    } else {
      navigate(`/products?danhMuc=${category}`);
    }
    setIsSidebarOpen(false);
  };

  const handleNavClick = () => {
    setIsSidebarOpen(false);
  };

  const cartItemCount = cartItems?.length || 0;
  const wishlistItemCount = wishlistItems?.length || 0;

  return (
    <>
      {/* MAIN HEADER */}
      <header className="header-main">
        <div className="header-container">
          {/* Logo */}
          <Link to="/" className="header-logo" onClick={handleNavClick}>
            BLANK CANVAS
          </Link>

          {/* Desktop Navigation */}
          <nav className="header-nav-desktop">
            {CATEGORIES.map((item) => (
              <button
                key={item.category}
                onClick={() => handleCategoryClick(item.category)}
                className={`nav-link ${isCategoryActive(item.category, location) ? "active" : ""}`}
              >
                {item.name}
              </button>
            ))}
            <NavLink to="/news" className="nav-link">TIN TỨC</NavLink>
            <NavLink to="/virtual-try-on" className="nav-link">THỬ ĐỒ ẢO</NavLink>
            <NavLink to="/contact" className="nav-link">LIÊN HỆ</NavLink>
          </nav>

          {/* Desktop Actions */}
          <div className="header-actions-desktop">
            <form className="search-form" onSubmit={searchHandler}>
              <input
                type="search"
                placeholder="Tìm kiếm..."
                value={keyword}
                onChange={(e) => setKeyword(e.target.value)}
              />
              <button type="submit"><Search size={16} /></button>
            </form>

            <ThemeToggle />

            {user ? (
              <div className={`user-dropdown ${isUserDropdownOpen ? 'open' : ''}`}>
                <button 
                  className="user-btn" 
                  onClick={(e) => {
                    e.stopPropagation();
                    setIsUserDropdownOpen(!isUserDropdownOpen);
                  }}
                >
                  <Person size={20} />
                  <span>{user.hoTen}</span>
                </button>
                <div className="user-menu">
                  <Link to="/profile" onClick={() => setIsUserDropdownOpen(false)}>
                    Thông tin tài khoản
                  </Link>
                  {user.vaiTro === "ADMIN" && (
                    <Link to="/admin/dashboard" onClick={() => setIsUserDropdownOpen(false)}>
                      Trang Admin
                    </Link>
                  )}
                  <button onClick={() => { logout(); setIsUserDropdownOpen(false); }}>
                    Đăng xuất
                  </button>
                </div>
              </div>
            ) : (
              <Link to="/auth" className="icon-btn"><Person size={20} /></Link>
            )}

            <Link to="/profile/wishlist" className="icon-btn">
              <Heart size={20} />
              {user && wishlistItemCount > 0 && (
                <span className="badge">{wishlistItemCount}</span>
              )}
            </Link>

            {/* Mini Cart Dropdown */}
            <div className="mini-cart">
              <Link to="/cart" className="icon-btn">
                <Cart size={20} />
                {user && cartItemCount > 0 && (
                  <span className="badge">{cartItemCount}</span>
                )}
              </Link>
              {user && cartItems && cartItems.length > 0 && (
                <div className="mini-cart__dropdown">
                  <div className="mini-cart__header">
                    Giỏ hàng ({cartItemCount})
                  </div>
                  <div className="mini-cart__items">
                    {cartItems.slice(0, 3).map((item) => (
                      <div key={item.PhienBanID} className="mini-cart__item">
                        <img src={item.HinhAnh} alt={item.TenSanPham} />
                        <div className="mini-cart__info">
                          <span className="mini-cart__name">{item.TenSanPham}</span>
                          <span className="mini-cart__price">
                            {item.SoLuong} x {parseFloat(item.GiaBan).toLocaleString("vi-VN")} ₫
                          </span>
                        </div>
                      </div>
                    ))}
                    {cartItems.length > 3 && (
                      <div className="mini-cart__more">
                        +{cartItems.length - 3} sản phẩm khác
                      </div>
                    )}
                  </div>
                  <div className="mini-cart__footer">
                    <div className="mini-cart__total">
                      <span>Tổng:</span>
                      <strong>
                        {cartItems.reduce((acc, item) => acc + item.SoLuong * parseFloat(item.GiaBan), 0).toLocaleString("vi-VN")} ₫
                      </strong>
                    </div>
                    <Link to="/cart" className="mini-cart__btn">
                      Xem giỏ hàng
                    </Link>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Mobile Actions (visible on mobile only) */}
          <div className="header-actions-mobile">
            <ThemeToggle />
            <Link to="/profile/wishlist" className="icon-btn">
              <Heart size={20} />
              {user && wishlistItemCount > 0 && (
                <span className="badge">{wishlistItemCount}</span>
              )}
            </Link>
            <Link to="/cart" className="icon-btn">
              <Cart size={20} />
              {user && cartItemCount > 0 && (
                <span className="badge">{cartItemCount}</span>
              )}
            </Link>
            <button className="menu-toggle" onClick={() => setIsSidebarOpen(true)}>
              <List size={24} />
            </button>
          </div>
        </div>
      </header>

      {/* MOBILE SIDEBAR */}
      <div className={`sidebar-overlay ${isSidebarOpen ? "active" : ""}`} onClick={() => setIsSidebarOpen(false)} />
      
      <aside className={`sidebar ${isSidebarOpen ? "open" : ""}`}>
        {/* Sidebar Header */}
        <div className="sidebar-header">
          <span className="sidebar-title">Menu</span>
          <button className="close-btn" onClick={() => setIsSidebarOpen(false)}>
            <X size={24} />
          </button>
        </div>

        {/* Sidebar Search */}
        <form className="sidebar-search" onSubmit={searchHandler}>
          <input
            type="search"
            placeholder="Tìm kiếm sản phẩm..."
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
          />
          <button type="submit"><Search size={18} /></button>
        </form>

        {/* Sidebar Navigation */}
        <nav className="sidebar-nav">
          {CATEGORIES.map((item, index) => (
            <button
              key={item.category}
              onClick={() => handleCategoryClick(item.category)}
              className={`sidebar-link ${isCategoryActive(item.category, location) ? "active" : ""}`}
              style={{ animationDelay: `${index * 0.03}s` }}
            >
              {item.name}
            </button>
          ))}
          <NavLink to="/news" className="sidebar-link" style={{ animationDelay: "0.18s" }} onClick={handleNavClick}>
            TIN TỨC
          </NavLink>
          <NavLink to="/virtual-try-on" className="sidebar-link" style={{ animationDelay: "0.21s" }} onClick={handleNavClick}>
            THỬ ĐỒ ẢO
          </NavLink>
          <NavLink to="/contact" className="sidebar-link" style={{ animationDelay: "0.24s" }} onClick={handleNavClick}>
            LIÊN HỆ
          </NavLink>
        </nav>

        {/* Sidebar Footer - User Info */}
        <div className="sidebar-footer">
          {user ? (
            <div className="sidebar-user">
              <div className="user-info">
                <Person size={20} />
                <span>{user.hoTen}</span>
              </div>
              <div className="user-actions">
                <Link to="/profile" onClick={handleNavClick}>Tài khoản</Link>
                {user.vaiTro === "ADMIN" && (
                  <Link to="/admin/dashboard" onClick={handleNavClick}>Admin</Link>
                )}
                <button onClick={() => { logout(); setIsSidebarOpen(false); }}>Đăng xuất</button>
              </div>
            </div>
          ) : (
            <Link to="/auth" className="login-btn" onClick={handleNavClick}>
              <Person size={18} />
              Đăng nhập / Đăng ký
            </Link>
          )}
        </div>
      </aside>
    </>
  );
};

export default Header;
