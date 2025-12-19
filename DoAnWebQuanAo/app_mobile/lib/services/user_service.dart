import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/user.dart';
import 'package:dio/dio.dart';

/// User Service - Quản lý thông tin người dùng
///
/// Các chức năng: lấy profile, cập nhật profile
class UserService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  /// Lấy thông tin profile người dùng
  Future<User> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Cập nhật thông tin profile
  Future<bool> updateProfile({
    String? hoTen,
    String? dienThoai,
    String? diaChi,
    DateTime? ngaySinh,
    String? gioiTinh,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.userProfile,
        data: {
          if (hoTen != null) 'HoTen': hoTen,
          if (dienThoai != null) 'DienThoai': dienThoai,
          if (diaChi != null) 'DiaChi': diaChi,
          if (ngaySinh != null) 'NgaySinh': ngaySinh.toIso8601String(),
          if (gioiTinh != null) 'GioiTinh': gioiTinh,
        },
      );
      return true;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
