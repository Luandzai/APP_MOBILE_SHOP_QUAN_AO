import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../models/cart_item.dart';

/// Cart Item Card - Widget hiển thị item trong giỏ hàng
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    this.isSelected = true,
    this.onTap,
    this.onSelect,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.sm / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              if (onSelect != null)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onSelect?.call(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              
              // Product image
              _buildImage(),
              
              const SizedBox(width: AppSizes.sm),
              
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item.tenSanPham ?? 'Sản phẩm',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Variant info
                    if (item.thuocTinh != null && item.thuocTinh!.isNotEmpty)
                      Text(
                        item.thuocTinh!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    
                    const SizedBox(height: AppSizes.sm),
                    
                    // Price and quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          Formatters.currency(item.giaBan ?? 0),
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // Quantity controls
                        _buildQuantityControls(),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Remove button
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.textHint,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: item.hinhAnh != null
          ? CachedNetworkImage(
              imageUrl: item.hinhAnh!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceVariant,
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            )
          : Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceVariant,
              child: const Icon(Icons.image_outlined),
            ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease
          InkWell(
            onTap: item.soLuong > 1 && onQuantityChanged != null
                ? () => onQuantityChanged!(item.soLuong - 1)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(
                Icons.remove,
                size: 16,
                color: item.soLuong > 1 ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ),
          
          // Quantity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.divider),
              ),
            ),
            child: Text(
              '${item.soLuong}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Increase
          InkWell(
            onTap: onQuantityChanged != null
                ? () => onQuantityChanged!(item.soLuong + 1)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Icon(
                Icons.add,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
