// client/src/context/CartContext.jsx (Đã cập nhật)

import React, { createContext, useState, useEffect, useContext } from "react";
import AuthContext from "./AuthContext";
import { toast } from "react-toastify";

const CartContext = createContext();

export const CartProvider = ({ children }) => {
  const [cartItems, setCartItems] = useState([]);
  const [checkoutItems, setCheckoutItems] = useState([]); // <-- STATE MỚI
  const [loading, setLoading] = useState(true);
  const { api, user } = useContext(AuthContext);

  // Hàm tải giỏ hàng (khi user đăng nhập)
  const fetchCart = async () => {
    if (!user) {
      setLoading(false);
      return;
    }
    try {
      setLoading(true);
      const { data } = await api.get("/cart");
      setCartItems(data || []);
    } catch (err) {
      console.error("Lỗi khi tải giỏ hàng:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) {
      fetchCart();
    } else {
      setCartItems([]);
      setLoading(false);
    }
  }, [user]);

  // Hàm Thêm vào giỏ hàng
  const addToCart = async (PhienBanID, SoLuong) => {
    try {
      await api.post("/cart", { PhienBanID, SoLuong });
      toast.success("Đã thêm vào giỏ hàng!", { autoClose: 2000 });
      fetchCart(); // Tải lại giỏ hàng (quan trọng)
    } catch (err) {
      toast.error(err.response?.data?.message || "Lỗi khi thêm vào giỏ");
    }
  };

  // Hàm Cập nhật số lượng
  const updateCartQuantity = async (PhienBanID, SoLuong) => {
    try {
      // Gọi API để cập nhật phía server
      await api.put("/cart", { PhienBanID, SoLuong });

      // Cập nhật state ở client mà không cần fetch lại toàn bộ giỏ hàng
      setCartItems((prevItems) =>
        prevItems.map((item) =>
          item.PhienBanID === PhienBanID ? { ...item, SoLuong: SoLuong } : item
        )
      );
      // Không cần gọi fetchCart() nữa, giúp trải nghiệm mượt mà hơn.
    } catch (err) {
      toast.error(err.response?.data?.message || "Lỗi khi cập nhật giỏ hàng");
    }
  };

  // Hàm Xóa khỏi giỏ hàng
  const removeFromCart = async (PhienBanID) => {
    try {
      await api.delete(`/cart/${PhienBanID}`);
      toast.info("Đã xóa sản phẩm khỏi giỏ hàng", { autoClose: 2000 });
      fetchCart(); // Tải lại giỏ hàng (quan trọng)
    } catch {
      toast.error("Lỗi khi xóa sản phẩm");
    }
  };

  // Hàm mới để chỉ định các mặt hàng sẽ thanh toán
  const selectItemsForCheckout = (items) => {
    setCheckoutItems(items);
  };

  // Sửa lại: Chỉ xóa các item đã thanh toán khỏi state, hoặc fetch lại
  const clearCart = () => {
    // Thay vì xóa hết, ta sẽ fetch lại giỏ hàng sau khi đặt hàng thành công
    fetchCart();
  };

  return (
    <CartContext.Provider
      value={{
        cartItems,
        loading,
        checkoutItems, // <-- EXPORT STATE MỚI
        selectItemsForCheckout, // <-- EXPORT HÀM MỚI
        fetchCart,
        addToCart,
        updateCartQuantity,
        removeFromCart,
        clearCart,
      }}
    >
      {children}
    </CartContext.Provider>
  );
};

export default CartContext;
