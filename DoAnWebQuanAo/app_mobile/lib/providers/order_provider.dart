import 'package:flutter/material.dart';
import '../core/network/api_exception.dart';
import '../models/order.dart';
import '../models/location.dart';
import '../models/shipping_method.dart';
import '../services/order_service.dart';
import '../services/location_service.dart';
import '../services/shipping_service.dart';

/// Provider quản lý state đơn hàng
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  final LocationService _locationService = LocationService();
  final ShippingService _shippingService = ShippingService();

  // State
  List<Order> _allOrders = []; // Tất cả đơn hàng từ server
  List<Order> _orders = [];     // Đơn hàng đã filter
  Order? _currentOrder;
  bool _isLoading = false;
  bool _isCreatingOrder = false;
  String? _error;
  String? _successMessage;

  // Checkout state
  List<Province> _provinces = [];
  List<District> _districts = [];
  List<Ward> _wards = [];
  List<ShippingMethod> _shippingMethods = [];
  ShippingMethod? _selectedShippingMethod;
  double _shippingFee = 0;

  // Filters
  String? _statusFilter;

  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  bool get isCreatingOrder => _isCreatingOrder;
  String? get error => _error;
  String? get successMessage => _successMessage;
  List<Province> get provinces => _provinces;
  List<District> get districts => _districts;
  List<Ward> get wards => _wards;
  List<ShippingMethod> get shippingMethods => _shippingMethods;
  ShippingMethod? get selectedShippingMethod => _selectedShippingMethod;
  double get shippingFee => _shippingFee;
  String? get statusFilter => _statusFilter;

  /// Lấy danh sách đơn hàng
  Future<void> loadOrders({String? status, bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    _error = null;
    _statusFilter = status;
    notifyListeners();

    try {
      // Server trả về tất cả đơn hàng, không filter
      _allOrders = await _orderService.getMyOrders();
      
      // Filter client-side theo status
      if (status != null && status.isNotEmpty) {
        _orders = _allOrders.where((o) => o.trangThai == status).toList();
      } else {
        _orders = List.from(_allOrders);
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải đơn hàng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy chi tiết đơn hàng
  Future<void> loadOrderDetail(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _orderService.getOrderDetail(orderId);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải chi tiết đơn hàng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tạo đơn hàng mới
  Future<Map<String, dynamic>?> createOrder({
    required String tenNguoiNhan,
    required String dienThoaiNhan,
    required String soNha,
    required String phuongXa,
    required String quanHuyen,
    required String tinhThanh,
    String? ghiChu,
    required int paymentMethodId, // 701 COD, 702 VNPAY, 703 MOMO
    required int phuongThucVanChuyenId,
    String? maKhuyenMai,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    _isCreatingOrder = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _orderService.createOrder(
        tenNguoiNhan: tenNguoiNhan,
        dienThoaiNhan: dienThoaiNhan,
        soNha: soNha,
        phuongXa: phuongXa,
        quanHuyen: quanHuyen,
        tinhThanh: tinhThanh,
        ghiChu: ghiChu,
        paymentMethodId: paymentMethodId,
        phuongThucVanChuyenId: phuongThucVanChuyenId,
        maKhuyenMai: maKhuyenMai,
        cartItems: cartItems,
      );

      _successMessage = result['message'] ?? 'Đặt hàng thành công!';
      return result;
    } on ApiException catch (e) {
      _error = e.message;
      return null;
    } catch (e) {
      _error = 'Không thể tạo đơn hàng: $e';
      return null;
    } finally {
      _isCreatingOrder = false;
      notifyListeners();
    }
  }

  /// Hủy đơn hàng
  Future<bool> cancelOrder(int orderId, {String? reason}) async {
    try {
      await _orderService.cancelOrder(orderId, reason: reason);

      // Cập nhật state
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders.removeAt(index);
      }
      if (_currentOrder?.id == orderId) {
        _currentOrder = null;
      }

      _successMessage = 'Đã hủy đơn hàng';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Không thể hủy đơn hàng: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xác nhận đã nhận hàng
  Future<bool> confirmDelivery(int orderId) async {
    try {
      await _orderService.confirmDelivery(orderId);

      // Cập nhật state
      await loadOrderDetail(orderId);

      _successMessage = 'Đã xác nhận nhận hàng';
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  /// Thanh toán lại
  Future<String?> retryPayment(int orderId) async {
    try {
      final paymentUrl = await _orderService.retryPayment(orderId);
      return paymentUrl;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  // ============ CHECKOUT HELPERS ============

  /// Load danh sách tỉnh thành
  Future<void> loadProvinces() async {
    try {
      _provinces = await _locationService.getProvinces();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading provinces: $e');
    }
  }

  /// Load danh sách quận huyện
  Future<void> loadDistricts(String provinceCode) async {
    debugPrint(
      'OrderProvider.loadDistricts called with provinceCode: $provinceCode',
    );
    try {
      _districts = await _locationService.getDistricts(provinceCode);
      debugPrint(
        'OrderProvider.loadDistricts received ${_districts.length} districts',
      );
      _wards = []; // Reset wards
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading districts: $e');
    }
  }

  /// Load danh sách phường xã
  Future<void> loadWards(String districtCode) async {
    debugPrint(
      'OrderProvider.loadWards called with districtCode: $districtCode',
    );
    try {
      _wards = await _locationService.getWards(districtCode);
      debugPrint('OrderProvider.loadWards received ${_wards.length} wards');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading wards: $e');
    }
  }

  /// Load phương thức vận chuyển
  Future<void> loadShippingMethods() async {
    try {
      _shippingMethods = await _shippingService.getShippingMethods();
      if (_shippingMethods.isNotEmpty && _selectedShippingMethod == null) {
        _selectedShippingMethod = _shippingMethods.firstWhere(
          (m) => m.isDefault,
          orElse: () => _shippingMethods.first,
        );
        _shippingFee = _selectedShippingMethod!.phiVanChuyen;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading shipping methods: $e');
    }
  }

  /// Chọn phương thức vận chuyển
  void selectShippingMethod(ShippingMethod method) {
    _selectedShippingMethod = method;
    _shippingFee = method.phiVanChuyen;
    notifyListeners();
  }

  /// Tính phí vận chuyển
  Future<void> calculateShippingFee({
    required String provinceCode,
    required String districtCode,
    double? orderTotal,
  }) async {
    if (_selectedShippingMethod == null) return;

    try {
      _shippingFee = await _shippingService.calculateShippingFee(
        shippingMethodId: _selectedShippingMethod!.id,
        provinceCode: provinceCode,
        districtCode: districtCode,
        orderTotal: orderTotal,
      );
      notifyListeners();
    } catch (e) {
      // Keep default fee
      debugPrint('Error calculating shipping fee: $e');
    }
  }

  /// Lọc đơn hàng theo trạng thái
  List<Order> getOrdersByStatus(String status) {
    if (status == 'all') return _orders;
    return _orders.where((o) => o.trangThai == status).toList();
  }

  /// Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  /// Clear checkout state
  void clearCheckout() {
    _districts = [];
    _wards = [];
    _selectedShippingMethod = null;
    _shippingFee = 0;
    notifyListeners();
  }

  /// Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
  }
}
