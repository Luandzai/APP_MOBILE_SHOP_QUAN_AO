import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/user.dart';

/// Auth Service - Xử lý authentication
/// 
/// Các chức năng: đăng nhập, đăng ký, Google login, quên/reset mật khẩu
class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Đăng nhập bằng email và mật khẩu
  /// 
  /// Returns [AuthResponse] chứa token và user info
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'Email': email,
          'MatKhau': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Đăng ký tài khoản mới
  /// 
  /// Returns message thành công
  Future<String> register({
    required String hoTen,
    required String email,
    required String password,
    String? soDienThoai,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'HoTen': hoTen,
          'Email': email,
          'MatKhau': password,
          if (soDienThoai != null) 'SoDienThoai': soDienThoai,
        },
      );

      return response.data['message'] ?? 'Đăng ký thành công!';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Đăng nhập bằng Google
  /// 
  /// [googleToken] là credential token từ Google Sign-In
  Future<AuthResponse> googleLogin({
    required String googleToken,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.googleLogin,
        data: {
          'token': googleToken,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Gửi email quên mật khẩu
  Future<String> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': email,
        },
      );

      return response.data['message'] ?? 'Đã gửi email đặt lại mật khẩu!';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Reset mật khẩu với token
  /// 
  /// [token] là token từ email reset password
  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.resetPassword}/$token',
        data: {
          'password': newPassword,
        },
      );

      return response.data['message'] ?? 'Đặt lại mật khẩu thành công!';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
