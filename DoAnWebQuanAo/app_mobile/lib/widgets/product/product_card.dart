import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';

/// Product Card - Widget hiển thị sản phẩm trong grid
/// 
/// Hiển thị ảnh, tên, giá, badges (New, Sale, Voucher)
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;
  final double? width;
  final double? height;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorite = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            _buildImageSection(),
            
            // Product info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Expanded(
                      child: Text(
                        product.tenSanPham,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSizes.xs),
                    
                    // Price
                    _buildPriceSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusMd),
            ),
            child: product.hinhAnhChinh != null
                ? CachedNetworkImage(
                    imageUrl: product.hinhAnhChinh!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textHint,
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.textHint,
                      size: 40,
                    ),
                  ),
          ),
          
          // Badges (top-left)
          Positioned(
            top: AppSizes.xs,
            left: AppSizes.xs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.isNew) _buildBadge('NEW', AppColors.primary),
                if (product.hasDiscount) ...[
                  if (product.isNew) const SizedBox(height: 4),
                  _buildBadge('-${product.discountPercent}%', AppColors.error),
                ],
                if (product.hasVoucher) ...[
                  if (product.isNew || product.hasDiscount) const SizedBox(height: 4),
                  _buildBadge('VOUCHER', AppColors.success),
                ],
              ],
            ),
          ),
          
          // Favorite button (top-right)
          if (onFavoritePressed != null)
            Positioned(
              top: AppSizes.xs,
              right: AppSizes.xs,
              child: GestureDetector(
                onTap: onFavoritePressed,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(230),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sale price
        Text(
          Formatters.currency(product.giaBan),
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Original price (if has discount)
        if (product.hasDiscount)
          Text(
            Formatters.currency(product.giaGoc),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
