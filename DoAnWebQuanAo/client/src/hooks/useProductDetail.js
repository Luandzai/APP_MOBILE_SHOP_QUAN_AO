// client/src/hooks/useProductDetail.js
import { useState, useEffect, useContext, useCallback, useMemo } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';
import CartContext from '../context/CartContext';

export const useProductDetail = (slug) => {
    // Main data states
    const [product, setProduct] = useState(null);
    const [relatedProducts, setRelatedProducts] = useState([]);
    const [vouchers, setVouchers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    // Variant and selection states
    const [availableAttributes, setAvailableAttributes] = useState([]);
    const [selectedOptions, setSelectedOptions] = useState({});
    const [selectedVariant, setSelectedVariant] = useState(null);
    const [quantity, setQuantity] = useState(1);

    // Image gallery states
    const [currentImageIndex, setCurrentImageIndex] = useState(0);
    const [selectedImage, setSelectedImage] = useState('');

    // Voucher claiming state
    const [claimingVoucher, setClaimingVoucher] = useState(false);

    // Contexts
    const { api, user } = useContext(AuthContext);
    const { addToCart } = useContext(CartContext);

    // Fetch all product-related data
    const fetchProductData = useCallback(async () => {
        setLoading(true);
        try {
            const productResponse = await api.get(`/products/${slug}`);
            const mainProduct = productResponse.data;
            if (!mainProduct) throw new Error("404 - Không tìm thấy sản phẩm");
            
            setProduct(mainProduct);

            const voucherPromise = api.get(`/vouchers/product/${mainProduct.SanPhamID}`);
            const relatedPromise = mainProduct.DanhMucSlug
                ? api.get(`/products?danhMuc=${mainProduct.DanhMucSlug}`)
                : Promise.resolve({ data: { products: [] } });

            const [voucherResponse, relatedResponse] = await Promise.all([voucherPromise, relatedPromise]);
            
            setVouchers(voucherResponse.data);
            setRelatedProducts(relatedResponse.data.products || []);

            if (mainProduct.HinhAnh?.length > 0) {
                setSelectedImage(mainProduct.HinhAnh[0].URL);
                setCurrentImageIndex(0);
            }
        } catch (err) {
            setError(err.message || "Không thể tải chi tiết sản phẩm.");
        } finally {
            setLoading(false);
        }
    }, [api, slug]);

    useEffect(() => {
        window.scrollTo(0, 0);
        fetchProductData();
    }, [slug, fetchProductData]);

    // Parse attributes when product data is loaded (NO auto-select - Shopee style)
    useEffect(() => {
        if (product?.PhienBan?.length > 0) {
            const attributesMap = new Map();
            product.PhienBan.forEach((variant) => {
                if (variant.options) {
                    Object.entries(variant.options).forEach(([name, value]) => {
                        if (!attributesMap.has(name)) attributesMap.set(name, new Set());
                        attributesMap.get(name).add(value);
                    });
                }
            });
            
            let parsedAttributes = Array.from(attributesMap.entries()).map(([name, valueSet]) => ({
                name: name,
                values: [...valueSet],
            }));

            // Sort: Màu Sắc/Color first, then Size
            parsedAttributes.sort((a, b) => {
                const aIsColor = a.name.toLowerCase().includes('màu') || a.name.toLowerCase().includes('color');
                const bIsColor = b.name.toLowerCase().includes('màu') || b.name.toLowerCase().includes('color');
                if (aIsColor && !bIsColor) return -1;
                if (!aIsColor && bIsColor) return 1;
                return 0;
            });

            setAvailableAttributes(parsedAttributes);
            // Don't auto-select - let user choose (Shopee style)
            setSelectedOptions({});
            setSelectedVariant(null);
        }
    }, [product]);

    // Update selected variant when options change
    useEffect(() => {
        if (product && availableAttributes.length > 0) {
            const selectedKeys = Object.keys(selectedOptions);
            
            // No selection = no variant
            if (selectedKeys.length === 0) {
                setSelectedVariant(null);
                return;
            }

            // Find variant that matches ALL selected options
            const newVariant = product.PhienBan.find((variant) => {
                if (!variant.options) return false;
                // Must match all currently selected options
                return selectedKeys.every((key) => {
                    return variant.options[key] === selectedOptions[key];
                });
            });
            
            // Only set variant if ALL attributes are selected
            if (selectedKeys.length === availableAttributes.length && newVariant) {
                setSelectedVariant(newVariant);
                setQuantity(1);
            } else {
                setSelectedVariant(null);
            }
        }
    }, [product, selectedOptions, availableAttributes]);

    // Update main image when index changes
    useEffect(() => {
        if (product?.HinhAnh?.length > 0) {
            setSelectedImage(product.HinhAnh[currentImageIndex].URL);
        }
    }, [currentImageIndex, product]);

    // Handlers - Shopee style: toggle selection, maintain other selections
    const handleOptionSelect = (name, value) => {
        setSelectedOptions(prev => {
            const newOptions = { ...prev };
            
            // Toggle: if already selected, deselect it
            if (prev[name] === value) {
                delete newOptions[name];
                return newOptions;
            }
            
            // Select new value
            newOptions[name] = value;
            return newOptions;
        });
    };

    const handleQuantityChange = (amount) => {
        setQuantity((prev) => Math.max(1, prev + amount));
    };

    const handleAddToCart = () => {
        if (!user) {
            toast.error("Vui lòng đăng nhập để thêm vào giỏ hàng");
            return;
        }
        if (selectedVariant) {
            if (quantity > selectedVariant.SoLuongTonKho) {
                toast.error("Số lượng vượt quá tồn kho!");
                return;
            }
            addToCart(selectedVariant.PhienBanID, quantity);
        } else {
            toast.warn("Vui lòng chọn đầy đủ các thuộc tính");
        }
    };

    const handleClaimVoucher = async (maKhuyenMai) => {
        if (!user) {
            toast.error("Vui lòng đăng nhập để nhận voucher");
            return;
        }

        setClaimingVoucher(true);
        try {
            const response = await api.post('/vouchers/collect', { MaKhuyenMai: maKhuyenMai });
            toast.success(response.data.message || "Đã lưu voucher!");
            // Optionally refetch vouchers to update UI
            if (product?.SanPhamID) {
                const voucherResponse = await api.get(`/vouchers/product/${product.SanPhamID}`);
                setVouchers(voucherResponse.data);
            }
        } catch (err) {
            const errorMsg = err.response?.data?.message || "Không thể nhận voucher";
            toast.error(errorMsg);
        } finally {
            setClaimingVoucher(false);
        }
    };
    
    // Calculate available options for each attribute based on current selections (Shopee-style logic)
    const getAvailableOptionsForAttribute = useCallback((attributeName) => {
        if (!product?.PhienBan) return {};

        const result = {};
        const currentAttribute = availableAttributes.find(a => a.name === attributeName);
        if (!currentAttribute) return {};

        // Get other selected options (excluding current attribute)
        const otherSelectedOptions = Object.entries(selectedOptions).filter(
            ([key]) => key !== attributeName
        );

        currentAttribute.values.forEach(value => {
            // Find all variants that have this option value
            const matchingVariants = product.PhienBan.filter(variant => {
                if (!variant.options || variant.options[attributeName] !== value) return false;
                
                // If no other options selected, all variants with this value are valid
                if (otherSelectedOptions.length === 0) return true;
                
                // Check if this variant matches ALL other selected options
                return otherSelectedOptions.every(([key, selectedValue]) => {
                    return variant.options[key] === selectedValue;
                });
            });

            const isAvailable = matchingVariants.length > 0;
            const hasStock = matchingVariants.some(v => v.SoLuongTonKho > 0);

            result[value] = {
                isAvailable,  // Does a variant with this option exist?
                hasStock,     // Is there stock available?
                disabled: !isAvailable,
                outOfStock: isAvailable && !hasStock
            };
        });

        return result;
    }, [product, selectedOptions, availableAttributes]);

    // Memoized derived values
    const avgRating = useMemo(() => {
        if (product?.DanhGia?.length > 0) {
            return product.DanhGia.reduce((acc, item) => acc + item.DiemSo, 0) / product.DanhGia.length;
        }
        return 0;
    }, [product]);
    
    const reviewCount = useMemo(() => product?.DanhGia?.length || 0, [product]);
    const totalSold = useMemo(() => parseFloat(product?.TotalSold) || 0, [product]);

    return {
        product,
        loading,
        error,
        relatedProducts,
        vouchers,
        availableAttributes,
        selectedOptions,
        selectedVariant,
        quantity,
        selectedImage,
        currentImageIndex,
        avgRating,
        reviewCount,
        totalSold,
        handleOptionSelect,
        handleQuantityChange,
        setCurrentImageIndex,
        handleAddToCart,
        handleClaimVoucher,
        claimingVoucher,
        getAvailableOptionsForAttribute,
    };
};
