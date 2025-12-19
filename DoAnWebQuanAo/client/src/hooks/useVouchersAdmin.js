// client/src/hooks/useVouchersAdmin.js
import { useState, useEffect, useContext, useCallback } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';

export const useVouchersAdmin = () => {
    const [vouchers, setVouchers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isProcessing, setIsProcessing] = useState(false);
    const { api } = useContext(AuthContext);

    const fetchVouchers = useCallback(async () => {
        setLoading(true);
        try {
            const { data } = await api.get("/vouchers/admin");
            setVouchers(data);
            setError(null);
        } catch (err) {
            const errMsg = err.response?.data?.message || "Không thể tải danh sách voucher.";
            setError(errMsg);
            toast.error(errMsg);
        } finally {
            setLoading(false);
        }
    }, [api]);

    useEffect(() => {
        fetchVouchers();
    }, [fetchVouchers]);

    const updateVoucherStatus = async (voucherCode, action) => {
        setIsProcessing(true);
        const endpoint = action === 'enable' ? `/vouchers/admin/${voucherCode}/enable` : `/vouchers/admin/${voucherCode}/disable`;
        const successMessage = action === 'enable' ? 'Đã kích hoạt lại voucher.' : 'Đã vô hiệu hóa voucher.';

        try {
            await api.put(endpoint);
            toast.success(successMessage);
            fetchVouchers(); // Refresh list
        } catch (err) {
            toast.error(err.response?.data?.message || "Thao tác thất bại.");
        } finally {
            setIsProcessing(false);
        }
    };
    
    const refreshVouchers = () => {
        fetchVouchers();
    }

    return {
        vouchers,
        loading,
        error,
        isProcessing,
        updateVoucherStatus,
        refreshVouchers
    };
};
