// client/src/App.jsx

import React from "react";
import { Routes, Route } from "react-router-dom";

// Layouts
import PublicLayout from "./components/PublicLayout"; // <-- IMPORT MỚI
import AdminRoute from "./components/AdminRoute";

// Pages Public
import HomePage from "./pages/HomePage";
import ProductListPage from "./pages/ProductListPage";
import ProductDetailPage from "./pages/ProductDetailPage";
import CartPage from "./pages/CartPage";
import CheckoutPage from "./pages/CheckoutPage";
import AuthPage from "./pages/AuthPage";
import ContactPage from "./pages/ContactPage";
import NewsPage from "./pages/NewsPage";
import VirtualTryOnPage from "./pages/VirtualTryOnPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import ResetPasswordPage from "./pages/ResetPasswordPage";
import PaymentResultPage from "./pages/PaymentResultPage";
import ComingSoon from "./pages/ComingSoon";

// Pages User Profile
import ProfilePage from "./pages/ProfilePage";
import ProfileUpdate from "./components/ProfileUpdate";
import UserOrders from "./components/UserOrders";
import UserWishlist from "./components/UserWishlist";
import UserVouchers from "./components/UserVouchers";
import ReturnListPage from "./pages/ReturnListPage";
import ReturnRequestPage from "./pages/ReturnRequestPage";

// Pages Admin
import AdminCategoryPage from "./pages/AdminCategoryPage";
import AdminDashboardPage from "./pages/AdminDashboardPage";
import AdminProductListPage from "./pages/AdminProductListPage";
import AdminOrderListPage from "./pages/AdminOrderListPage";
import AdminUserListPage from "./pages/AdminUserListPage";
import AdminReturnListPage from "./pages/AdminReturnListPage";
import AdminVoucherListPage from "./pages/AdminVoucherListPage";
import AdminReviewListPage from "./pages/AdminReviewListPage";

function App() {
  return (
    <Routes>
      {/* === NHÓM 1: PUBLIC LAYOUT (Có Header, Footer, Chatbot) === */}
      <Route element={<PublicLayout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/products" element={<ProductListPage />} />
        <Route path="/product/:slug" element={<ProductDetailPage />} />
        <Route path="/cart" element={<CartPage />} />
        <Route path="/checkout" element={<CheckoutPage />} />
        <Route path="/auth" element={<AuthPage />} />
        <Route path="/forgot-password" element={<ForgotPasswordPage />} />
        <Route path="/reset-password/:token" element={<ResetPasswordPage />} />
        <Route path="/payment/result" element={<PaymentResultPage />} />
        <Route path="/contact" element={<ContactPage />} />
        <Route path="/news" element={<NewsPage />} />
        <Route path="/virtual-try-on" element={<VirtualTryOnPage />} />

        {/* Các trang Coming Soon */}
        <Route path="/about" element={<ComingSoon />} />
        <Route path="/services" element={<ComingSoon />} />
        <Route path="/faq" element={<ComingSoon />} />
        <Route path="/privacy" element={<ComingSoon />} />
        <Route path="/shipping" element={<ComingSoon />} />
        <Route path="/warranty" element={<ComingSoon />} />

        {/* Profile (Vẫn nằm trong PublicLayout vì cần Header/Footer) */}
        <Route path="/profile" element={<ProfilePage />}>
          <Route index element={<ProfileUpdate />} />
          <Route path="orders" element={<UserOrders />} />
          <Route path="wishlist" element={<UserWishlist />} />
          <Route path="vouchers" element={<UserVouchers />} />
          <Route path="returns" element={<ReturnListPage />} />
        </Route>
        <Route
          path="/profile/return-request/:orderId"
          element={<ReturnRequestPage />}
        />
      </Route>

      {/* === NHÓM 2: ADMIN LAYOUT (Không có Header/Footer/Chatbot chung) === */}
      <Route path="/admin" element={<AdminRoute />}>
        <Route index element={<AdminDashboardPage />} />
        <Route path="dashboard" element={<AdminDashboardPage />} />
        <Route path="products" element={<AdminProductListPage />} />
        <Route path="categories" element={<AdminCategoryPage />} />
        <Route path="orders" element={<AdminOrderListPage />} />
        <Route path="users" element={<AdminUserListPage />} />
        <Route path="returns" element={<AdminReturnListPage />} />
        <Route path="vouchers" element={<AdminVoucherListPage />} />
        <Route path="reviews" element={<AdminReviewListPage />} />
      </Route>
    </Routes>
  );
}

export default App;
