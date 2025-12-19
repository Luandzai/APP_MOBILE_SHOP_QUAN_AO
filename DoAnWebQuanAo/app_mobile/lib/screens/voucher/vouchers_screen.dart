import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/voucher_provider.dart';
import '../../widgets/voucher/voucher_card.dart';

/// Vouchers Screen - Danh sách mã giảm giá
class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoucherProvider>().loadAvailableVouchers();
      context.read<VoucherProvider>().loadMyVouchers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(AppStrings.vouchers),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Thu thập'),
            Tab(text: 'Của tôi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Available vouchers
          _buildAvailableVouchers(),

          // My vouchers
          _buildMyVouchers(),
        ],
      ),
    );
  }

  Widget _buildAvailableVouchers() {
    return Consumer<VoucherProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.availableVouchers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.availableVouchers.isEmpty) {
          return _buildEmptyState('Không có mã giảm giá nào');
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadAvailableVouchers(),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: provider.availableVouchers.length,
            itemBuilder: (context, index) {
              final voucher = provider.availableVouchers[index];
              return VoucherCard(
                voucher: voucher,
                showCollectButton: true,
                onCollect: () async {
                  final success = await provider.collectVoucher(
                    voucher.maKhuyenMai,
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.successMessage ?? 'Đã thu thập'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else if (provider.error != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.error!),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyVouchers() {
    return Consumer<VoucherProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.myVouchers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.myVouchers.isEmpty) {
          return _buildEmptyState('Bạn chưa có mã giảm giá nào');
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadMyVouchers(),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            itemCount: provider.myVouchers.length,
            itemBuilder: (context, index) {
              final voucher = provider.myVouchers[index];
              return VoucherCard(voucher: voucher);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppSizes.md),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
