import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/product.dart';
import 'product_card.dart';

/// Product Grid - Widget hiển thị danh sách sản phẩm dạng lưới
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;
  final Function(Product)? onFavoritePressed;
  final Set<int>? favoriteIds;
  final bool isLoading;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.onFavoritePressed,
    this.favoriteIds,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.scrollController,
    this.padding,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return _buildLoadingGrid();
    }

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            onLoadMore != null &&
            !isLoadingMore) {
          onLoadMore!();
        }
        return false;
      },
      child: GridView.builder(
        controller: scrollController,
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: AppSizes.sm,
          mainAxisSpacing: AppSizes.sm,
        ),
        itemCount: products.length + (isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return _buildLoadingCard();
          }
          
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => onProductTap?.call(product),
            onFavoritePressed: onFavoritePressed != null
                ? () => onFavoritePressed!(product)
                : null,
            isFavorite: favoriteIds?.contains(product.id) ?? false,
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildLoadingCard(),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Không tìm thấy sản phẩm',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// SliverProductGrid - Phiên bản Sliver cho CustomScrollView
class SliverProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;
  final Function(Product)? onFavoritePressed;
  final Set<int>? favoriteIds;
  final int crossAxisCount;
  final double childAspectRatio;

  const SliverProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.onFavoritePressed,
    this.favoriteIds,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: AppSizes.sm,
          mainAxisSpacing: AppSizes.sm,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => onProductTap?.call(product),
              onFavoritePressed: onFavoritePressed != null
                  ? () => onFavoritePressed!(product)
                  : null,
              isFavorite: favoriteIds?.contains(product.id) ?? false,
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
