import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/return_request.dart';

/// Service xử lý yêu cầu hoàn trả
class ReturnService {
  final ApiClient _apiClient = ApiClient();

  static final ReturnService _instance = ReturnService._internal();
  factory ReturnService() => _instance;
  ReturnService._internal();

  /// Lấy danh sách yêu cầu hoàn trả của user
  Future<List<ReturnRequest>> getMyReturnRequests() async {
    // Đúng endpoint: /user/returns (không phải /returns - đó là admin)
    final response = await _apiClient.get(ApiEndpoints.userReturns);
    
    if (response.data is List) {
      return (response.data as List)
          .map((e) => ReturnRequest.fromJson(e))
          .toList();
    }
    
    final data = response.data['data'] ?? response.data['returns'] ?? [];
    return (data as List).map((e) => ReturnRequest.fromJson(e)).toList();
  }

  /// Lấy chi tiết yêu cầu hoàn trả
  Future<ReturnRequest> getReturnRequestDetail(int returnId) async {
    final response = await _apiClient.get('${ApiEndpoints.returns}/$returnId');
    return ReturnRequest.fromJson(response.data);
  }

  /// Tạo yêu cầu hoàn trả mới
  Future<ReturnRequest> createReturnRequest({
    required int donHangId,
    required String lyDoHoanTra,
    required List<Map<String, dynamic>> sanPhamHoanTra,
    List<String>? hinhAnh,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.createReturn.replaceAll(':orderId', donHangId.toString()),
      data: {
        'lyDoHoanTra': lyDoHoanTra,
        'sanPhamHoanTra': sanPhamHoanTra,
        if (hinhAnh != null && hinhAnh.isNotEmpty) 'hinhAnh': hinhAnh,
      },
    );
    return ReturnRequest.fromJson(response.data);
  }

  /// Hủy yêu cầu hoàn trả
  Future<bool> cancelReturnRequest(int returnId) async {
    await _apiClient.delete('${ApiEndpoints.returns}/$returnId');
    return true;
  }

  /// Upload hình ảnh cho yêu cầu hoàn trả
  Future<List<String>> uploadReturnImages(List<String> imagePaths) async {
    // TODO: Implement multipart upload
    // Tạm thời return empty list
    return [];
  }

  /// Kiểm tra đơn hàng có thể hoàn trả không
  Future<bool> canRequestReturn(int orderId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.orders}/$orderId/can-return',
      );
      return response.data['canReturn'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Lấy lý do hoàn trả phổ biến
  List<String> getReturnReasons() {
    return [
      'Sản phẩm không đúng mô tả',
      'Sản phẩm bị lỗi/hư hỏng',
      'Sai kích cỡ/màu sắc',
      'Không còn nhu cầu',
      'Giao hàng sai sản phẩm',
      'Chất lượng không như mong đợi',
      'Khác',
    ];
  }
}
