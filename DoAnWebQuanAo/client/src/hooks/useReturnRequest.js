// client/src/hooks/useReturnRequest.js
import { useState, useEffect, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';

export const useReturnRequest = (orderId) => {
    const navigate = useNavigate();
    const { api } = useContext(AuthContext);

    const [order, setOrder] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    // Form states
    const [reason, setReason] = useState('');
    const [itemsToReturn, setItemsToReturn] = useState({});

    useEffect(() => {
        const fetchOrderDetails = async () => {
            if (!orderId) return;
            setLoading(true);
            try {
                const { data } = await api.get(`/orders/${orderId}`);
                setOrder(data);
                // Initialize itemsToReturn with 0 quantity
                const initialItems = {};
                data.items.forEach(item => {
                    initialItems[item.PhienBanID] = 0;
                });
                setItemsToReturn(initialItems);
            } catch (err) {
                setError(`Không thể tải chi tiết đơn hàng: ${err.message}`);
            } finally {
                setLoading(false);
            }
        };
        fetchOrderDetails();
    }, [api, orderId]);

    const handleQuantityChange = (phienBanID, maxSoLuong, value) => {
        const qty = parseInt(value) || 0;
        if (qty >= 0 && qty <= maxSoLuong) {
            setItemsToReturn({
                ...itemsToReturn,
                [phienBanID]: qty,
            });
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        const itemsArray = Object.entries(itemsToReturn)
            .filter(([, qty]) => qty > 0)
            .map(([id, qty]) => {
                const itemDetail = order.items.find((i) => i.PhienBanID == id);
                return {
                    PhienBanID: parseInt(id),
                    SoLuongTra: qty,
                    GiaHoanTra: itemDetail.GiaLucMua,
                };
            });

        if (itemsArray.length === 0) {
            setError("Bạn chưa chọn sản phẩm nào để trả.");
            setLoading(false);
            return;
        }
        if (!reason.trim()) {
            setError("Vui lòng nhập lý do đổi/trả.");
            setLoading(false);
            return;
        }

        try {
            await api.post("/returns", {
                DonHangID: orderId,
                Reason: reason,
                items: itemsArray,
            });
            toast.success("Gửi yêu cầu thành công!");
            navigate("/profile/returns");
        } catch (err) {
            setError(err.response?.data?.message || "Gửi yêu cầu thất bại.");
            setLoading(false);
        }
    };

    return {
        order,
        loading,
        error,
        reason,
        setReason,
        itemsToReturn,
        handleQuantityChange,
        handleSubmit,
    };
};
