import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../providers/auth_provider.dart';
import '../../router/app_router.dart';

/// Profile Screen - Trang tài khoản người dùng
/// 
/// Hiển thị thông tin user và menu navigation.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated || auth.user == null) {
            return _buildNotLoggedIn(context);
          }
          
          return _buildProfileContent(context, auth);
        },
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Bạn chưa đăng nhập',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton(
            onPressed: () => context.go(Routes.login),
            child: const Text(AppStrings.login),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, AuthProvider auth) {
    final user = auth.user!;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // User Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            color: AppColors.surface,
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Name
                Text(
                  user.hoTen,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                const SizedBox(height: AppSizes.xs),
                
                // Email
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                // Phone
                if (user.dienThoai != null && user.dienThoai!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xs),
                    child: Text(
                      user.dienThoai!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Menu Items
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Cập nhật tài khoản',
                  onTap: () => context.push(Routes.editProfile),
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: AppStrings.myOrders,
                  onTap: () => context.push(Routes.orders),
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.favorite_outline,
                  title: AppStrings.wishlist,
                  onTap: () => context.push(Routes.wishlist),
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.local_offer_outlined,
                  title: AppStrings.myVouchers,
                  onTap: () => context.push(Routes.vouchers),
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.swap_horiz,
                  title: AppStrings.returnRequests,
                  onTap: () => context.push(Routes.returns),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Logout button
          Container(
            color: AppColors.surface,
            child: _buildMenuItem(
              context,
              icon: Icons.logout,
              title: AppStrings.logout,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () => _handleLogout(context, auth),
            ),
          ),
          
          const SizedBox(height: AppSizes.xl),
          
          // App version
          Text(
            'Phiên bản 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textHint,
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: iconColor ?? AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: AppSizes.paddingLg + AppSizes.iconMd,
      endIndent: AppSizes.paddingLg,
    );
  }

  Future<void> _handleLogout(BuildContext context, AuthProvider auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await auth.logout();
      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }
}
