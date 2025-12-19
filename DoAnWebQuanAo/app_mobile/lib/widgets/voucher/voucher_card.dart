import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/voucher.dart';

/// Voucher Card - Widget hiển thị mã khuyến mãi
class VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback? onCollect;
  final VoidCallback? onSelect;
  final bool isSelected;
  final bool showCollectButton;
  final bool showSelectButton;

  const VoucherCard({
    super.key,
    required this.voucher,
    this.onCollect,
    this.onSelect,
    this.isSelected = false,
    this.showCollectButton = false,
    this.showSelectButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: isSelected
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left: Discount badge
            _buildDiscountBadge(),
            
            // Center: Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Discount description
                    Text(
                      voucher.discountDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Min order value
                    if (voucher.giaTriDonHangToiThieu != null)
                      Text(
                        '${AppStrings.minOrderValue}: ${_formatPrice(voucher.giaTriDonHangToiThieu!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    
                    const SizedBox(height: 4),
                    
                    // Expiry
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: voucher.daysRemaining <= 3
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getExpiryText(),
                          style: TextStyle(
                            fontSize: 11,
                            color: voucher.daysRemaining <= 3
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Right: Action button
            if (showCollectButton || showSelectButton)
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: _buildActionButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountBadge() {
    Color bgColor;
    IconData icon;
    
    switch (voucher.loaiKhuyenMai) {
      case 'PHAN_TRAM':
        bgColor = AppColors.error;
        icon = Icons.percent;
        break;
      case 'TIEN_MAT':
        bgColor = AppColors.primary;
        icon = Icons.attach_money;
        break;
      case 'FREESHIP':
        bgColor = AppColors.success;
        icon = Icons.local_shipping_outlined;
        break;
      default:
        bgColor = AppColors.primary;
        icon = Icons.local_offer_outlined;
    }

    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(AppSizes.radiusMd),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            _getBadgeText(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (showCollectButton) {
      return OutlinedButton(
        onPressed: voucher.daThuThap ? null : onCollect,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 0),
        ),
        child: Text(
          voucher.daThuThap ? AppStrings.collected : AppStrings.collectVoucher,
          style: const TextStyle(fontSize: 12),
        ),
      );
    }
    
    if (showSelectButton) {
      return Radio<bool>(
        value: true,
        groupValue: isSelected,
        onChanged: (_) => onSelect?.call(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }
    
    return const SizedBox.shrink();
  }

  String _getBadgeText() {
    switch (voucher.loaiKhuyenMai) {
      case 'PHAN_TRAM':
        return '${voucher.giaTriGiam.toInt()}%';
      case 'TIEN_MAT':
        return _formatShortPrice(voucher.giaTriGiam);
      case 'FREESHIP':
        return 'FREE\nSHIP';
      default:
        return 'GIẢM';
    }
  }

  String _getExpiryText() {
    if (voucher.isExpired) {
      return 'Đã hết hạn';
    }
    if (voucher.daysRemaining == 0) {
      return 'Hết hạn hôm nay';
    }
    if (voucher.daysRemaining == 1) {
      return 'Còn 1 ngày';
    }
    return 'Còn ${voucher.daysRemaining} ngày';
  }

  String _formatPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}tr';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return '${value.toInt()}₫';
  }

  String _formatShortPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}TR';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return '${value.toInt()}';
  }
}
