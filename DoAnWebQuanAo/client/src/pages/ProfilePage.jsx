// client/src/pages/ProfilePage.jsx - REDESIGNED v3

import React, { useContext } from "react";
import { NavLink, Outlet } from "react-router-dom";
import { 
  PersonCircle, 
  PersonGear, 
  Bag, 
  Heart, 
  TagFill, 
  ArrowRepeat 
} from "react-bootstrap-icons";

import AuthContext from "../context/AuthContext";
import "./ProfilePage.css";

// Navigation items configuration
const NAV_ITEMS = [
  { path: "/profile", label: "Cập nhật tài khoản", icon: PersonGear, end: true },
  { path: "/profile/orders", label: "Đơn hàng", icon: Bag },
  { path: "/profile/wishlist", label: "Yêu thích", icon: Heart },
  { path: "/profile/vouchers", label: "Mã khuyến mãi", icon: TagFill },
  { path: "/profile/returns", label: "Đổi trả", icon: ArrowRepeat },
];

const ProfilePage = () => {
  const { user } = useContext(AuthContext);

  // Loading state
  if (!user) {
    return (
      <div className="profile-page">
        <div className="profile-loading">
          <p>Đang tải thông tin...</p>
        </div>
      </div>
    );
  }

  // Get user initials for avatar
  const getInitials = (name) => {
    if (!name) return "U";
    const parts = name.trim().split(" ");
    if (parts.length === 1) return parts[0].charAt(0).toUpperCase();
    return (parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
  };

  return (
    <div className="profile-page">
      <div className="profile-page__container">
        {/* Sidebar */}
        <aside className="profile-sidebar">
          {/* User Info */}
          <div className="profile-sidebar__user">
            <div className="profile-sidebar__avatar">
              {getInitials(user.hoTen)}
            </div>
            <div className="profile-sidebar__info">
              <h2 className="profile-sidebar__name">{user.hoTen}</h2>
              <p className="profile-sidebar__email">{user.email}</p>
            </div>
          </div>

          {/* Navigation */}
          <nav className="profile-sidebar__nav">
            {NAV_ITEMS.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                end={item.end}
                className={({ isActive }) =>
                  `profile-sidebar__link ${isActive ? "active" : ""}`
                }
              >
                <item.icon className="profile-sidebar__link-icon" />
                <span>{item.label}</span>
              </NavLink>
            ))}
          </nav>
        </aside>

        {/* Main Content */}
        <main className="profile-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default ProfilePage;
