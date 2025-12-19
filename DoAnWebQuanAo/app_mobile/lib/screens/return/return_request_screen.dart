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

/// Return Request Screen - Tạo yêu cầu hoàn trả
class ReturnRequestScreen extends StatefulWidget {
  final int orderId;

  const ReturnRequestScreen({super.key, required this.orderId});

  @override
  State<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends State<ReturnRequestScreen> {
  final ReturnService _returnService = ReturnService();
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedReason;
  final _otherReasonController = TextEditingController();
  final Map<int, bool> _selectedItems = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Yêu cầu hoàn trả'),
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
                  // Order info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt, color: AppColors.primary),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            'Đơn hàng: ${order.maDonHang}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Select products
                  _buildSectionTitle('Chọn sản phẩm hoàn trả'),
                  Card(
                    child: Column(
                      children: order.chiTiet.map((item) {
                        final isSelected = _selectedItems[item.id] ?? false;
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (v) => setState(() => _selectedItems[item.id] = v ?? false),
                          secondary: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            child: item.hinhAnh != null
                                ? CachedNetworkImage(
                                    imageUrl: item.hinhAnh!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 48,
                                    height: 48,
                                    color: AppColors.surfaceVariant,
                                    child: const Icon(Icons.image_outlined, size: 20),
                                  ),
                          ),
                          title: Text(item.tenSanPham, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.thuocTinh != null)
                                Text(item.thuocTinh!, style: const TextStyle(fontSize: 11)),
                              Text(
                                '${Formatters.currency(item.giaBan)} x ${item.soLuong}',
                                style: const TextStyle(fontSize: 12, color: AppColors.error),
                              ),
                            ],
                          ),
                          isThreeLine: item.thuocTinh != null,
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Reason
                  _buildSectionTitle('Lý do hoàn trả'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Column(
                        children: [
                          ..._returnService.getReturnReasons().map((reason) => RadioListTile<String>(
                            value: reason,
                            groupValue: _selectedReason,
                            title: Text(reason, style: const TextStyle(fontSize: 14)),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (v) => setState(() => _selectedReason = v),
                          )),
                          
                          if (_selectedReason == 'Khác')
                            Padding(
                              padding: const EdgeInsets.only(top: AppSizes.sm),
                              child: TextFormField(
                                controller: _otherReasonController,
                                decoration: const InputDecoration(
                                  labelText: 'Mô tả lý do',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                validator: (v) {
                                  if (_selectedReason == 'Khác' && (v?.isEmpty ?? true)) {
                                    return 'Vui lòng mô tả lý do';
                                  }
                                  return null;
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.xl),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Gửi yêu cầu', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Future<void> _submit() async {
    final selectedIds = _selectedItems.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    
    if (selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sản phẩm')),
      );
      return;
    }
    
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn lý do hoàn trả')),
      );
      return;
    }
    
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final reason = _selectedReason == 'Khác' 
          ? _otherReasonController.text 
          : _selectedReason!;
      
      final items = selectedIds.map((id) => {
        'ChiTietDonHangID': id,
        'SoLuongHoanTra': 1, // TODO: Allow quantity selection
      }).toList();

      await _returnService.createReturnRequest(
        donHangId: widget.orderId,
        lyDoHoanTra: reason,
        sanPhamHoanTra: items,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gửi yêu cầu hoàn trả'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(Routes.returns);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
