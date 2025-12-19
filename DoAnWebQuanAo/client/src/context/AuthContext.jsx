// client/src/context/AuthContext.jsx (Đã nâng cấp Google Login)

import React, { createContext, useState, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify"; // Import toast

const AuthContext = createContext();

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
});

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (token) {
      try {
        const storedUser = JSON.parse(localStorage.getItem("user"));
        setUser(storedUser);
        api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
      } catch {
        localStorage.clear();
      }
    }
    setLoading(false);
  }, []);

  // === HÀM HELPER MỚI ===
  // Hàm này xử lý logic SAU KHI đã có token (từ CSDL của chúng ta)
  const handleAuthSuccess = (token, userData) => {
    localStorage.setItem("token", token);
    localStorage.setItem("user", JSON.stringify(userData));
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    setUser(userData);

    // =======================================================
    // <<< LOGIC CHUYỂN HƯỚNG ĐÃ ĐƯỢC CẬP NHẬT Ở ĐÂY >>>
    // =======================================================
    // Kiểm tra vai trò của người dùng để quyết định chuyển hướng
    if (userData && userData.vaiTro === "ADMIN") {
      navigate("/admin"); // Chuyển hướng Admin đến Dashboard
    } else {
      navigate("/"); // Chuyển hướng User bình thường về Trang chủ
    }
    // =======================================================
  };

  // Hàm Đăng nhập bằng Mật khẩu
  const login = async (Email, MatKhau) => {
    try {
      const response = await api.post("/auth/login", { Email, MatKhau });
      if (response.data) {
        const { token, user: userData } = response.data;
        handleAuthSuccess(token, userData); // Dùng hàm helper
      }
    } catch (error) {
      throw error.response.data;
    }
  };

  // === HÀM MỚI CHO GOOGLE ===
  const googleLogin = async (googleToken) => {
    try {
      // Gửi token của Google đến Back-end
      const response = await api.post("/auth/google", { token: googleToken });

      if (response.data) {
        const { token, user: userData } = response.data;
        handleAuthSuccess(token, userData); // Dùng hàm helper
        toast.success("Đăng nhập Google thành công!");
      }
    } catch (error) {
      throw error.response.data;
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    delete api.defaults.headers.common["Authorization"];
    navigate("/auth");
  };

  const updateUserInContext = (newUserData) => {
    // Phiên dịch PascalCase (form) sang camelCase (context)
    const translatedData = {
      hoTen: newUserData.HoTen,
      dienThoai: newUserData.DienThoai,
      ngaySinh: newUserData.NgaySinh,
      gioiTinh: newUserData.GioiTinh,
    };
    const updatedUser = { ...user, ...translatedData };
    setUser(updatedUser);
    localStorage.setItem("user", JSON.stringify(updatedUser));
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        login,
        googleLogin, // <-- Export hàm mới
        logout,
        api,
        loading,
        updateUserInContext,
      }}
    >
      {!loading && children}
    </AuthContext.Provider>
  );
};

export default AuthContext;
