import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product/product_carousel.dart';
import '../../router/app_router.dart';

/// Home Screen - Trang chủ
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load featured products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadFeaturedProducts();
      context.read<WishlistProvider>().loadWishlist();
      context.read<CartProvider>().loadCart();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<ProductProvider>().loadFeaturedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              _buildWelcomeBanner(),

              const SizedBox(height: AppSizes.lg),

              // Best Selling Products
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  return ProductCarousel(
                    title: AppStrings.bestSelling,
                    products: provider.bestSellingProducts,
                    isLoading: provider.isLoadingFeatured,
                    onProductTap: (product) =>
                        context.push('${Routes.products}/${product.slug}'),
                    onFavoritePressed: (product) => context
                        .read<WishlistProvider>()
                        .toggleWishlist(product.id, product: product),
                    favoriteIds: context
                        .watch<WishlistProvider>()
                        .wishlist
                        .map((p) => p.id)
                        .toSet(),
                    onSeeAllPressed: () =>
                        context.push('${Routes.products}?sort=bestselling'),
                  );
                },
              ),

              const SizedBox(height: AppSizes.xl),

              // New Arrivals Products
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  return ProductCarousel(
                    title: AppStrings.newArrivals,
                    products: provider.newestProducts,
                    isLoading: provider.isLoadingFeatured,
                    onProductTap: (product) =>
                        context.push('${Routes.products}/${product.slug}'),
                    onFavoritePressed: (product) => context
                        .read<WishlistProvider>()
                        .toggleWishlist(product.id, product: product),
                    favoriteIds: context
                        .watch<WishlistProvider>()
                        .wishlist
                        .map((p) => p.id)
                        .toSet(),
                    onSeeAllPressed: () =>
                        context.push('${Routes.products}?sort=newest'),
                  );
                },
              ),

              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: Text(
        AppStrings.appName,
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      actions: [
        // Search
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push(Routes.search),
        ),

        // Cart with badge
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  // Dùng 'go' thay vì 'push' để chuyển tab trong Shell Navigation
                  onPressed: () => context.go(Routes.cart),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingMd),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào mừng đến với',
            style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            'Blank Canvas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'Khám phá bộ sưu tập mới nhất',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: () => context.push(Routes.products),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
                vertical: AppSizes.sm,
              ),
            ),
            child: const Text('Mua sắm ngay'),
          ),
        ],
      ),
    );
  }
}
