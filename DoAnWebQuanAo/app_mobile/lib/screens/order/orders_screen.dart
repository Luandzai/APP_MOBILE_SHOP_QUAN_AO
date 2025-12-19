import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order/order_card.dart';
import '../../router/app_router.dart';

/// Orders Screen - Danh sách đơn hàng
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    const _TabItem('Tất cả', null),
    const _TabItem('Chờ thanh toán', 'CHUA_THANH_TOAN'),
    const _TabItem('Đang xử lý', 'DANG_XU_LY'),
    const _TabItem('Đang giao', 'DANG_GIAO'),
    const _TabItem('Đã giao', 'DA_GIAO'),
    const _TabItem('Đã hủy', 'DA_HUY'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _tabs[_tabController.index].status;
    context.read<OrderProvider>().loadOrders(status: status);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Đơn hàng của tôi'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.orders.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadOrders(
              status: _tabs[_tabController.index].status,
              refresh: true,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
              itemCount: provider.orders.length,
              itemBuilder: (context, index) {
                final order = provider.orders[index];
                return OrderCard(
                  order: order,
                  onTap: () => context.push('${Routes.orders}/${order.id}'),
                  onCancel: order.canCancel
                      ? () => _showCancelDialog(order.id)
                      : null,
                  onRetryPayment: order.canRetryPayment
                      ? () => _retryPayment(order.id)
                      : null,
                  onConfirmDelivery: order.trangThai == 'DA_GIAO'
                      ? () => _confirmDelivery(order.id)
                      : null,
                );
              },
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
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: AppSizes.md),
          Text(
            'Chưa có đơn hàng nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          ElevatedButton(
            onPressed: () => context.go(Routes.products),
            child: const Text('Mua sắm ngay'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(int orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<OrderProvider>().cancelOrder(
                orderId,
              );
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã hủy đơn hàng')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );
  }

  Future<void> _retryPayment(int orderId) async {
    final url = await context.read<OrderProvider>().retryPayment(orderId);
    if (url != null) {
      // TODO: Open WebView for payment
      debugPrint('Payment URL: $url');
    }
  }

  Future<void> _confirmDelivery(int orderId) async {
    final success = await context.read<OrderProvider>().confirmDelivery(
      orderId,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xác nhận nhận hàng'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _TabItem {
  final String label;
  final String? status;
  const _TabItem(this.label, this.status);
}
