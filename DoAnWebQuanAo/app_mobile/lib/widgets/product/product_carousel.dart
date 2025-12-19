import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/product.dart';
import 'product_card.dart';

/// Product Carousel - Widget hiển thị sản phẩm dạng carousel ngang
/// 
/// Dùng cho Home screen: Best Selling, New Arrivals, Related Products
class ProductCarousel extends StatelessWidget {
  final String title;
  final List<Product> products;
  final Function(Product)? onProductTap;
  final Function(Product)? onFavoritePressed;
  final Set<int>? favoriteIds;
  final VoidCallback? onSeeAllPressed;
  final bool isLoading;
  final double itemWidth;
  final double itemHeight;

  const ProductCarousel({
    super.key,
    required this.title,
    required this.products,
    this.onProductTap,
    this.onFavoritePressed,
    this.favoriteIds,
    this.onSeeAllPressed,
    this.isLoading = false,
    this.itemWidth = 160,
    this.itemHeight = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onSeeAllPressed != null)
                TextButton(
                  onPressed: onSeeAllPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: AppSizes.sm),
        
        // Product list
        SizedBox(
          height: itemHeight,
          child: isLoading
              ? _buildLoadingList()
              : products.isEmpty
                  ? _buildEmptyState()
                  : _buildProductList(),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          width: itemWidth,
          height: itemHeight,
          onTap: () => onProductTap?.call(product),
          onFavoritePressed: onFavoritePressed != null
              ? () => onFavoritePressed!(product)
              : null,
          isFavorite: favoriteIds?.contains(product.id) ?? false,
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
      itemBuilder: (context, index) => Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Chưa có sản phẩm',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }
}
