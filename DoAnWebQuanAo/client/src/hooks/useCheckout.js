// client/src/hooks/useCheckout.js
import { useState, useEffect, useContext } from "react";
import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";

export const useCheckout = () => {
  const { user, api } = useContext(AuthContext);
  const { checkoutItems, fetchCart, loading: cartLoading } = useContext(CartContext);

  // === State Địa chỉ ===
  const [shippingInfo, setShippingInfo] = useState({
    TenNguoiNhan: user?.hoTen || "",
    Email: user?.email || "",
    DienThoaiNhan: user?.dienThoai || "",
    SoNha: "",
    PhuongXa: "",
    QuanHuyen: "",
    TinhThanh: "",
  });
  const [provinces, setProvinces] = useState([]);
  const [districts, setDistricts] = useState([]);
  const [wards, setWards] = useState([]);
  const [selectedProvinceId, setSelectedProvinceId] = useState("");
  const [selectedDistrictId, setSelectedDistrictId] = useState("");
  const [selectedWardCode, setSelectedWardCode] = useState("");

  // === State Vận chuyển ===
  const [shippingOptions, setShippingOptions] = useState([]);
  const [selectedShipping, setSelectedShipping] = useState(null);

  // === State Thanh toán ===
  const [paymentMethod, setPaymentMethod] = useState("701");
  const [notes, setNotes] = useState("");

  // === State VOUCHER ===
  const [myVouchers, setMyVouchers] = useState([]);
  const [myVouchersLoading, setMyVouchersLoading] = useState(true);
  const [selectedVoucherCode, setSelectedVoucherCode] = useState("");
  const [discountAmount, setDiscountAmount] = useState(0);
  const [voucherError, setVoucherError] = useState("");

  // === State Logic ===
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);

  // === TẢI DỮ LIỆU BAN ĐẦU ===
  useEffect(() => {
    if (user) {
      setShippingInfo((prev) => ({
        ...prev,
        TenNguoiNhan: user.hoTen || "",
        Email: user.email || "",
        DienThoaiNhan: user.dienThoai || "",
      }));
    }

    const fetchInitialData = async () => {
        try {
            const [shippingRes, provincesRes] = await Promise.all([
                api.get("/shipping"),
                api.get("/locations/provinces"),
            ]);
            setShippingOptions(shippingRes.data);
            if (shippingRes.data.length > 0) setSelectedShipping(shippingRes.data[0]);
            setProvinces(provincesRes.data || []);
        } catch (err) {
            console.error("Lỗi tải dữ liệu ban đầu", err);
            setError("Không thể tải được dữ liệu cần thiết cho thanh toán.");
        }
    };

    const fetchMyApplicableVouchers = async () => {
      if (!user || checkoutItems.length === 0) {
        setMyVouchersLoading(false);
        return;
      }
      try {
        setMyVouchersLoading(true);
        const { data } = await api.post("/user/my-applicable-vouchers", {
          cartItems: checkoutItems,
        });
        setMyVouchers(data || []);
      } catch (err) {
        console.error("Lỗi tải voucher có thể áp dụng:", err);
        setMyVouchers([]);
      } finally {
        setMyVouchersLoading(false);
      }
    };

    fetchInitialData();
    fetchMyApplicableVouchers();
  }, [user, api, checkoutItems]);

  // === TẢI ĐỊA CHỈ CON ===
  useEffect(() => {
    if (!selectedProvinceId) {
      setDistricts([]);
      setWards([]);
      return;
    }
    const fetchDistricts = async () => {
      try {
        const { data } = await api.get(`/locations/districts?province_id=${selectedProvinceId}`);
        setDistricts(data || []);
      } catch (err) {
        console.error("Lỗi tải Quận/Huyện", err);
      }
    };
    fetchDistricts();
    const provinceName = provinces.find((p) => p.ProvinceID == selectedProvinceId)?.ProvinceName || "";
    setShippingInfo((prev) => ({ ...prev, TinhThanh: provinceName, QuanHuyen: "", PhuongXa: "" }));
    setSelectedDistrictId("");
    setSelectedWardCode("");
  }, [selectedProvinceId, api, provinces]);

  useEffect(() => {
    if (!selectedDistrictId) {
      setWards([]);
      return;
    }
    const fetchWards = async () => {
      try {
        const { data } = await api.get(`/locations/wards?district_id=${selectedDistrictId}`);
        setWards(data || []);
      } catch (err) {
        console.error("Lỗi tải Phường/Xã", err);
      }
    };
    fetchWards();
    const districtName = districts.find((d) => d.DistrictID == selectedDistrictId)?.DistrictName || "";
    setShippingInfo((prev) => ({ ...prev, QuanHuyen: districtName, PhuongXa: "" }));
    setSelectedWardCode("");
  }, [selectedDistrictId, api, districts]);

  // === TÍNH TOÁN GIÁ ===
  const subtotal = checkoutItems.reduce((acc, item) => acc + item.SoLuong * parseFloat(item.GiaBan), 0);

  useEffect(() => {
    if (!selectedVoucherCode) {
      setDiscountAmount(0);
      setVoucherError("");
      return;
    }
    const voucher = myVouchers.find((v) => v.MaKhuyenMai === selectedVoucherCode);
    if (!voucher) return;

    if (voucher.ApDungToiThieu > subtotal) {
      setDiscountAmount(0);
      setVoucherError(`Đơn hàng phải từ ${parseFloat(voucher.ApDungToiThieu).toLocaleString("vi-VN")} ₫`);
      return;
    }

    setVoucherError("");
    let giamGia = 0;
    if (voucher.LoaiGiamGia === "SOTIEN") {
      giamGia = parseFloat(voucher.GiaTriGiam);
    }
    if (voucher.LoaiGiamGia === "PHANTRAM") {
      giamGia = (subtotal * parseFloat(voucher.GiaTriGiam)) / 100;
    }
    setDiscountAmount(giamGia);
  }, [selectedVoucherCode, myVouchers, subtotal]);

  const shippingFee = selectedShipping ? parseFloat(selectedShipping.PhiCoDinh) : 0;
  const total = subtotal + shippingFee - discountAmount;

  // === HANDLERS ===
  const handleInputChange = (e) => {
    setShippingInfo({ ...shippingInfo, [e.target.name]: e.target.value });
  };

  const handleWardChange = (e) => {
    const wardCode = e.target.value;
    setSelectedWardCode(wardCode);
    const wardName = wards.find((w) => w.WardCode === wardCode)?.WardName || "";
    setShippingInfo((prev) => ({ ...prev, PhuongXa: wardName }));
  };

  const placeOrderHandler = async () => {
    setLoading(true);
    setError("");

    if (!shippingInfo.TenNguoiNhan || !shippingInfo.DienThoaiNhan || !shippingInfo.SoNha || !shippingInfo.PhuongXa || !shippingInfo.QuanHuyen || !shippingInfo.TinhThanh) {
      setError("Vui lòng điền đầy đủ thông tin giao hàng (Tỉnh/Huyện/Xã và Số nhà).");
      setLoading(false);
      return;
    }

    try {
      const response = await api.post("/orders", {
        shippingInfo: shippingInfo,
        paymentMethodId: paymentMethod,
        notes: notes,
        cartItems: checkoutItems,
        PhuongThucID: selectedShipping.PhuongThucID,
        MaKhuyenMai: selectedVoucherCode || null,
      });

      const { data } = response;

      if (data.paymentUrl) {
        window.location.href = data.paymentUrl;
      } else {
        fetchCart();
        setShowSuccessModal(true);
      }
    } catch (err) {
      setError(err.response?.data?.message || "Đặt hàng thất bại.");
    } finally {
      setLoading(false);
    }
  };

  return {
    // Data & State
    shippingInfo,
    provinces,
    districts,
    wards,
    selectedProvinceId,
    selectedDistrictId,
    selectedWardCode,
    shippingOptions,
    selectedShipping,
    paymentMethod,
    notes,
    myVouchers,
    myVouchersLoading,
    selectedVoucherCode,
    discountAmount,
    voucherError,
    error,
    loading,
    cartLoading,
    showSuccessModal,
    subtotal,
    shippingFee,
    total,

    // Setters & Handlers
    setShippingInfo,
    setSelectedProvinceId,
    setSelectedDistrictId,
    handleWardChange,
    setSelectedShipping,
    setPaymentMethod,
    setNotes,
    setSelectedVoucherCode,
    placeOrderHandler,
    setShowSuccessModal,
    handleInputChange,
  };
};
