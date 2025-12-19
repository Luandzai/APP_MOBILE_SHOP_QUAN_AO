// client/src/components/PublicLayout.jsx
import React from "react";
import { Outlet } from "react-router-dom";
import Header from "./Header";
import Footer from "./Footer";
import Chatbot from "./Chatbot";

const PublicLayout = () => {
  return (
    <div className="d-flex flex-column min-vh-100">
      <Header />
      <main className="flex-grow-1 main-content">
        {/* Outlet là nơi nội dung của các trang con (Home, Product, Cart...) sẽ hiển thị */}
        <Outlet />
      </main>
      <Footer />
      <Chatbot />
    </div>
  );
};

export default PublicLayout;
