import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order/order_status_badge.dart';
import '../../router/app_router.dart';

/// Order Detail Screen - Chi tiết đơn hàng
class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = provider.currentOrder;
          if (order == null) {
            return const Center(child: Text('Không tìm thấy đơn hàng'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(order, provider),

                const SizedBox(height: AppSizes.sm),

                // Shipping info
                _buildSection(
                  title: 'Thông tin giao hàng',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.person, order.hoTenNguoiNhan),
                      _buildInfoRow(Icons.phone, order.soDienThoai),
                      _buildInfoRow(Icons.location_on, order.diaChi),
                      if (order.ghiChu != null && order.ghiChu!.isNotEmpty)
                        _buildInfoRow(Icons.note, order.ghiChu!),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sm),

                // Products
                _buildSection(
                  title: 'Sản phẩm (${order.chiTiet.length})',
                  child: Column(
                    children: order.chiTiet
                        .map((item) => _buildProductItem(item, order))
                        .toList(),
                  ),
                ),

                const SizedBox(height: AppSizes.sm),

                // Payment info
                _buildSection(
                  title: 'Thông tin thanh toán',
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Tạm tính',
                        Formatters.currency(order.tongTienSanPham),
                      ),
                      _buildSummaryRow(
                        'Phí vận chuyển',
                        Formatters.currency(order.phiVanChuyen),
                      ),
                      if (order.giamGia > 0)
                        _buildSummaryRow(
                          'Giảm giá',
                          '-${Formatters.currency(order.giamGia)}',
                          color: AppColors.success,
                        ),
                      const Divider(),
                      _buildSummaryRow(
                        'Tổng thanh toán',
                        Formatters.currency(order.tongThanhToan),
                        isTotal: true,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _buildInfoRow(
                        Icons.payment,
                        'Phương thức: ${_getPaymentMethodText(order.phuongThucThanhToan)}',
                      ),
                      PaymentStatusBadge(status: order.trangThaiThanhToan),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.sm),

                // Actions
                if (order.canCancel ||
                    order.canRetryPayment ||
                    order.canRequestReturn)
                  _buildActions(order, provider),

                const SizedBox(height: AppSizes.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(order, OrderProvider provider) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.maDonHang,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OrderStatusBadge(status: order.trangThai, showIcon: true),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Đặt lúc: ${Formatters.dateTime(order.ngayDatHang)}',
            style: const TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: AppSizes.sm),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildProductItem(item, order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: item.hinhAnh != null
                ? CachedNetworkImage(
                    imageUrl: item.hinhAnh!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 64,
                    height: 64,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined),
                  ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tenSanPham,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.thuocTinh != null)
                  Text(
                    item.thuocTinh!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatters.currency(item.giaBan),
                      style: const TextStyle(color: AppColors.error),
                    ),
                    Text('x${item.soLuong}'),
                  ],
                ),
                if ((order.trangThai == 'DA_GIAO' ||
                        order.trangThai == 'HOAN_THANH') &&
                    !item.daDanhGia)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 32,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          final result = await context.push(
                            Routes.writeReview,
                            extra: {'product': item, 'orderId': order.id},
                          );
                          if (result == true && mounted) {
                            context.read<OrderProvider>().loadOrderDetail(
                              order.id,
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Viết đánh giá',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? color,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? (isTotal ? AppColors.error : null),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(order, OrderProvider provider) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Row(
        children: [
          if (order.canCancel)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelOrder(order.id, provider),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Hủy đơn'),
              ),
            ),
          if (order.canCancel && order.canRequestReturn)
            const SizedBox(width: AppSizes.sm),
          if (order.canRetryPayment) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () => _retryPayment(order.id, provider),
                child: const Text('Thanh toán lại'),
              ),
            ),
            if (order.canCancel) const SizedBox(width: AppSizes.sm),
          ],
          if (order.canRequestReturn)
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    context.push('${Routes.returnRequest}/${order.id}'),
                child: const Text('Yêu cầu hoàn trả'),
              ),
            ),
        ],
      ),
    );
  }

  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'COD':
        return 'Thanh toán khi nhận hàng';
      case 'VNPAY':
        return 'VNPAY';
      case 'MOMO':
        return 'MoMo';
      default:
        return method;
    }
  }

  Future<void> _retryPayment(int orderId, OrderProvider provider) async {
    final urlString = await provider.retryPayment(orderId);
    if (urlString != null && mounted) {
      final url = Uri.parse(urlString);
      try {
        debugPrint('Launching payment URL: $url');
        bool launched = false;
        if (await canLaunchUrl(url)) {
          launched = await launchUrl(url, mode: LaunchMode.externalApplication);
        }

        if (!launched) {
          debugPrint(
            'Failed/Cannot launch with externalApplication, trying platformDefault',
          );
          launched = await launchUrl(url, mode: LaunchMode.platformDefault);
        }

        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Không thể mở liên kết. Vui lòng kiểm tra trình duyệt.',
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error launching payment URL: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi mở liên kết thanh toán')),
          );
        }
      }
    } else if (provider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _cancelOrder(int orderId, OrderProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.cancelOrder(orderId);
      if (mounted) context.pop();
    }
  }
}
