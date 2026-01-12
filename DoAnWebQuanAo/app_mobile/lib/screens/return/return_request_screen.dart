import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/order_provider.dart';
import '../../services/return_service.dart';
import '../../router/app_router.dart';
import '../../models/order_detail.dart';

/// Return Request Screen - Tạo yêu cầu hoàn trả
/// Tham khảo từ Frontend Web: ReturnRequestPage.jsx, ReturnRequestForm.jsx, useReturnRequest.js
class ReturnRequestScreen extends StatefulWidget {
  final int orderId;

  const ReturnRequestScreen({super.key, required this.orderId});

  @override
  State<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends State<ReturnRequestScreen> {
  final ReturnService _returnService = ReturnService();
  final _formKey = GlobalKey<FormState>();

  // Controller cho lý do
  final _reasonController = TextEditingController();

  // Map lưu số lượng muốn trả cho mỗi sản phẩm (theo PhienBanID)
  // Tương tự itemsToReturn trong useReturnRequest.js
  final Map<int, int> _itemsToReturn = {};

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderAndInitItems();
    });
  }

  Future<void> _loadOrderAndInitItems() async {
    if (!mounted) return;
    await context.read<OrderProvider>().loadOrderDetail(widget.orderId);
    if (!mounted) return;
    final order = context.read<OrderProvider>().currentOrder;
    if (order != null) {
      setState(() {
        // Khởi tạo itemsToReturn với 0 quantity cho mỗi sản phẩm
        // Giống như: data.items.forEach(item => { initialItems[item.PhienBanID] = 0; });
        for (final item in order.chiTiet) {
          _itemsToReturn[item.phienBanId] = 0;
        }
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Xử lý thay đổi số lượng - tương tự handleQuantityChange trong useReturnRequest.js
  void _handleQuantityChange(int phienBanId, int maxQuantity, int newValue) {
    if (newValue >= 0 && newValue <= maxQuantity) {
      setState(() {
        _itemsToReturn[phienBanId] = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Yêu cầu Đổi/Trả hàng'),
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
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order info - Hiển thị mã đơn hàng
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt, color: AppColors.primary),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đơn hàng: ${order.maDonHang}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Chọn sản phẩm và số lượng bạn muốn trả:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Error message
                  if (_error != null) ...[
                    const SizedBox(height: AppSizes.md),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingSm),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.lg),

                  // Select products with quantity - Tương tự ReturnRequestForm.jsx
                  _buildSectionTitle('Chọn sản phẩm hoàn trả'),
                  Card(
                    child: Column(
                      children: order.chiTiet.map((item) {
                        return _buildProductItem(item);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // Reason input - Tương tự input textarea trong ReturnRequestForm.jsx
                  _buildSectionTitle('Lý do đổi/trả'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: TextFormField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Nhập lý do đổi/trả hàng',
                          hintText: 'Ví dụ: Sản phẩm bị lỗi, sai kích thước...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập lý do đổi/trả';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  // Quick reason suggestions
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _returnService
                        .getReturnReasons()
                        .where((r) => r != 'Khác')
                        .take(4)
                        .map(
                          (reason) => ActionChip(
                            label: Text(
                              reason,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary, // Màu chữ tối
                              ),
                            ),
                            backgroundColor: AppColors.surfaceVariant,
                            side: BorderSide(color: Colors.grey.shade300),
                            onPressed: () {
                              _reasonController.text = reason;
                            },
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: AppSizes.xl),

                  // Submit button - Giống nút Gửi Yêu Cầu trong ReturnRequestForm.jsx
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Đang gửi...',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : const Text(
                              'Gửi Yêu Cầu',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build product item với quantity selector
  /// Tương tự mỗi ListGroup.Item trong ReturnRequestForm.jsx
  Widget _buildProductItem(OrderDetail item) {
    final currentQty = _itemsToReturn[item.phienBanId] ?? 0;
    final maxQty = item.soLuong;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: item.hinhAnh != null
                ? CachedNetworkImage(
                    imageUrl: item.hinhAnh!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_outlined, size: 24),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, size: 24),
                  ),
          ),

          const SizedBox(width: AppSizes.md),

          // Product info
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
                if (item.thuocTinh != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.thuocTinh!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  Formatters.currency(item.giaBan),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSizes.sm),

          // Quantity selector - Tương tự Form.Control type="number" trong frontend
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrease button
              IconButton(
                onPressed: currentQty > 0
                    ? () => _handleQuantityChange(
                        item.phienBanId,
                        maxQty,
                        currentQty - 1,
                      )
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 24,
                color: currentQty > 0
                    ? AppColors.primary
                    : Colors.grey.shade300,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),

              // Current quantity
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$currentQty',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: currentQty > 0
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),

              // Increase button
              IconButton(
                onPressed: currentQty < maxQty
                    ? () => _handleQuantityChange(
                        item.phienBanId,
                        maxQty,
                        currentQty + 1,
                      )
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 24,
                color: currentQty < maxQty
                    ? AppColors.primary
                    : Colors.grey.shade300,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),

              // Max quantity indicator - Tương tự "/ {item.SoLuong}" trong frontend
              Text(
                '/ $maxQty',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Submit form - Tương tự handleSubmit trong useReturnRequest.js
  Future<void> _submit() async {
    setState(() => _error = null);

    // Validate - Kiểm tra đã chọn sản phẩm chưa
    // Tương tự: if (itemsArray.length === 0) { ... }
    final itemsArray = _itemsToReturn.entries
        .where((e) => e.value > 0)
        .toList();

    if (itemsArray.isEmpty) {
      setState(() => _error = 'Bạn chưa chọn sản phẩm nào để trả.');
      return;
    }

    // Validate lý do
    // Tương tự: if (!reason.trim()) { ... }
    if (!_formKey.currentState!.validate()) {
      setState(() => _error = 'Vui lòng nhập lý do đổi/trả.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = context.read<OrderProvider>().currentOrder;
      if (order == null) {
        throw Exception('Không tìm thấy đơn hàng');
      }

      // Build items array - Tương tự logic trong useReturnRequest.js:
      // const itemsArray = Object.entries(itemsToReturn)
      //   .filter(([, qty]) => qty > 0)
      //   .map(([id, qty]) => {
      //     const itemDetail = order.items.find((i) => i.PhienBanID == id);
      //     return {
      //       PhienBanID: parseInt(id),
      //       SoLuongTra: qty,
      //       GiaHoanTra: itemDetail.GiaLucMua,
      //     };
      //   });
      final items = itemsArray.map((entry) {
        final phienBanId = entry.key;
        final soLuongTra = entry.value;

        // Tìm chi tiết sản phẩm để lấy giá
        final itemDetail = order.chiTiet.firstWhere(
          (i) => i.phienBanId == phienBanId,
        );

        return ReturnItemRequest(
          phienBanId: phienBanId,
          soLuongTra: soLuongTra,
          giaHoanTra: itemDetail.giaBan, // GiaLucMua = giaBan trong OrderDetail
        );
      }).toList();

      // Gọi API - Tương tự: await api.post("/returns", { DonHangID, Reason, items })
      await _returnService.createReturnRequest(
        donHangId: widget.orderId,
        reason: _reasonController.text.trim(),
        items: items,
      );

      if (mounted) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gửi yêu cầu thành công!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate về trang danh sách returns
        // Tương tự: navigate("/profile/returns")
        context.go(Routes.returns);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
