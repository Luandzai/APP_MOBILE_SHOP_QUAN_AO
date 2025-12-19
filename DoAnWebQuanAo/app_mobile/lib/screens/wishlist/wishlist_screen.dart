import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product/product_grid.dart';
import '../../router/app_router.dart';

/// Wishlist Screen - Danh sách yêu thích
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().loadWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Consumer<WishlistProvider>(
          builder: (context, wishlist, _) {
            return Text('${AppStrings.wishlist} (${wishlist.count})');
          },
        ),
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (wishlist.isLoading && wishlist.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wishlist.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => wishlist.loadWishlist(),
            child: ProductGrid(
              products: wishlist.wishlist,
              onProductTap: (product) => 
                  context.push('${Routes.products}/${product.slug}'),
              onFavoritePressed: (product) =>
                  wishlist.toggleWishlist(product.id, product: product),
              favoriteIds: wishlist.wishlist.map((p) => p.id).toSet(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            AppStrings.emptyWishlist,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            AppStrings.emptyWishlistMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: AppSizes.xl),
          ElevatedButton(
            onPressed: () => context.go(Routes.products),
            child: const Text('Khám phá sản phẩm'),
          ),
        ],
      ),
    );
  }
}
