import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/cart_item.dart';

/// Cart Service - Quản lý giỏ hàng
class CartService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  /// Lấy giỏ hàng
  Future<CartResponse> getCart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cart);

      // Server trả về List<dynamic> (danh sách items) thay vì Object
      if (response.data is List) {
        final List<dynamic> listData = response.data;
        final items = listData.map((e) => CartItem.fromJson(e)).toList();

        // Tính toán tổng tiền và số lượng từ client
        double tongTien = 0;
        int soLuong = 0;
        for (var item in items) {
          if (item.daChon) {
            tongTien += item.thanhTien;
          }
          soLuong += item.soLuong;
        }

        return CartResponse(items: items, tongTien: tongTien, soLuong: soLuong);
      }

      // Fallback nếu server trả về Object (trường hợp API thay đổi tương lai)
      return CartResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Nếu 404, có thể do chưa có giỏ hàng, trả về rỗng
        return CartResponse(items: [], tongTien: 0, soLuong: 0);
      }
      throw ApiException.fromDioException(e);
    }
  }

  /// Thêm sản phẩm vào giỏ
  ///
  /// [phienBanId] ID phiên bản sản phẩm
  /// [soLuong] Số lượng thêm
  Future<String> addToCart({
    required int phienBanId,
    required int soLuong,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.cart,
        data: {
          'PhienBanID': phienBanId,
          'phienBanId': phienBanId, // Fallback
          'SoLuong': soLuong,
          'soLuong': soLuong, // Fallback
        },
      );
      return response.data['message'] ?? 'Đã thêm vào giỏ hàng';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Cập nhật số lượng sản phẩm trong giỏ
  Future<String> updateQuantity({
    required int gioHangId,
    required int soLuong,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.cart,
        data: {
          'PhienBanID': gioHangId,
          'phienBanId': gioHangId,
          'SoLuong': soLuong,
          'soLuong': soLuong,
        },
      );
      return response.data['message'] ?? 'Đã cập nhật';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Xóa sản phẩm khỏi giỏ
  Future<String> removeFromCart(int gioHangId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.cart}/$gioHangId',
      );
      return response.data['message'] ?? 'Đã xóa khỏi giỏ hàng';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Xóa nhiều sản phẩm
  Future<String> removeMultiple(List<int> gioHangIds) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.cart}/bulk',
        data: {'ids': gioHangIds},
      );
      return response.data['message'] ?? 'Đã xóa';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Xóa toàn bộ giỏ hàng
  Future<String> clearCart() async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.cart}/clear');
      return response.data['message'] ?? 'Đã xóa giỏ hàng';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Response cho giỏ hàng
class CartResponse {
  final List<CartItem> items;
  final double tongTien;
  final int soLuong;

  CartResponse({
    required this.items,
    required this.tongTien,
    required this.soLuong,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e))
              .toList() ??
          [],
      tongTien: _parseDouble(json['tongTien'] ?? json['total']),
      soLuong: json['soLuong'] ?? json['count'] ?? 0,
    );
  }

  bool get isEmpty => items.isEmpty;

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
