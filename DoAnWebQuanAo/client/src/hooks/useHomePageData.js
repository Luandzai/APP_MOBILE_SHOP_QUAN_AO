// client/src/hooks/useHomePageData.js
import { useState, useEffect, useContext } from 'react';
import AuthContext from '../context/AuthContext';

export const useHomePageData = () => {
    const [bestSellingProducts, setBestSellingProducts] = useState([]);
    const [newestProducts, setNewestProducts] = useState([]);
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const { api } = useContext(AuthContext);

    useEffect(() => {
        const fetchHomeData = async () => {
            try {
                setLoading(true);
                setError(null);

                // Call all APIs in parallel
                const bestSellingPromise = api.get("/products/bestselling");
                const newestPromise = api.get("/products/newest");
                const categoryPromise = api.get("/categories");

                const [bestSellingRes, newestRes, categoryRes] = await Promise.all([
                    bestSellingPromise,
                    newestPromise,
                    categoryPromise,
                ]);

                setBestSellingProducts(bestSellingRes.data);
                setNewestProducts(newestRes.data);

                // Filter for child categories
                const childCategories = categoryRes.data.filter(
                    (cat) => cat.DanhMucChaID !== null
                );
                setCategories(childCategories);

            } catch (err) {
                setError("Không thể tải dữ liệu trang chủ.");
                console.error(err);
            } finally {
                setLoading(false);
            }
        };

        fetchHomeData();
    }, [api]);

    return {
        bestSellingProducts,
        newestProducts,
        categories,
        loading,
        error,
    };
};
