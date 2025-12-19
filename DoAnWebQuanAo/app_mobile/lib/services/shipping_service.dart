import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/shipping_method.dart';

/// Service xử lý phương thức vận chuyển
class ShippingService {
  final ApiClient _apiClient = ApiClient();

  static final ShippingService _instance = ShippingService._internal();
  factory ShippingService() => _instance;
  ShippingService._internal();

  /// Lấy danh sách phương thức vận chuyển
  Future<List<ShippingMethod>> getShippingMethods() async {
    final response = await _apiClient.get(ApiEndpoints.shipping);
    
    if (response.data is List) {
      return (response.data as List)
          .map((e) => ShippingMethod.fromJson(e))
          .toList();
    }
    
    final data = response.data['data'] ?? response.data['methods'] ?? [];
    return (data as List).map((e) => ShippingMethod.fromJson(e)).toList();
  }

  /// Tính phí vận chuyển dựa trên địa chỉ và đơn hàng
  Future<double> calculateShippingFee({
    required int shippingMethodId,
    required String provinceCode,
    required String districtCode,
    double? orderTotal,
  }) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.shipping}/calculate',
      data: {
        'phuongThucVanChuyenId': shippingMethodId,
        'provinceCode': provinceCode,
        'districtCode': districtCode,
        if (orderTotal != null) 'orderTotal': orderTotal,
      },
    );
    
    return _parseDouble(response.data['phiVanChuyen'] ?? response.data['fee']);
  }

  /// Lấy phương thức vận chuyển mặc định
  Future<ShippingMethod?> getDefaultShippingMethod() async {
    final methods = await getShippingMethods();
    return methods.firstWhere(
      (m) => m.isDefault,
      orElse: () => methods.isNotEmpty ? methods.first : throw Exception('No shipping methods'),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
