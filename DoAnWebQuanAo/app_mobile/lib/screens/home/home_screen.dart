import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/product/product_carousel.dart';
import '../../router/app_router.dart';
import '../../models/category.dart';
import '../../models/product.dart';

/// Home Screen - Refactored (Neo-Brutalism Inspired)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadFeaturedProducts();
      context.read<WishlistProvider>().loadWishlist();
      context.read<CartProvider>().loadCart();
      context.read<CategoryProvider>().loadCategories();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<ProductProvider>().loadFeaturedProducts(),
      context.read<CategoryProvider>().loadCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // 1. Custom App Bar
              _buildSliverAppBar(),

              // 2. Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.md),

                    // Hero Banner
                    _buildHeroSection(),

                    const SizedBox(height: AppSizes.xl),

                    // Categories
                    _buildCategoriesSection(),

                    const SizedBox(height: AppSizes.xl),

                    // Best Sellers
                    _buildProductSection(
                      title: AppStrings.bestSelling,
                      providerSelector: (p) => p.bestSellingProducts,
                      onSeeAll: () =>
                          context.go('${Routes.products}?sort=bestselling'),
                    ),

                    const SizedBox(height: AppSizes.lg),

                    // New Arrivals
                    _buildProductSection(
                      title: AppStrings.newArrivals,
                      providerSelector: (p) => p.newestProducts,
                      onSeeAll: () =>
                          context.go('${Routes.products}?sort=newest'),
                    ),

                    const SizedBox(height: AppSizes.xxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.checkroom, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          const Text(
            'BLANK CANVAS',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(Routes.search),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () => context.go(Routes.cart),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
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
        const SizedBox(width: AppSizes.paddingMd),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _bannerController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        children: [
          _buildHeroCard(
            title: 'NEW COLLECTION',
            subtitle: 'SUMMER 2026',
            color: const Color(0xFFE0E7FF), // Indigo 100
            textColor: const Color(0xFF3730A3),
            imageAsset: null, // Placeholder if no image
          ),
          _buildHeroCard(
            title: 'FLASH SALE',
            subtitle: 'UP TO 50% OFF',
            color: const Color(0xFFFEE2E2), // Red 100
            textColor: const Color(0xFF991B1B),
          ),
          _buildHeroCard(
            title: 'STREET WEAR',
            subtitle: 'TRENDING NOW',
            color: const Color(0xFFDCFCE7), // Green 100
            textColor: const Color(0xFF166534),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard({
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    String? imageAsset,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        // Simple shadow for depth (optional)
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(Routes.products),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('SHOP NOW'),
                ),
              ],
            ),
          ),
          // Expanded(flex: 2, child: Placeholder()) // Can put image here later
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {}, // Navigate to all categories if needed
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: Consumer<CategoryProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = provider.categories; // Using tree
              if (categories.isEmpty) return const SizedBox.shrink();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMd,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryItem(category);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () {
        // Navigate search with category query
        context.go('${Routes.products}?category=${category.slug}');
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: AppColors.textPrimary,
            ),
            // Later replace with image:
            // child: ClipOval(child: CachedNetworkImage(imageUrl: category.image ?? '')),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              category.tenDanhMuc,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<Product> Function(ProductProvider) providerSelector,
    required VoidCallback onSeeAll,
  }) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = providerSelector(provider);
        return ProductCarousel(
          title: title,
          products: products,
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
          onSeeAllPressed: onSeeAll,
        );
      },
    );
  }
}
