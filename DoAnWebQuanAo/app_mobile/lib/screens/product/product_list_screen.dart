import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/category.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/category_service.dart';
import '../../widgets/product/product_grid.dart';
import '../../widgets/product/product_filter_sheet.dart';
import '../../router/app_router.dart';

/// Product List Screen - Danh sách sản phẩm
class ProductListScreen extends StatefulWidget {
  final String? category;
  final String? search;
  final String? sort;

  const ProductListScreen({
    super.key,
    this.category,
    this.search,
    this.sort,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Category> _categories = [];
  String? _selectedCategory;
  String? _selectedPriceRange;
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedSort = widget.sort;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
      _loadCategories();
    });
  }

  Future<void> _loadProducts() async {
    await context.read<ProductProvider>().loadProducts(
      category: _selectedCategory,
      priceRange: _selectedPriceRange,
      sortBy: _selectedSort,
      search: widget.search,
      refresh: true,
    );
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService().getCategories();
      if (mounted) {
        setState(() => _categories = categories);
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  void _openFilterSheet() {
    ProductFilterSheet.show(
      context: context,
      categories: _categories,
      selectedCategory: _selectedCategory,
      selectedPriceRange: _selectedPriceRange,
      selectedSort: _selectedSort,
      onApply: (category, priceRange, sort) {
        setState(() {
          _selectedCategory = category;
          _selectedPriceRange = priceRange;
          _selectedSort = sort;
        });
        _loadProducts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          widget.search != null 
              ? 'Tìm kiếm: "${widget.search}"'
              : AppStrings.products,
        ),
        actions: [
          // Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(Routes.search),
          ),
          // Filter
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters
          _buildActiveFilters(),
          
          // Product grid
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                return ProductGrid(
                  products: provider.products,
                  isLoading: provider.isLoading,
                  isLoadingMore: provider.isLoadingMore,
                  onLoadMore: () => provider.loadMoreProducts(),
                  onProductTap: (product) => 
                      context.push('${Routes.products}/${product.slug}'),
                  onFavoritePressed: (product) =>
                      context.read<WishlistProvider>().toggleWishlist(
                        product.id, 
                        product: product,
                      ),
                  favoriteIds: context.watch<WishlistProvider>()
                      .wishlist.map((p) => p.id).toSet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final hasFilters = _selectedCategory != null || 
                       _selectedPriceRange != null || 
                       _selectedSort != null;
    
    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_selectedSort != null)
              _buildFilterChip(_getSortLabel(_selectedSort!), () {
                setState(() => _selectedSort = null);
                _loadProducts();
              }),
            if (_selectedCategory != null)
              _buildFilterChip(_selectedCategory!, () {
                setState(() => _selectedCategory = null);
                _loadProducts();
              }),
            if (_selectedPriceRange != null)
              _buildFilterChip(_getPriceLabel(_selectedPriceRange!), () {
                setState(() => _selectedPriceRange = null);
                _loadProducts();
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: AppSizes.sm),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: AppColors.primary.withAlpha(25),
        deleteIconColor: AppColors.primary,
        labelPadding: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'newest': return AppStrings.sortNewest;
      case 'price-asc': return AppStrings.sortPriceLowHigh;
      case 'price-desc': return AppStrings.sortPriceHighLow;
      case 'bestselling': return AppStrings.sortBestSelling;
      default: return sort;
    }
  }

  String _getPriceLabel(String range) {
    switch (range) {
      case '0-500000': return 'Dưới 500k';
      case '500000-1000000': return '500k - 1tr';
      case '1000000-2000000': return '1tr - 2tr';
      case '2000000-100000000': return 'Trên 2tr';
      default: return range;
    }
  }
}
