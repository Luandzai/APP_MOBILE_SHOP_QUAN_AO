import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../models/product_variant.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../models/voucher.dart';
import '../../providers/voucher_provider.dart';
import '../../widgets/product/product_reviews.dart';

/// Product Detail Screen - Chi tiáº¿t sáº£n pháº©m
class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  ProductVariant? _selectedVariant;
  int _quantity = 1;
  late ProductProvider _productProvider;

  // Shopee-style: chọn tá»«ng attribute riĂªng (MĂ u Sáº¯c, KĂ­ch Cá»¡)
  Map<String, String> _selectedOptions = {};
  List<Map<String, dynamic>> _availableAttributes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProductDetail(widget.slug);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
  }

  @override
  void dispose() {
    Future.microtask(() => _productProvider.clearCurrentProduct());
    super.dispose();
  }

  /// Parse attributes tá»« variants (gá»i khi product load xong)
  void _parseAttributes(Product product) {
    if (product.phienBan.isEmpty) return;

    final attributesMap = <String, Set<String>>{};
    for (final variant in product.phienBan) {
      variant.options.forEach((name, value) {
        if (value.isNotEmpty) {
          attributesMap.putIfAbsent(name, () => <String>{}).add(value);
        }
      });
    }

    // Convert to list, sort: MĂ u Sáº¯c first, then KĂ­ch Cá»¡
    final parsed = attributesMap.entries
        .map((e) => {'name': e.key, 'values': e.value.toList()})
        .toList();

    parsed.sort((a, b) {
      final aName = (a['name'] as String).toLowerCase();
      final bName = (b['name'] as String).toLowerCase();
      final aIsColor = aName.contains('mĂ u') || aName.contains('color');
      final bIsColor = bName.contains('mĂ u') || bName.contains('color');
      if (aIsColor && !bIsColor) return -1;
      if (!aIsColor && bIsColor) return 1;
      return 0;
    });

    if (_availableAttributes.isEmpty) {
      setState(() {
        _availableAttributes = parsed;
        _selectedOptions = {};
        _selectedVariant = null;
      });
    }
  }

  /// Chá»n má»™t option (Shopee style: toggle)
  void _selectOption(String attributeName, String value) {
    setState(() {
      if (_selectedOptions[attributeName] == value) {
        // Toggle off if already selected
        _selectedOptions.remove(attributeName);
      } else {
        _selectedOptions[attributeName] = value;
      }
      // Update variant khi Ä‘á»§ options
      _updateSelectedVariant();
    });
  }

  /// TĂ¬m variant khá»›p vá»›i táº¥t cáº£ options Ä‘Ă£ chọn
  void _updateSelectedVariant() {
    final product = context.read<ProductProvider>().currentProduct;
    if (product == null) return;

    // ChÆ°a chọn Ä‘á»§ attributes -> khĂ´ng cĂ³ variant
    if (_selectedOptions.length < _availableAttributes.length) {
      _selectedVariant = null;
      return;
    }

    // Tìm variant khớp tất cả options
    _selectedVariant = product.phienBan.firstWhere(
      (variant) => _selectedOptions.entries.every(
        (entry) => variant.options[entry.key] == entry.value,
      ),
      orElse: () => product.phienBan.first,
    );
    _quantity = 1;
  }

  /// Kiá»ƒm tra option cĂ³ kháº£ dá»¥ng khĂ´ng (dá»±a trĂªn options khĂ¡c Ä‘Ă£ chọn)
  Map<String, bool> _getOptionAvailability(
    String attributeName,
    Product product,
  ) {
    final result = <String, bool>{};

    // Tìm attribute theo tên (tránh type error với orElse)
    Map<String, dynamic>? attribute;
    for (final a in _availableAttributes) {
      if (a['name'] == attributeName) {
        attribute = a;
        break;
      }
    }
    if (attribute == null) return result;

    final values = (attribute['values'] as List?)?.cast<String>() ?? [];

    // Get other selected options
    final otherOptions = Map<String, String>.from(_selectedOptions)
      ..remove(attributeName);

    for (final value in values) {
      // Find variants with this value
      final matchingVariants = product.phienBan.where((variant) {
        if (variant.options[attributeName] != value) return false;
        if (otherOptions.isEmpty) return true;
        // Must match all other selected options
        return otherOptions.entries.every(
          (e) => variant.options[e.key] == e.value,
        );
      }).toList();

      final isAvailable = matchingVariants.isNotEmpty;
      final hasStock = matchingVariants.any((v) => v.isInStock);

      result[value] = isAvailable && hasStock;
    }
    return result;
  }

  Future<void> _addToCart() async {
    final product = context.read<ProductProvider>().currentProduct;
    if (product == null || _selectedVariant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn phiĂªn báº£n sáº£n pháº©m'),
        ),
      );
      return;
    }

    final success = await context.read<CartProvider>().addToCart(
      product: product,
      variant: _selectedVariant!,
      quantity: _quantity,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ÄĂ£ thĂªm vĂ o giá» hĂ ng'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final product = provider.currentProduct;
          if (product == null) {
            return const Center(child: Text('KhĂ´ng tĂ¬m tháº¥y sáº£n pháº©m'));
          }

          // Auto-select first variant if not selected
          if (_selectedVariant == null && product.phienBan.isNotEmpty) {
            _selectedVariant = product.phienBan.first;
          }

          return CustomScrollView(
            slivers: [
              // Image gallery
              _buildSliverAppBar(product),

              // Product info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        product.tenSanPham,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSizes.sm),

                      // Price
                      _buildPriceSection(product),

                      if (provider.productVouchers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSizes.lg),
                          child: _buildVouchersSection(
                            provider.productVouchers,
                          ),
                        ),

                      const SizedBox(height: AppSizes.lg),

                      // Variants
                      if (product.phienBan.isNotEmpty)
                        _buildVariantsSection(product),

                      const SizedBox(height: AppSizes.lg),

                      // Quantity
                      _buildQuantitySection(),

                      const SizedBox(height: AppSizes.lg),

                      // Description
                      if (product.moTa != null && product.moTa!.isNotEmpty)
                        _buildDescriptionSection(product),

                      const SizedBox(height: AppSizes.xxl),

                      // Reviews
                      ProductReviews(reviews: product.danhGia),

                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar(Product product) {
    final images = product.hinhAnh.isNotEmpty
        ? product.hinhAnh
        : [ProductImage(url: product.hinhAnhChinh ?? '')];

    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
      pinned: true,
      backgroundColor: AppColors.surface,
      actions: [
        // Wishlist
        Consumer<WishlistProvider>(
          builder: (context, wishlist, _) {
            final isFavorite = wishlist.isInWishlist(product.id);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : null,
              ),
              onPressed: () =>
                  wishlist.toggleWishlist(product.id, product: product),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image
            PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) =>
                  setState(() => _currentImageIndex = index),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index].url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  ),
                );
              },
            ),

            // Page indicator
            if (images.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? AppColors.primary
                            : Colors.grey.withAlpha(128),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(Product product) {
    final displayPrice = _selectedVariant?.giaBan ?? product.giaBan;

    return Row(
      children: [
        Text(
          Formatters.currency(displayPrice),
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        if (product.hasDiscount)
          Text(
            Formatters.currency(product.giaGoc),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        if (product.hasDiscount)
          Container(
            margin: const EdgeInsets.only(left: AppSizes.sm),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${product.discountPercent}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVariantsSection(Product product) {
    // Parse attributes náº¿u chÆ°a parse
    if (_availableAttributes.isEmpty && product.phienBan.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _parseAttributes(product);
      });
    }

    // Náº¿u chÆ°a cĂ³ attributes thĂ¬ return loading
    if (_availableAttributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiá»ƒn thá»‹ tá»«ng attribute riĂªng (MĂ u Sáº¯c, KĂ­ch Cá»¡...)
        for (final attribute in _availableAttributes) ...[
          _buildAttributeSection(
            attributeName: attribute['name'] as String,
            values: (attribute['values'] as List).cast<String>(),
            product: product,
          ),
          const SizedBox(height: AppSizes.md),
        ],

        // Stock info
        if (_selectedVariant != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Row(
              children: [
                Icon(
                  _selectedVariant!.isInStock
                      ? Icons.check_circle
                      : Icons.error,
                  size: 16,
                  color: _selectedVariant!.isInStock
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  _selectedVariant!.isInStock
                      ? 'Còn ${_selectedVariant!.soLuongTonKho} sản phẩm'
                      : AppStrings.outOfStock,
                  style: TextStyle(
                    color: _selectedVariant!.isInStock
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else if (_selectedOptions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Text(
              'Vui lòng chọn ${_availableAttributes.where((a) => !_selectedOptions.containsKey(a['name'])).map((a) => a['name']).join(', ')}',
              style: TextStyle(color: Colors.orange[700], fontSize: 13),
            ),
          ),
      ],
    );
  }

  Widget _buildAttributeSection({
    required String attributeName,
    required List<String> values,
    required Product product,
  }) {
    final availability = _getOptionAvailability(attributeName, product);
    final selectedValue = _selectedOptions[attributeName];

    // Xác định icon cho attribute
    IconData icon = Icons.label_outline;
    if (attributeName.toLowerCase().contains('màu') ||
        attributeName.toLowerCase().contains('color')) {
      icon = Icons.palette;
    } else if (attributeName.toLowerCase().contains('size') ||
        attributeName.toLowerCase().contains('cỡ')) {
      icon = Icons.straighten;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header với icon
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              '$attributeName:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              selectedValue ?? 'chọn $attributeName'.toLowerCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: selectedValue != null
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: selectedValue != null
                    ? AppColors.primary
                    : AppColors.textHint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Options chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: values.map((value) {
            final isSelected = selectedValue == value;
            final isAvailable = availability[value] ?? false;

            return InkWell(
              onTap: isAvailable
                  ? () => _selectOption(attributeName, value)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(25)
                      : (isAvailable ? Colors.white : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isAvailable ? Colors.grey[300]! : Colors.grey[200]!),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : (isAvailable
                              ? AppColors.textPrimary
                              : AppColors.textHint),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySection() {
    final maxQty = _selectedVariant?.soLuongTonKho ?? 10;

    return Row(
      children: [
        Text(
          AppStrings.quantity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppSizes.md),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: _quantity < maxQty
                    ? () => setState(() => _quantity++)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.description,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          product.moTa!,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildVouchersSection(List<Voucher> vouchers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mã giảm giá',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.sm),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vouchers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.sm),
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              final isCollected = voucher.daThuThap;

              return Container(
                width: 200,
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.maKhuyenMai,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            voucher.discountDescription,
                            style: const TextStyle(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: isCollected
                          ? null
                          : () async {
                              final success = await context
                                  .read<VoucherProvider>()
                                  .collectVoucher(voucher.maKhuyenMai);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Đã lưu mã ${voucher.maKhuyenMai}',
                                    ),
                                  ),
                                );
                              }
                            },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(isCollected ? 'Đã lưu' : 'Lưu'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Row(
              children: [
                // Add to cart
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: cart.isLoading ? null : _addToCart,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(
                      cart.isLoading ? 'Äang thĂªm...' : AppStrings.addToCart,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                // Buy now
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to checkout
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(AppStrings.buyNow),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
