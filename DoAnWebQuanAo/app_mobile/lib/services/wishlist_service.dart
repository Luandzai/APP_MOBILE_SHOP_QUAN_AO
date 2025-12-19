import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/product.dart';

/// Wishlist Service - Quản lý sản phẩm yêu thích
class WishlistService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  /// Lấy danh sách yêu thích
  Future<List<Product>> getWishlist() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userWishlist);
      final List<dynamic> data = response.data;
      return data.map((e) => Product.fromJsonSimple(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Thêm sản phẩm vào wishlist
  Future<String> addToWishlist(int sanPhamId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.wishlist,
        data: {
          'SanPhamID': sanPhamId,
          'sanPhamId': sanPhamId, // Fallback
        },
      );
      return response.data['message'] ?? 'Đã thêm vào yêu thích';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Xóa sản phẩm khỏi wishlist
  Future<String> removeFromWishlist(int sanPhamId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.wishlist}/$sanPhamId',
      );
      return response.data['message'] ?? 'Đã xóa khỏi yêu thích';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Kiểm tra sản phẩm có trong wishlist không
  Future<bool> isInWishlist(int sanPhamId) async {
    try {
      // Server không có API check riêng, nên lấy danh sách về check local
      final wishlist = await getWishlist();
      return wishlist.any((product) => product.id == sanPhamId);
    } catch (e) {
      // Nếu lỗi thì mặc định là false để không chặn UI
      return false;
    }
  }
}

/// Response khi toggle wishlist
class WishlistToggleResponse {
  final bool isInWishlist;
  final String message;

  WishlistToggleResponse({required this.isInWishlist, required this.message});

  factory WishlistToggleResponse.fromJson(Map<String, dynamic> json) {
    return WishlistToggleResponse(
      isInWishlist: json['isInWishlist'] ?? json['added'] == true,
      message: json['message'] ?? '',
    );
  }
}
