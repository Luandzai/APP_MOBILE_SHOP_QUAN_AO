import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/voucher_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/location.dart';
import '../../router/app_router.dart';

/// Checkout Screen - Điền thông tin và thanh toán
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoTenController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _emailController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _ghiChuController = TextEditingController();

  Province? _selectedProvince;
  District? _selectedDistrict;
  Ward? _selectedWard;
  String _phuongThucThanhToan = 'COD';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load initial data
      context.read<OrderProvider>().loadProvinces();
      context.read<OrderProvider>().loadShippingMethods();
      context.read<VoucherProvider>().removeAppliedVoucher();

      // Auto-fill user info from AuthProvider
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        _hoTenController.text = user.hoTen;
        _emailController.text = user.email;
        if (user.dienThoai != null && user.dienThoai!.isNotEmpty) {
          _soDienThoaiController.text = user.dienThoai!;
        }
      }
    });
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _soDienThoaiController.dispose();
    _emailController.dispose();
    _diaChiController.dispose();
    _ghiChuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Thanh toán'),
      ),
      body: Consumer2<OrderProvider, CartProvider>(
        builder: (context, orderProvider, cartProvider, _) {
          if (orderProvider.isCreatingOrder) {
            return const Center(child: CircularProgressIndicator());
          }

          final selectedItems = cartProvider.selectedItems;
          if (selectedItems.isEmpty) {
            return const Center(
              child: Text('Không có sản phẩm nào để checkout'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping info
                  _buildSectionTitle('Thông tin giao hàng'),
                  _buildShippingForm(orderProvider),

                  const SizedBox(height: AppSizes.lg),

                  // Shipping method
                  _buildSectionTitle('Phương thức vận chuyển'),
                  _buildShippingMethods(orderProvider),

                  const SizedBox(height: AppSizes.lg),

                  // Payment method
                  _buildSectionTitle('Phương thức thanh toán'),
                  _buildPaymentMethods(),

                  const SizedBox(height: AppSizes.lg),

                  // Voucher
                  _buildSectionTitle('Mã giảm giá'),
                  _buildVoucherSection(),

                  const SizedBox(height: AppSizes.lg),

                  // Order summary
                  _buildSectionTitle('Tóm tắt đơn hàng'),
                  _buildOrderSummary(cartProvider, orderProvider),

                  const SizedBox(height: AppSizes.xl),

                  // Checkout button
                  _buildCheckoutButton(cartProvider, orderProvider),
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

  Widget _buildShippingForm(OrderProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          children: [
            TextFormField(
              controller: _hoTenController,
              decoration: const InputDecoration(
                labelText: 'Họ tên *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v?.isEmpty == true ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _soDienThoaiController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v?.isEmpty == true ? 'Vui lòng nhập SĐT' : null,
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v?.isEmpty == true ? 'Vui lòng nhập email' : null,
            ),
            const SizedBox(height: AppSizes.md),

            // Province dropdown
            DropdownButtonFormField<Province>(
              value: _selectedProvince,
              decoration: const InputDecoration(
                labelText: 'Tỉnh/Thành phố *',
                border: OutlineInputBorder(),
              ),
              items: provider.provinces
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                  .toList(),
              onChanged: (v) {
                debugPrint(
                  'Province selected: ${v?.name} with code: ${v?.code}',
                );
                setState(() {
                  _selectedProvince = v;
                  _selectedDistrict = null;
                  _selectedWard = null;
                });
                if (v != null) provider.loadDistricts(v.code);
              },
              validator: (v) => v == null ? 'Vui lòng chọn tỉnh' : null,
            ),
            const SizedBox(height: AppSizes.md),

            // District dropdown
            DropdownButtonFormField<District>(
              value: _selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'Quận/Huyện *',
                border: OutlineInputBorder(),
              ),
              items: provider.districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedDistrict = v;
                  _selectedWard = null;
                });
                if (v != null) provider.loadWards(v.code);
              },
              validator: (v) => v == null ? 'Vui lòng chọn quận' : null,
            ),
            const SizedBox(height: AppSizes.md),

            // Ward dropdown
            DropdownButtonFormField<Ward>(
              value: _selectedWard,
              decoration: const InputDecoration(
                labelText: 'Phường/Xã *',
                border: OutlineInputBorder(),
              ),
              items: provider.wards
                  .map((w) => DropdownMenuItem(value: w, child: Text(w.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedWard = v),
              validator: (v) => v == null ? 'Vui lòng chọn phường/xã' : null,
            ),
            const SizedBox(height: AppSizes.md),

            TextFormField(
              controller: _diaChiController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ chi tiết *',
                hintText: 'Số nhà, tên đường...',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v?.isEmpty == true ? 'Vui lòng nhập địa chỉ' : null,
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _ghiChuController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethods(OrderProvider provider) {
    return Card(
      child: Column(
        children: provider.shippingMethods
            .map(
              (method) => RadioListTile(
                value: method,
                groupValue: provider.selectedShippingMethod,
                title: Text(method.tenPhuongThuc),
                subtitle: Text(
                  method.thoiGianGiao ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
                secondary: Text(
                  Formatters.currency(method.phiVanChuyen),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onChanged: (v) {
                  if (v != null) provider.selectShippingMethod(v);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      child: Column(
        children: [
          RadioListTile<String>(
            value: 'COD',
            groupValue: _phuongThucThanhToan,
            title: const Text('Thanh toán khi nhận hàng'),
            subtitle: const Text('COD', style: TextStyle(fontSize: 12)),
            onChanged: (v) => setState(() => _phuongThucThanhToan = v!),
          ),
          RadioListTile<String>(
            value: 'VNPAY',
            groupValue: _phuongThucThanhToan,
            title: const Text('VNPAY'),
            subtitle: const Text(
              'Thanh toán qua ví VNPAY',
              style: TextStyle(fontSize: 12),
            ),
            onChanged: (v) => setState(() => _phuongThucThanhToan = v!),
          ),
          RadioListTile<String>(
            value: 'MOMO',
            groupValue: _phuongThucThanhToan,
            title: const Text('MoMo'),
            subtitle: const Text(
              'Thanh toán qua ví MoMo',
              style: TextStyle(fontSize: 12),
            ),
            onChanged: (v) => setState(() => _phuongThucThanhToan = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Consumer<VoucherProvider>(
      builder: (context, provider, _) {
        if (provider.appliedVoucher != null) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.local_offer, color: AppColors.primary),
              title: Text(provider.appliedVoucher!.maKhuyenMai),
              subtitle: Text(
                '-${Formatters.currency(provider.discountAmount)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => provider.removeAppliedVoucher(),
              ),
            ),
          );
        }

        return OutlinedButton.icon(
          onPressed: () => _showVoucherSheet(),
          icon: const Icon(Icons.local_offer_outlined),
          label: const Text('Chọn mã giảm giá'),
        );
      },
    );
  }

  void _showVoucherSheet() {
    final voucherProvider = context.read<VoucherProvider>();
    final cartProvider = context.read<CartProvider>();

    // Build cartItems from selected items
    final cartItems = cartProvider.selectedItems
        .map((item) => {'PhienBanID': item.phienBanId, 'SoLuong': item.soLuong})
        .toList();

    // Load applicable vouchers for cart items
    voucherProvider.loadApplicableVouchers(cartItems);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Consumer<VoucherProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chọn mã giảm giá',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.myVouchers.isEmpty
                      ? const Center(child: Text('Bạn chưa có mã giảm giá nào'))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: provider.myVouchers.length,
                          itemBuilder: (_, index) {
                            final voucher = provider.myVouchers[index];
                            final orderTotal = cartProvider.selectedTotal;
                            final meetsMinimum =
                                voucher.apDungToiThieu <= orderTotal;

                            return ListTile(
                              leading: Icon(
                                Icons.local_offer,
                                color: meetsMinimum
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                              title: Text(
                                voucher.tenKhuyenMai ?? voucher.maKhuyenMai,
                                style: TextStyle(
                                  color: meetsMinimum ? null : Colors.grey,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(voucher.maKhuyenMai),
                                  if (voucher.apDungToiThieu > 0)
                                    Text(
                                      'Đơn tối thiểu ${Formatters.currency(voucher.apDungToiThieu)}',
                                      style: TextStyle(
                                        color: meetsMinimum
                                            ? Colors.grey
                                            : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  if (!meetsMinimum)
                                    Text(
                                      'Chưa đủ điều kiện (còn thiếu ${Formatters.currency(voucher.apDungToiThieu - orderTotal)})',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Text(
                                voucher.loaiGiamGia == 'PHANTRAM' ||
                                        voucher.loaiGiamGia == 'PHAN_TRAM'
                                    ? '-${voucher.giaTriGiam.toInt()}%'
                                    : '-${Formatters.currency(voucher.giaTriGiam)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: meetsMinimum
                                      ? AppColors.primary
                                      : Colors.grey,
                                ),
                              ),
                              enabled: meetsMinimum,
                              onTap: meetsMinimum
                                  ? () {
                                      provider.selectVoucher(
                                        voucher,
                                        orderTotal,
                                      );
                                      Navigator.pop(ctx);
                                    }
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart, OrderProvider order) {
    final subtotal = cart.selectedTotal;
    final shipping = order.shippingFee;
    final discount = context.watch<VoucherProvider>().discountAmount;
    final total = subtotal + shipping - discount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          children: [
            _buildSummaryRow('Tạm tính', Formatters.currency(subtotal)),
            _buildSummaryRow('Phí vận chuyển', Formatters.currency(shipping)),
            if (discount > 0)
              _buildSummaryRow(
                'Giảm giá',
                '-${Formatters.currency(discount)}',
                color: AppColors.success,
              ),
            const Divider(),
            _buildSummaryRow(
              'Tổng cộng',
              Formatters.currency(total),
              isTotal: true,
            ),
          ],
        ),
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
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? (isTotal ? AppColors.error : null),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(CartProvider cart, OrderProvider order) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: order.isCreatingOrder ? null : () => _checkout(cart, order),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: order.isCreatingOrder
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Đặt hàng', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _checkout(CartProvider cart, OrderProvider order) async {
    if (!_formKey.currentState!.validate()) return;
    if (order.selectedShippingMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn phương thức vận chuyển')),
      );
      return;
    }

    final voucher = context.read<VoucherProvider>().appliedVoucher;

    // Convert payment method string to ID
    int paymentMethodId;
    switch (_phuongThucThanhToan) {
      case 'VNPAY':
        paymentMethodId = 702;
        break;
      case 'MOMO':
        paymentMethodId = 703;
        break;
      default: // COD
        paymentMethodId = 701;
    }

    final cartItems = cart.selectedItems
        .map((item) => {'PhienBanID': item.phienBanId, 'SoLuong': item.soLuong})
        .toList();

    final result = await order.createOrder(
      tenNguoiNhan: _hoTenController.text,
      dienThoaiNhan: _soDienThoaiController.text,
      soNha: _diaChiController.text,
      phuongXa: _selectedWard?.name ?? '',
      quanHuyen: _selectedDistrict?.name ?? '',
      tinhThanh: _selectedProvince?.name ?? '',
      ghiChu: _ghiChuController.text.isEmpty ? null : _ghiChuController.text,
      paymentMethodId: paymentMethodId,
      phuongThucVanChuyenId: order.selectedShippingMethod!.id,
      maKhuyenMai: voucher?.maKhuyenMai,
      cartItems: cartItems,
    );

    if (result != null && mounted) {
      // Clear cart
      // Clear selected items handled by checkout flow

      // Navigate based on payment method
      if (_phuongThucThanhToan == 'COD') {
        context.go(
          '${Routes.paymentResult}?success=true&orderId=${result['orderId']}',
        );
      } else if (result['paymentUrl'] != null) {
        // TODO: Open payment URL in webview
        context.go(
          '${Routes.paymentResult}?success=true&orderId=${result['orderId']}',
        );
      }
    } else if (order.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(order.error!), backgroundColor: AppColors.error),
      );
    }
  }
}
