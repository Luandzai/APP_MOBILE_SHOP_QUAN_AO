import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../core/storage/secure_storage.dart';
import '../core/network/api_exception.dart';

/// Enum trạng thái authentication
enum AuthStatus {
  initial,      // Chưa kiểm tra
  loading,      // Đang xử lý
  authenticated, // Đã đăng nhập
  unauthenticated, // Chưa đăng nhập
  error,        // Có lỗi
}

/// Auth Provider - Quản lý trạng thái authentication
/// 
/// Sử dụng với Provider để chia sẻ auth state trong toàn app.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final SecureStorage _storage = SecureStorage();

  // State
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;

  /// Kiểm tra trạng thái đăng nhập khi khởi động app
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final hasToken = await _storage.hasToken();
      
      if (hasToken) {
        // Có token, thử lấy profile để verify
        try {
          _user = await _userService.getProfile();
          _status = AuthStatus.authenticated;
        } catch (e) {
          // Token hết hạn hoặc không hợp lệ
          await _storage.clearAll();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  /// Đăng nhập
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      // Lưu token
      await _storage.saveToken(response.token);
      await _storage.saveUser(response.user.toJsonString());

      _user = response.user;
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Đã có lỗi xảy ra. Vui lòng thử lại.');
      return false;
    }
  }

  /// Đăng ký
  Future<bool> register({
    required String hoTen,
    required String email,
    required String password,
    String? soDienThoai,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(
        hoTen: hoTen,
        email: email,
        password: password,
        soDienThoai: soDienThoai,
      );

      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Đã có lỗi xảy ra. Vui lòng thử lại.');
      return false;
    }
  }

  /// Đăng nhập với Google
  Future<bool> googleLogin({
    required String googleToken,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.googleLogin(
        googleToken: googleToken,
      );

      // Lưu token
      await _storage.saveToken(response.token);
      await _storage.saveUser(response.user.toJsonString());

      _user = response.user;
      _status = AuthStatus.authenticated;
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Đăng nhập Google thất bại. Vui lòng thử lại.');
      return false;
    }
  }

  /// Quên mật khẩu
  Future<String?> forgotPassword({
    required String email,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final message = await _authService.forgotPassword(email: email);
      _setLoading(false);
      return message;
    } on ApiException catch (e) {
      _setError(e.message);
      return null;
    } catch (e) {
      _setError('Đã có lỗi xảy ra. Vui lòng thử lại.');
      return null;
    }
  }

  /// Reset mật khẩu
  Future<String?> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final message = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      _setLoading(false);
      return message;
    } on ApiException catch (e) {
      _setError(e.message);
      return null;
    } catch (e) {
      _setError('Đã có lỗi xảy ra. Vui lòng thử lại.');
      return null;
    }
  }

  /// Cập nhật profile
  Future<bool> updateProfile({
    String? hoTen,
    String? dienThoai,
    String? diaChi,
    DateTime? ngaySinh,
    String? gioiTinh,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Gọi API cập nhật
      await _userService.updateProfile(
        hoTen: hoTen,
        dienThoai: dienThoai,
        diaChi: diaChi,
        ngaySinh: ngaySinh,
        gioiTinh: gioiTinh,
      );
      
      // Server không trả về full info, nên ta update local state thủ công
      // Optimistic update
      if (_user != null) {
        _user = _user!.copyWith(
          hoTen: hoTen,
          dienThoai: dienThoai,
          diaChi: diaChi,
          ngaySinh: ngaySinh,
          gioiTinh: gioiTinh,
        );
        // Lưu lại vào storage
        await _storage.saveUser(_user!.toJsonString());
      }
      
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Đã có lỗi xảy ra. Vui lòng thử lại.');
      return false;
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    _setLoading(true);
    
    await _storage.clearAll();
    
    _user = null;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  /// Refresh user data từ server
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;
    
    try {
      _user = await _userService.getProfile();
      await _storage.saveUser(_user!.toJsonString());
      notifyListeners();
    } catch (e) {
      // Silent fail
      debugPrint('Failed to refresh user: $e');
    }
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _isLoading = false;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Clear error manually
  void clearError() {
    _error = null;
    if (_status == AuthStatus.error) {
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
