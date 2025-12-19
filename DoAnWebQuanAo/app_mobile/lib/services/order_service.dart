import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/order.dart';

/// Service xử lý đơn hàng
class OrderService {
  final ApiClient _apiClient = ApiClient();

  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  /// Lấy danh sách đơn hàng của user
  Future<List<Order>> getMyOrders({String? status}) async {
    String url = ApiEndpoints.orders;
    if (status != null && status.isNotEmpty) {
      url += '?status=$status';
    }
    
    final response = await _apiClient.get(url);
    
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Order.fromJson(e))
          .toList();
    }
    
    // Nếu response là object với key 'orders' hoặc 'data'
    final data = response.data['orders'] ?? response.data['data'] ?? [];
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  /// Lấy chi tiết đơn hàng
  Future<Order> getOrderDetail(int orderId) async {
    final response = await _apiClient.get(
      ApiEndpoints.orderDetail.replaceAll(':id', orderId.toString()),
    );
    return Order.fromJson(response.data);
  }

  /// Tạo đơn hàng mới
  /// Server yêu cầu format:
  /// - shippingInfo: { TenNguoiNhan, DienThoaiNhan, SoNha, PhuongXa, QuanHuyen, TinhThanh }
  /// - paymentMethodId: 701 (COD), 702 (VNPAY), 703 (MOMO)
  /// - PhuongThucID: ID phương thức vận chuyển
  /// - cartItems: [{PhienBanID, SoLuong}]
  /// - notes: ghi chú
  /// - MaKhuyenMai: mã voucher
  Future<Map<String, dynamic>> createOrder({
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
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      data: {
        'shippingInfo': {
          'TenNguoiNhan': tenNguoiNhan,
          'DienThoaiNhan': dienThoaiNhan,
          'SoNha': soNha,
          'PhuongXa': phuongXa,
          'QuanHuyen': quanHuyen,
          'TinhThanh': tinhThanh,
        },
        'paymentMethodId': paymentMethodId,
        'notes': ghiChu,
        'cartItems': cartItems,
        'PhuongThucID': phuongThucVanChuyenId,
        'MaKhuyenMai': maKhuyenMai,
      },
    );
    
    return {
      'orderId': response.data['orderId'] ?? response.data['DonHangID'],
      'maDonHang': response.data['maDonHang'] ?? response.data['MaDonHang'],
      'message': response.data['message'],
      'paymentUrl': response.data['paymentUrl'],
    };
  }

  /// Hủy đơn hàng
  Future<bool> cancelOrder(int orderId, {String? reason}) async {
    await _apiClient.put(
      ApiEndpoints.cancelOrder.replaceAll(':id', orderId.toString()),
      data: {
        if (reason != null) 'lyDoHuy': reason,
      },
    );
    return true;
  }

  /// Xác nhận đã nhận hàng
  Future<bool> confirmDelivery(int orderId) async {
    await _apiClient.put(
      ApiEndpoints.confirmDelivery.replaceAll(':id', orderId.toString()),
    );
    return true;
  }

  /// Thanh toán lại (cho MOMO/VNPAY)
  Future<String?> retryPayment(int orderId) async {
    final response = await _apiClient.post(
      ApiEndpoints.retryPayment.replaceAll(':id', orderId.toString()),
    );
    return response.data['paymentUrl'];
  }

  /// Đếm số đơn theo trạng thái
  Future<Map<String, int>> getOrderCounts() async {
    final response = await _apiClient.get(ApiEndpoints.orderCounts);
    return {
      'choXacNhan': response.data['choXacNhan'] ?? 0,
      'dangGiao': response.data['dangGiao'] ?? 0,
      'daGiao': response.data['daGiao'] ?? 0,
      'huy': response.data['huy'] ?? 0,
    };
  }
}
