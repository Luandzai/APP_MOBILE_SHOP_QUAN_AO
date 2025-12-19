import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/review.dart';

/// Service xử lý đánh giá sản phẩm
class ReviewService {
  final ApiClient _apiClient = ApiClient();

  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  /// Lấy danh sách đánh giá của sản phẩm
  Future<List<Review>> getProductReviews(
    int sanPhamId, {
    int page = 1,
    int limit = 10,
    int? filterByStar,
  }) async {
    String url = '${ApiEndpoints.reviews}?sanPhamId=$sanPhamId&page=$page&limit=$limit';
    if (filterByStar != null) {
      url += '&soSao=$filterByStar';
    }
    
    final response = await _apiClient.get(url);
    
    if (response.data is List) {
      return (response.data as List)
          .map((e) => Review.fromJson(e))
          .toList();
    }
    
    final data = response.data['reviews'] ?? response.data['data'] ?? [];
    return (data as List).map((e) => Review.fromJson(e)).toList();
  }

  /// Lấy thống kê đánh giá sản phẩm
  Future<ReviewStats> getProductReviewStats(int sanPhamId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.reviews}/stats?sanPhamId=$sanPhamId',
    );
    return ReviewStats.fromJson(response.data);
  }

  /// Kiểm tra user đã đánh giá phiên bản sản phẩm chưa
  Future<Review?> getMyReview(int phienBanId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.myReview}/$phienBanId',
      );
      return Review.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  /// Tạo đánh giá mới
  Future<Review> createReview({
    required int sanPhamId,
    required int phienBanId,
    required int soSao,
    String? noiDung,
    List<String>? hinhAnh,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.reviews,
      data: {
        'SanPhamID': sanPhamId,
        'PhienBanID': phienBanId,
        'SoSao': soSao,
        if (noiDung != null && noiDung.isNotEmpty) 'NoiDung': noiDung,
        if (hinhAnh != null && hinhAnh.isNotEmpty) 'HinhAnh': hinhAnh,
      },
    );
    return Review.fromJson(response.data);
  }

  /// Cập nhật đánh giá
  Future<Review> updateReview(
    int reviewId, {
    int? soSao,
    String? noiDung,
    List<String>? hinhAnh,
  }) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.reviews}/$reviewId',
      data: {
        if (soSao != null) 'SoSao': soSao,
        if (noiDung != null) 'NoiDung': noiDung,
        if (hinhAnh != null) 'HinhAnh': hinhAnh,
      },
    );
    return Review.fromJson(response.data);
  }

  /// Xóa đánh giá
  Future<bool> deleteReview(int reviewId) async {
    await _apiClient.delete('${ApiEndpoints.reviews}/$reviewId');
    return true;
  }

  /// Upload hình ảnh đánh giá
  Future<List<String>> uploadReviewImages(List<String> imagePaths) async {
    // TODO: Implement multipart upload
    return [];
  }

  /// Kiểm tra user có thể đánh giá phiên bản này không
  Future<bool> canReview(int phienBanId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.reviews}/can-review/$phienBanId',
      );
      return response.data['canReview'] == true;
    } catch (_) {
      return false;
    }
  }
}
