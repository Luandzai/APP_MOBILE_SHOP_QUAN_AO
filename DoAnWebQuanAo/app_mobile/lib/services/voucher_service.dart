import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/voucher.dart' as model;

/// Voucher Service - Quản lý mã khuyến mãi
class VoucherService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final VoucherService _instance = VoucherService._internal();
  factory VoucherService() => _instance;
  VoucherService._internal();

  /// Lấy danh sách voucher có thể thu thập
  Future<List<model.Voucher>> getAvailableVouchers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vouchers);
      final List<dynamic> data = response.data;
      return data.map((e) => model.Voucher.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy voucher đã thu thập của user
  Future<List<model.Voucher>> getMyVouchers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userVouchers);
      final List<dynamic> data = response.data;
      return data.map((e) => model.Voucher.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy voucher có thể áp dụng cho cartItems
  /// Server sẽ lọc ra các voucher phù hợp với sản phẩm/danh mục trong giỏ
  Future<List<model.Voucher>> getApplicableVouchers(List<Map<String, dynamic>> cartItems) async {
    try {
      final response = await _apiClient.post(
        '/user/my-applicable-vouchers',
        data: {'cartItems': cartItems},
      );
      final List<dynamic> data = response.data;
      return data.map((e) => model.Voucher.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy danh sách voucher của sản phẩm
  Future<List<model.Voucher>> getVouchersForProduct(int sanPhamId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.vouchers}/product/$sanPhamId',
      );
      final List<dynamic> data = response.data;
      return data.map((e) => model.Voucher.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw ApiException.fromDioException(e);
    }
  }

  /// Thu thập voucher
  Future<String> collectVoucher(String maKhuyenMai) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.collectVoucher,
        data: {'MaKhuyenMai': maKhuyenMai},
      );
      return response.data['message'] ?? 'Đã thu thập mã giảm giá';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Áp dụng voucher vào đơn hàng
  Future<VoucherApplyResponse> applyVoucher({
    required String maKhuyenMai,
    required double tongTienDonHang,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.vouchers}/apply',
        data: {'maKhuyenMai': maKhuyenMai, 'tongTienDonHang': tongTienDonHang},
      );
      return VoucherApplyResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Response khi áp dụng voucher
class VoucherApplyResponse {
  final bool success;
  final String message;
  final double giaTriGiam;
  final double tongTienSauGiam;
  final model.Voucher? voucher;

  VoucherApplyResponse({
    required this.success,
    required this.message,
    required this.giaTriGiam,
    required this.tongTienSauGiam,
    this.voucher,
  });

  factory VoucherApplyResponse.fromJson(Map<String, dynamic> json) {
    return VoucherApplyResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      giaTriGiam: _parseDouble(json['giaTriGiam'] ?? json['discount']),
      tongTienSauGiam: _parseDouble(
        json['tongTienSauGiam'] ?? json['finalTotal'],
      ),
      voucher: json['voucher'] != null
          ? model.Voucher.fromJson(json['voucher'])
          : null,
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
