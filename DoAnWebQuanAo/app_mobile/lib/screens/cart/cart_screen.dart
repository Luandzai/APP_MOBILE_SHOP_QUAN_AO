import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart/cart_item_card.dart';
import '../../router/app_router.dart';

/// Cart Screen - Giỏ hàng
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Text('${AppStrings.cart} (${cart.itemCount})');
          },
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearCartDialog(context),
                child: const Text('Xóa tất cả'),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isLoading && cart.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cart.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // Select all
              _buildSelectAllRow(cart),
              
              // Cart items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemCard(
                      item: item,
                      isSelected: item.daChon,
                      onSelect: () => cart.toggleItemSelection(item.id),
                      onRemove: () => _confirmRemove(context, item.id),
                      onQuantityChanged: (qty) => cart.updateQuantity(item.id, qty),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            AppStrings.emptyCart,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            AppStrings.emptyCartMessage,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: AppSizes.xl),
          ElevatedButton(
            onPressed: () => context.go(Routes.home),
            child: const Text(AppStrings.continueShopping),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllRow(CartProvider cart) {
    final allSelected = cart.items.every((item) => item.daChon);
    
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: (_) => cart.toggleSelectAll(),
          ),
          const Text(AppStrings.selectAll),
          const Spacer(),
          if (cart.selectedItems.isNotEmpty)
            TextButton(
              onPressed: () => _confirmRemoveSelected(context, cart),
              child: Text(
                'Xóa (${cart.selectedItems.length})',
                style: const TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Row(
              children: [
                // Total
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.total,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        Formatters.currency(cart.selectedTotal),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Checkout button
                ElevatedButton(
                  onPressed: cart.selectedItems.isEmpty ? null : () {
                    // TODO: Navigate to checkout
                    context.push(Routes.checkout);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    '${AppStrings.checkout} (${cart.selectedItems.length})',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartProvider>().removeFromCart(itemId);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveSelected(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: Text('Xóa ${cart.selectedItems.length} sản phẩm đã chọn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cart.removeSelectedItems();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content: const Text('Xóa tất cả sản phẩm trong giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartProvider>().clearCart();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
