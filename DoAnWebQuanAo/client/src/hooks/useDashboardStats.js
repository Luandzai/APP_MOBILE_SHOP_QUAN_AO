// client/src/hooks/useDashboardStats.js
import { useState, useEffect, useContext, useCallback } from 'react';
import AuthContext from '../context/AuthContext';

export const useDashboardStats = () => {
    const [stats, setStats] = useState({
        totalSales: 0,
        newOrdersCount: 0,
        lowStockCount: 0,
        totalUsersCount: 0,
        latestOrders: [],
        topSellingProducts: [],
        lowStockProducts: [],
        topCustomer: null,
    });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const { api } = useContext(AuthContext);

    const [salesData, setSalesData] = useState([]);
    const currentYear = new Date().getFullYear();
    const [selectedYear, setSelectedYear] = useState(currentYear);
    const [chartLoading, setChartLoading] = useState(false);

    const fetchDashboardStats = useCallback(async () => {
        setLoading(true);
        try {
            const { data } = await api.get("/admin/dashboard-stats");
            setStats(data);
        } catch (err) {
            setError(err.response?.data?.message || "Không thể tải dữ liệu Dashboard.");
        } finally {
            setLoading(false);
        }
    }, [api]);

    const fetchSalesDataForChart = useCallback(async (year) => {
        setChartLoading(true);
        try {
            const { data } = await api.get(`/admin/sales/monthly?year=${year}`);
            setSalesData(data.salesData);
        } catch (err) {
            console.error("Lỗi tải dữ liệu biểu đồ:", err);
            // Optionally set an error state for the chart
        } finally {
            setChartLoading(false);
        }
    }, [api]);

    useEffect(() => {
        fetchDashboardStats();
    }, [fetchDashboardStats]);

    useEffect(() => {
        fetchSalesDataForChart(selectedYear);
    }, [fetchSalesDataForChart, selectedYear]);

    return {
        stats,
        loading,
        error,
        salesData,
        selectedYear,
        setSelectedYear,
        chartLoading,
        currentYear
    };
};
