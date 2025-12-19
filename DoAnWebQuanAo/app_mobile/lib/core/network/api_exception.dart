import 'package:dio/dio.dart';

/// Custom exception cho API errors
/// 
/// Giúp parse và hiển thị lỗi thân thiện với người dùng.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  /// Factory constructor từ DioException
  factory ApiException.fromDioException(DioException error) {
    String message;
    int? statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Kết nối quá thời gian. Vui lòng kiểm tra mạng.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Gửi request quá thời gian. Vui lòng thử lại.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Không nhận được phản hồi từ server.';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(error.response);
        break;
      case DioExceptionType.cancel:
        message = 'Request đã bị hủy.';
        break;
      case DioExceptionType.connectionError:
        message = 'Không thể kết nối đến server. Vui lòng kiểm tra mạng.';
        break;
      case DioExceptionType.unknown:
      default:
        message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: error.response?.data,
    );
  }

  /// Parse error message từ response
  static String _handleBadResponse(Response? response) {
    if (response == null) return 'Lỗi không xác định';

    // Lấy message từ response body (format backend)
    final data = response.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    // Default message theo status code
    switch (response.statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ';
      case 401:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền thực hiện hành động này';
      case 404:
        return 'Không tìm thấy dữ liệu';
      case 409:
        return 'Dữ liệu đã tồn tại';
      case 422:
        return 'Dữ liệu không hợp lệ';
      case 500:
        return 'Lỗi hệ thống. Vui lòng thử lại sau.';
      default:
        return 'Đã có lỗi xảy ra (${response.statusCode})';
    }
  }

  @override
  String toString() => message;
}
