import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

/// Forgot Password Screen - Màn hình quên mật khẩu
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    final message = await authProvider.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (message != null && mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.forgotPassword),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          const Icon(
            Icons.lock_reset,
            size: 80,
            color: AppColors.primary,
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Title
          Text(
            'Quên mật khẩu?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          Text(
            'Nhập email của bạn để nhận link đặt lại mật khẩu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSizes.xl),
          
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleForgotPassword(),
            decoration: const InputDecoration(
              labelText: AppStrings.email,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: Validators.email,
          ),
          
          const SizedBox(height: AppSizes.xl),
          
          // Submit button
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return ElevatedButton(
                onPressed: auth.isLoading ? null : _handleForgotPassword,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textOnPrimary,
                          ),
                        ),
                      )
                    : const Text(AppStrings.sendResetLink),
              );
            },
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Error message
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.error == null) return const SizedBox.shrink();
              
              return Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, 
                      color: AppColors.error, 
                      size: AppSizes.iconSm,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        auth.error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: AppSizes.iconSm),
                      onPressed: () => auth.clearError(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Back to login link
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Quay lại đăng nhập'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSizes.xl),
        
        // Success icon
        const Icon(
          Icons.mark_email_read_outlined,
          size: 100,
          color: AppColors.success,
        ),
        
        const SizedBox(height: AppSizes.lg),
        
        // Title
        Text(
          'Email đã gửi!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.success,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSizes.md),
        
        Text(
          'Chúng tôi đã gửi link đặt lại mật khẩu đến:\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSizes.sm),
        
        Text(
          'Vui lòng kiểm tra email (và cả thư mục spam)\nLink sẽ hết hạn sau 10 phút.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSizes.xxl),
        
        // Back to login button
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Quay lại đăng nhập'),
        ),
        
        const SizedBox(height: AppSizes.md),
        
        // Resend link
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text('Gửi lại email'),
        ),
      ],
    );
  }
}
