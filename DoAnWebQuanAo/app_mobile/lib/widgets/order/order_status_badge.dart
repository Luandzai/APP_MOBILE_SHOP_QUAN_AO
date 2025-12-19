import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Order Status Badge - Widget hiển thị trạng thái đơn hàng
class OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool showIcon;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(config.icon, size: 14, color: config.textColor),
            const SizedBox(width: 4),
          ],
          Text(
            config.text,
            style: TextStyle(
              color: config.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'CHO_XAC_NHAN':
        return _StatusConfig(
          text: 'Chờ xác nhận',
          textColor: Colors.orange.shade800,
          backgroundColor: Colors.orange.shade50,
          icon: Icons.hourglass_empty,
        );
      case 'DA_XAC_NHAN':
        return _StatusConfig(
          text: 'Đã xác nhận',
          textColor: Colors.blue.shade800,
          backgroundColor: Colors.blue.shade50,
          icon: Icons.check_circle_outline,
        );
      case 'DANG_GIAO':
        return _StatusConfig(
          text: 'Đang giao',
          textColor: AppColors.primary,
          backgroundColor: AppColors.primary.withAlpha(25),
          icon: Icons.local_shipping_outlined,
        );
      case 'DA_GIAO':
        return _StatusConfig(
          text: 'Đã giao',
          textColor: Colors.green.shade800,
          backgroundColor: Colors.green.shade50,
          icon: Icons.inventory_2_outlined,
        );
      case 'HOAN_THANH':
        return _StatusConfig(
          text: 'Hoàn thành',
          textColor: AppColors.success,
          backgroundColor: AppColors.success.withAlpha(25),
          icon: Icons.check_circle,
        );
      case 'HUY':
        return _StatusConfig(
          text: 'Đã hủy',
          textColor: AppColors.error,
          backgroundColor: AppColors.error.withAlpha(25),
          icon: Icons.cancel_outlined,
        );
      default:
        return _StatusConfig(
          text: status,
          textColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceVariant,
          icon: Icons.help_outline,
        );
    }
  }
}

class _StatusConfig {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;

  _StatusConfig({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
  });
}

/// Payment Status Badge - Widget hiển thị trạng thái thanh toán
class PaymentStatusBadge extends StatelessWidget {
  final String status;

  const PaymentStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'DA_THANH_TOAN';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid 
            ? AppColors.success.withAlpha(25) 
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPaid ? AppColors.success : Colors.orange,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle : Icons.pending,
            size: 12,
            color: isPaid ? AppColors.success : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isPaid ? 'Đã thanh toán' : 'Chờ thanh toán',
            style: TextStyle(
              color: isPaid ? AppColors.success : Colors.orange.shade800,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
