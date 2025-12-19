// client/src/hooks/useUserReturns.js
import { useState, useEffect, useContext } from 'react';
import AuthContext from '../context/AuthContext';

export const useUserReturns = () => {
    const [returns, setReturns] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const { api } = useContext(AuthContext);

    useEffect(() => {
        const fetchReturns = async () => {
            setLoading(true);
            setError(null);
            try {
                const { data } = await api.get("/user/returns");
                setReturns(data);
            } catch (err) {
                setError("Không thể tải lịch sử đổi/trả.");
            } finally {
                setLoading(false);
            }
        };
        fetchReturns();
    }, [api]);

    return { returns, loading, error };
};
