import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import 'order_status_badge.dart';

/// Order Card - Widget hiển thị đơn hàng trong danh sách
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onRetryPayment;
  final VoidCallback? onConfirmDelivery;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.onRetryPayment,
    this.onConfirmDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.sm / 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Mã đơn + Status
              _buildHeader(),
              
              const Divider(height: AppSizes.lg),
              
              // Products preview
              _buildProductsPreview(),
              
              const SizedBox(height: AppSizes.sm),
              
              // Footer: Total + Actions
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.maDonHang,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.dateTime(order.ngayDatHang),
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
          ],
        ),
        OrderStatusBadge(status: order.trangThai),
      ],
    );
  }

  Widget _buildProductsPreview() {
    if (order.chiTiet.isEmpty) {
      return const Text(
        'Không có sản phẩm',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    // Hiển thị tối đa 2 sản phẩm
    final displayItems = order.chiTiet.take(2).toList();
    final remainingCount = order.chiTiet.length - 2;

    return Column(
      children: [
        ...displayItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: item.hinhAnh != null
                    ? CachedNetworkImage(
                        imageUrl: item.hinhAnh!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.surfaceVariant,
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_not_supported, size: 16),
                        ),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_outlined, size: 16),
                      ),
              ),
              const SizedBox(width: AppSizes.sm),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tenSanPham,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (item.thuocTinh != null)
                      Text(
                        item.thuocTinh!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                  ],
                ),
              ),
              // Quantity & Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'x${item.soLuong}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    Formatters.currency(item.thanhTien),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        
        if (remainingCount > 0)
          Text(
            '+$remainingCount sản phẩm khác',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${order.chiTiet.length} sản phẩm',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Tổng: ',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  Formatters.currency(order.tongThanhToan),
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Actions (if any)
        if (order.canCancel || order.canRetryPayment || order.trangThai == 'DA_GIAO')
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.canCancel && onCancel != null)
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Hủy đơn', style: TextStyle(fontSize: 12)),
                  ),
                
                if (order.canRetryPayment && onRetryPayment != null) ...[
                  const SizedBox(width: AppSizes.sm),
                  ElevatedButton(
                    onPressed: onRetryPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Thanh toán lại', style: TextStyle(fontSize: 12)),
                  ),
                ],
                
                if (order.trangThai == 'DA_GIAO' && onConfirmDelivery != null) ...[
                  const SizedBox(width: AppSizes.sm),
                  ElevatedButton(
                    onPressed: onConfirmDelivery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text('Đã nhận hàng', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
