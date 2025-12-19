import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../router/app_router.dart';

/// Payment Result Screen - Kết quả thanh toán (Deep Link handling)
class PaymentResultScreen extends StatelessWidget {
  final bool isSuccess;
  final int? orderId;
  final String? message;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    this.orderId,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: (isSuccess ? AppColors.success : AppColors.error)
                        .withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.cancel,
                    size: 80,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),

                const SizedBox(height: AppSizes.xl),

                // Title
                Text(
                  isSuccess ? 'Đặt hàng thành công!' : 'Thanh toán thất bại',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),

                const SizedBox(height: AppSizes.sm),

                // Message
                Text(
                  isSuccess
                      ? 'Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ liên hệ xác nhận đơn hàng trong thời gian sớm nhất.'
                      : message ?? 'Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                if (orderId != null) ...[
                  const SizedBox(height: AppSizes.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      'Mã đơn hàng: #$orderId',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.xxl),

                // Actions
                if (isSuccess) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go(Routes.orders),
                      child: const Text('Xem đơn hàng'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go(Routes.home),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Thử lại'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go(Routes.home),
                      child: const Text('Về trang chủ'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
