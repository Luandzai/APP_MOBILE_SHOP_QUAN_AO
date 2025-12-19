// client/src/main.jsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./styles/responsive-variables.css";
import "./index.css";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext.jsx";
import { WishlistProvider } from "./context/WishlistContext.jsx";
import { CartProvider } from "./context/CartContext.jsx";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { GoogleOAuthProvider } from "@react-oauth/google";

// 1. Import ThemeProvider
import { ThemeProvider } from "./context/ThemeContext.jsx";

const googleClientId = import.meta.env.VITE_GOOGLE_CLIENT_ID;

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <GoogleOAuthProvider clientId={googleClientId}>
      <BrowserRouter>
        {/* 2. Bọc ThemeProvider ở cấp cao nhất (hoặc bên trong AuthProvider đều được) */}
        <ThemeProvider>
          <AuthProvider>
            <WishlistProvider>
              <CartProvider>
                <App />
                <ToastContainer
                  position="top-right"
                  autoClose={3000}
                  theme="colored" // Toastify cũng hỗ trợ theme, ta có thể chỉnh dynamic sau nếu muốn
                />
              </CartProvider>
            </WishlistProvider>
          </AuthProvider>
        </ThemeProvider>
      </BrowserRouter>
    </GoogleOAuthProvider>
  </React.StrictMode>
);
