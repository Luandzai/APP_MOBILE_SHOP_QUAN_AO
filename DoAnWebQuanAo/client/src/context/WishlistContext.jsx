// client/src/context/WishlistContext.jsx (ĐÃ SỬA LỖI 404)

import React, { createContext, useState, useEffect, useContext } from "react";
import AuthContext from "./AuthContext"; // Import AuthContext

const WishlistContext = createContext();

export const WishlistProvider = ({ children }) => {
  const [wishlist, setWishlist] = useState([]);
  const [loading, setLoading] = useState(true);

  const { api, user } = useContext(AuthContext);

  // Hàm tải Wishlist
  const fetchWishlist = async () => {
    if (!user) {
      setLoading(false);
      return;
    }
    try {
      setLoading(true);
      // 'api' đã có '/api' rồi, nên chỉ cần gọi '/user/wishlist'
      const { data } = await api.get("/user/wishlist");
      const idArray = data.map((item) => item.SanPhamID);
      setWishlist(idArray);
    } catch (err) {
      console.error("Lỗi khi tải wishlist:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) {
      fetchWishlist();
    } else {
      setWishlist([]);
      setLoading(false);
    }
  }, [user, api]);

  // === SỬA LỖI Ở HÀM NÀY ===
  const addWishlist = async (sanPhamId) => {
    try {
      // Xóa '/api' -> chỉ còn '/wishlist'
      await api.post("/wishlist", { SanPhamID: sanPhamId });
      setWishlist([...wishlist, sanPhamId]);
    } catch (err) {
      console.error("Lỗi khi thêm wishlist:", err);
    }
  };

  // === SỬA LỖI Ở HÀM NÀY ===
  const removeWishlist = async (sanPhamId) => {
    try {
      // Xóa '/api' -> chỉ còn '/wishlist/...'
      await api.delete(`/wishlist/${sanPhamId}`);
      setWishlist(wishlist.filter((id) => id !== sanPhamId));
    } catch (err) {
      console.error("Lỗi khi xóa wishlist:", err);
    }
  };

  // Hàm Kiểm tra (giữ nguyên)
  const isFavorited = (sanPhamId) => {
    return wishlist.includes(sanPhamId);
  };

  return (
    <WishlistContext.Provider
      value={{
        wishlist,
        addWishlist,
        removeWishlist,
        isFavorited,
        loading,
      }}
    >
      {children}
    </WishlistContext.Provider>
  );
};

export default WishlistContext;
