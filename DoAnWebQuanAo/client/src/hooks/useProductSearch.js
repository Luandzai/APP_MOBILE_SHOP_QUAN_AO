// client/src/hooks/useProductSearch.js
import { useState, useEffect, useContext, useCallback, useRef } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import AuthContext from '../context/AuthContext';

// Kiểm tra có phải desktop không
const isDesktop = () => typeof window !== 'undefined' && window.innerWidth > 992;

const buildCategoryTree = (categories) => {
    const map = {};
    const tree = [];
    categories.forEach((cat) => {
        map[cat.DanhMucID] = { ...cat, children: [] };
    });
    Object.values(map).forEach((cat) => {
        if (cat.DanhMucChaID && map[cat.DanhMucChaID]) {
            map[cat.DanhMucChaID].children.push(cat);
        } else {
            tree.push(cat);
        }
    });
    return tree;
};

export const useProductSearch = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const { api } = useContext(AuthContext);

    // Data states
    const [products, setProducts] = useState([]);
    const [categoryTree, setCategoryTree] = useState([]);
    const [attributes, setAttributes] = useState([]);
    
    // Loading and error states
    const [loadingProducts, setLoadingProducts] = useState(true);
    const [loadingSidebar, setLoadingSidebar] = useState(true);
    const [error, setError] = useState(null);

    // Filter and pagination states
    const [filters, setFilters] = useState({}); // Applied filters (from URL)
    const [pendingFilters, setPendingFilters] = useState({}); // Pending filters (not yet applied)
    const [searchKeyword, setSearchKeyword] = useState('');
    const [sortBy, setSortBy] = useState('newest');
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);

    // Debounce timer ref cho desktop
    const debounceTimerRef = useRef(null);

    // Initial setup for sidebar data (categories and attributes)
    useEffect(() => {
        const fetchSidebarData = async () => {
            setLoadingSidebar(true);
            try {
                const [catRes, attrRes] = await Promise.all([
                    api.get("/categories"),
                    api.get("/attributes"),
                ]);

                setCategoryTree(buildCategoryTree(catRes.data));
                setAttributes(attrRes.data);
                
                // Initialize filters state with all possible attribute slugs
                // AND read URL params at the same time to avoid race condition
                const params = new URLSearchParams(location.search);
                const initialFilters = { 
                    danhMuc: params.get('danhMuc')?.split(',').filter(Boolean) || [], 
                    khoangGia: params.get('khoangGia')?.split(',').filter(Boolean) || [] 
                };
                attrRes.data.forEach((attr) => {
                    const urlValue = params.get(attr.Slug);
                    initialFilters[attr.Slug] = urlValue?.split(',').filter(Boolean) || [];
                });
                setFilters(initialFilters);
                setPendingFilters(initialFilters); // Sync pending with applied
            } catch (err) {
                setError("Không thể tải dữ liệu bộ lọc.");
            } finally {
                setLoadingSidebar(false);
            }
        };
        fetchSidebarData();
    }, [api, location.search]);

    // Update filters based on URL query params ONLY after sidebar is loaded
    useEffect(() => {
        if (loadingSidebar) return; // Wait for sidebar to be ready with all keys

        const params = new URLSearchParams(location.search);
        const pageFromURL = parseInt(params.get("page")) || 1;
        const searchFromURL = params.get("search") || '';
        
        setCurrentPage(pageFromURL);
        setSearchKeyword(searchFromURL);
        
        setFilters(prevFilters => {
            const newFilters = { ...prevFilters };
            Object.keys(newFilters).forEach(key => {
                const value = params.get(key);
                newFilters[key] = value ? value.split(',').filter(Boolean) : [];
            });
            return newFilters;
        });
        
        // Sync pending filters with applied filters from URL
        setPendingFilters(prevFilters => {
            const newFilters = { ...prevFilters };
            Object.keys(newFilters).forEach(key => {
                const value = params.get(key);
                newFilters[key] = value ? value.split(',').filter(Boolean) : [];
            });
            return newFilters;
        });

    }, [location.search, loadingSidebar]);

    // Main effect to fetch products when filters or page change
    useEffect(() => {
        if (loadingSidebar) return; // Don't fetch products until sidebar data is ready

        const fetchProducts = async () => {
            setLoadingProducts(true);
            setError(null);
            
            try {
                const params = new URLSearchParams(location.search);
                // Ensure current state is reflected in params
                params.set('page', currentPage);
                params.set('sortBy', sortBy);

                const response = await api.get('/products', { params });
                setProducts(response.data.products || []);
                setTotalPages(response.data.totalPages || 1);
            } catch {
                setError("Không thể tải danh sách sản phẩm.");
            } finally {
                setLoadingProducts(false);
            }
        };

        fetchProducts();
    }, [location.search, currentPage, sortBy, loadingSidebar, api]);

    const updateURLParams = useCallback((newFilters) => {
        const params = new URLSearchParams();
        Object.keys(newFilters).forEach(key => {
            if (newFilters[key].length > 0) {
                params.set(key, newFilters[key].join(','));
            }
        });
        // Preserve other params like search and sort
        if (searchKeyword) params.set('search', searchKeyword);
        if (sortBy) params.set('sortBy', sortBy);
        
        params.set('page', 1); // Reset to page 1 on filter change
        navigate({ search: params.toString() });
    }, [searchKeyword, sortBy, navigate]);

    // Cập nhật pendingFilters và auto-apply trên Desktop với debounce
    const handleFilterChange = useCallback((filterType, value, isChecked) => {
        setPendingFilters(prev => {
            const currentValues = prev[filterType] || [];
            let newFilters;
            if (isChecked) {
                newFilters = { ...prev, [filterType]: [...currentValues, value] };
            } else {
                newFilters = { ...prev, [filterType]: currentValues.filter((item) => item !== value) };
            }
            
            // Desktop: Auto-apply với debounce 500ms
            if (isDesktop()) {
                if (debounceTimerRef.current) {
                    clearTimeout(debounceTimerRef.current);
                }
                debounceTimerRef.current = setTimeout(() => {
                    updateURLParams(newFilters);
                }, 500);
            }
            
            return newFilters;
        });
    }, [updateURLParams]);

    // Cleanup debounce timer
    useEffect(() => {
        return () => {
            if (debounceTimerRef.current) {
                clearTimeout(debounceTimerRef.current);
            }
        };
    }, []);

    // Áp dụng pending filters (cho Mobile)
    const applyFilters = useCallback(() => {
        // Clear debounce nếu có
        if (debounceTimerRef.current) {
            clearTimeout(debounceTimerRef.current);
        }
        updateURLParams(pendingFilters);
    }, [pendingFilters, updateURLParams]);

    // Reset tất cả filters về rỗng
    const resetFilters = useCallback(() => {
        const emptyFilters = {};
        Object.keys(pendingFilters).forEach(key => {
            emptyFilters[key] = [];
        });
        setPendingFilters(emptyFilters);
        
        // Desktop: auto-apply reset
        if (isDesktop()) {
            updateURLParams(emptyFilters);
        }
    }, [pendingFilters, updateURLParams]);

    // Kiểm tra xem có pending changes không
    const hasPendingChanges = JSON.stringify(filters) !== JSON.stringify(pendingFilters);

    const handleSortChange = (newSortBy) => {
        setSortBy(newSortBy);
        const params = new URLSearchParams(location.search);
        params.set('sortBy', newSortBy);
        params.set('page', 1); // Reset to page 1 on sort change
        navigate({ search: params.toString() });
    };

    const handlePageChange = (page) => {
        const params = new URLSearchParams(location.search);
        params.set('page', page);
        navigate({ search: params.toString() });
        window.scrollTo(0, 0);
    };
    
    const removeSearch = () => {
        const params = new URLSearchParams(location.search);
        params.delete('search');
        navigate({ search: params.toString() });
    };

    return {
        products,
        loadingProducts,
        error,
        categoryTree,
        attributes,
        loadingSidebar,
        filters,
        pendingFilters, // Pending filters cho UI
        handleFilterChange,
        applyFilters, // Nút "Áp dụng"
        resetFilters, // Nút "Đặt lại"
        hasPendingChanges, // Có thay đổi chưa apply không
        searchKeyword,
        removeSearch,
        sortBy,
        handleSortChange,
        pagination: { currentPage, totalPages },
        handlePageChange,
    };
};
