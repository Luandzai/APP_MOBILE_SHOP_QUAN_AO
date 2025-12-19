// client/src/components/AdminRoute.jsx (PHIÊN BẢN SỬ DỤNG camelCase VÀ ĐÃ FIX LỖI RUNTIME)

import React, { useContext, useEffect, useState } from "react";
import { Navigate, Outlet } from "react-router-dom";
import AuthContext from "../context/AuthContext";
import { Spinner } from "react-bootstrap";
import { toast } from "react-toastify";

const AdminRoute = () => {
  const { user, loading } = useContext(AuthContext);
  const [authCheckComplete, setAuthCheckComplete] = useState(false);

  // 1. Dùng useEffect để xử lý side effect (toast)
  useEffect(() => {
    if (!loading) {
      // Dùng thuộc tính vaiTro và trangThai (camelCase)
      const isAuthorized =
        user && user.vaiTro === "ADMIN" && user.trangThai === "ACTIVE";

      if (!isAuthorized) {
        if (!user) {
          toast.error("Vui lòng đăng nhập để truy cập khu vực Admin.");
        } else if (user.vaiTro !== "ADMIN") {
          toast.error("Bạn không có quyền truy cập khu vực quản trị!");
        } else if (user.trangThai !== "ACTIVE") {
          toast.error("Tài khoản của bạn đã bị khóa!");
        }
      }
      setAuthCheckComplete(true);
    }
  }, [user, loading]);

  // 2. Render chính
  if (loading || !authCheckComplete) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  // Quyết định cho phép truy cập hay chuyển hướng
  // Dùng thuộc tính vaiTro và trangThai (camelCase)
  const isAdmin =
    user && user.vaiTro === "ADMIN" && user.trangThai === "ACTIVE";

  if (isAdmin) {
    return <Outlet />;
  } else {
    return <Navigate to="/" replace />;
  }
};

export default AdminRoute;
