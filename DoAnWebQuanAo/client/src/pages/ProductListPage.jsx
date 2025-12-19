// client/src/pages/ProductListPage.jsx - REDESIGNED v3

import React, { useState } from 'react';
import { Badge, Spinner } from 'react-bootstrap';
import { Funnel, X, ChevronDown, ChevronUp } from 'react-bootstrap-icons';
import { useProductSearch } from '../hooks/useProductSearch';
import Sidebar from '../components/Sidebar';
import ProductCard from '../components/ProductCard';
import './ProductListPage.css';

// Sort Dropdown Component
const SortDropdown = ({ sortBy, onSortChange }) => {
    const [isOpen, setIsOpen] = useState(false);
    
    const sortOptions = [
        { key: 'newest', label: 'Mới nhất' },
        { key: 'price-asc', label: 'Giá: Thấp → Cao' },
        { key: 'price-desc', label: 'Giá: Cao → Thấp' },
    ];

    const currentLabel = sortOptions.find(opt => opt.key === sortBy)?.label || 'Sắp xếp';

    return (
        <div className="plp-sort">
            <button 
                className="plp-sort__btn"
                onClick={() => setIsOpen(!isOpen)}
            >
                <span>{currentLabel}</span>
                {isOpen ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
            </button>
            {isOpen && (
                <div className="plp-sort__dropdown">
                    {sortOptions.map(opt => (
                        <button
                            key={opt.key}
                            className={`plp-sort__option ${sortBy === opt.key ? 'active' : ''}`}
                            onClick={() => {
                                onSortChange(opt.key);
                                setIsOpen(false);
                            }}
                        >
                            {opt.label}
                        </button>
                    ))}
                </div>
            )}
        </div>
    );
};

// Pagination Component
const Pagination = ({ pagination, onPageChange }) => {
    if (!pagination || pagination.totalPages <= 1) return null;
    
    const { currentPage, totalPages } = pagination;
    const pages = [];
    
    // Responsive sibling count: 1 for mobile, 2 for desktop
    const isMobile = typeof window !== 'undefined' && window.innerWidth <= 480;
    const siblingCount = isMobile ? 1 : 2;
    
    let startPage = Math.max(1, currentPage - siblingCount);
    let endPage = Math.min(totalPages, currentPage + siblingCount);
    
    for (let i = startPage; i <= endPage; i++) {
        pages.push(i);
    }

    return (
        <div className="plp-pagination">
            <button 
                className="plp-pagination__btn"
                onClick={() => onPageChange(currentPage - 1)}
                disabled={currentPage === 1}
            >
                ←
            </button>
            
            {startPage > 1 && (
                <>
                    <button className="plp-pagination__btn" onClick={() => onPageChange(1)}>1</button>
                    {startPage > 2 && <span className="plp-pagination__dots">...</span>}
                </>
            )}
            
            {pages.map(page => (
                <button
                    key={page}
                    className={`plp-pagination__btn ${page === currentPage ? 'active' : ''}`}
                    onClick={() => onPageChange(page)}
                >
                    {page}
                </button>
            ))}
            
            {endPage < totalPages && (
                <>
                    {endPage < totalPages - 1 && <span className="plp-pagination__dots">...</span>}
                    <button className="plp-pagination__btn" onClick={() => onPageChange(totalPages)}>{totalPages}</button>
                </>
            )}
            
            <button 
                className="plp-pagination__btn"
                onClick={() => onPageChange(currentPage + 1)}
                disabled={currentPage === totalPages}
            >
                →
            </button>
        </div>
    );
};

// Main Component
const ProductListPage = () => {
    const [isFilterOpen, setIsFilterOpen] = useState(false);
    
    const {
        products,
        loadingProducts,
        error,
        categoryTree,
        attributes,
        loadingSidebar,
        filters,
        pendingFilters,
        handleFilterChange,
        applyFilters,
        resetFilters,
        hasPendingChanges,
        searchKeyword,
        removeSearch,
        sortBy,
        handleSortChange,
        pagination,
        handlePageChange,
    } = useProductSearch();

    // Count active filters từ pendingFilters
    const pendingFilterCount = Object.values(pendingFilters).reduce((count, arr) => {
        return count + (Array.isArray(arr) ? arr.length : 0);
    }, 0);

    return (
        <div className="plp">
            {/* Mobile Filter Toggle Bar */}
            <div className="plp-mobile-bar">
                <button 
                    className="plp-mobile-bar__filter-btn"
                    onClick={() => setIsFilterOpen(true)}
                >
                    <Funnel size={18} />
                    <span>Bộ lọc</span>
                    {pendingFilterCount > 0 && (
                        <span className="plp-mobile-bar__count">{pendingFilterCount}</span>
                    )}
                </button>
                <SortDropdown sortBy={sortBy} onSortChange={handleSortChange} />
            </div>

            {/* Filter Drawer Overlay */}
            <div 
                className={`plp-drawer-overlay ${isFilterOpen ? 'active' : ''}`}
                onClick={() => setIsFilterOpen(false)}
            />

            {/* Filter Drawer (Mobile) */}
            <aside className={`plp-drawer ${isFilterOpen ? 'open' : ''}`}>
                <div className="plp-drawer__header">
                    <h3>Bộ lọc</h3>
                    <button 
                        className="plp-drawer__close"
                        onClick={() => setIsFilterOpen(false)}
                    >
                        <X size={24} />
                    </button>
                </div>
                <div className="plp-drawer__content">
                    <Sidebar
                        onFilterChange={handleFilterChange}
                        activeFilters={pendingFilters}
                        categoryTree={categoryTree}
                        attributes={attributes}
                        isLoading={loadingSidebar}
                    />
                </div>
                <div className="plp-drawer__footer">
                    <button 
                        className="plp-drawer__reset-btn"
                        onClick={resetFilters}
                        disabled={pendingFilterCount === 0}
                    >
                        Đặt lại
                    </button>
                    <button 
                        className="plp-drawer__apply-btn"
                        onClick={() => {
                            applyFilters();
                            setIsFilterOpen(false);
                        }}
                    >
                        Áp dụng {hasPendingChanges && '✓'}
                    </button>
                </div>
            </aside>

            {/* Main Content */}
            <div className="plp-container">
                {/* Desktop Sidebar */}
                <aside className="plp-sidebar">
                    <Sidebar
                        onFilterChange={handleFilterChange}
                        activeFilters={pendingFilters}
                        categoryTree={categoryTree}
                        attributes={attributes}
                        isLoading={loadingSidebar}
                    />
                    {/* Desktop: Chỉ hiện nút Đặt lại (auto-apply với debounce) */}
                    {!loadingSidebar && pendingFilterCount > 0 && (
                        <div className="plp-sidebar__actions">
                            <button 
                                className="plp-sidebar__reset-btn plp-sidebar__reset-btn--full"
                                onClick={resetFilters}
                            >
                                Đặt lại bộ lọc
                            </button>
                        </div>
                    )}
                </aside>

                {/* Products Area */}
                <main className="plp-main">
                    {/* Top Bar */}
                    <div className="plp-topbar">
                        <div className="plp-topbar__left">
                            {searchKeyword && (
                                <div className="plp-search-tag">
                                    <span>Kết quả:</span>
                                    <Badge 
                                        pill 
                                        bg="primary" 
                                        className="plp-search-tag__badge"
                                        onClick={removeSearch}
                                    >
                                        {searchKeyword} <X size={14} />
                                    </Badge>
                                </div>
                            )}
                            {!loadingProducts && (
                                <span className="plp-topbar__count">
                                    {products.length} sản phẩm
                                </span>
                            )}
                        </div>
                        <div className="plp-topbar__right">
                            <SortDropdown sortBy={sortBy} onSortChange={handleSortChange} />
                        </div>
                    </div>

                    {/* Products Grid */}
                    {loadingProducts ? (
                        <div className="plp-loading">
                            <Spinner animation="border" />
                            <span>Đang tải sản phẩm...</span>
                        </div>
                    ) : error ? (
                        <div className="plp-error">{error}</div>
                    ) : products.length === 0 ? (
                        <div className="plp-empty">
                            <p>Không tìm thấy sản phẩm nào phù hợp.</p>
                            <p className="text-muted">Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm.</p>
                        </div>
                    ) : (
                        <>
                            <div className="plp-grid">
                                {products.map(product => (
                                    <div key={product.SanPhamID} className="plp-grid__item">
                                        <ProductCard product={product} />
                                    </div>
                                ))}
                            </div>
                            <Pagination 
                                pagination={pagination} 
                                onPageChange={handlePageChange} 
                            />
                        </>
                    )}
                </main>
            </div>
        </div>
    );
};

export default ProductListPage;
