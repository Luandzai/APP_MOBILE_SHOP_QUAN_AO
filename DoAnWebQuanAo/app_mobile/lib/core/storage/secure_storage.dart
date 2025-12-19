import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage wrapper cho lưu trữ an toàn
/// 
/// Sử dụng để lưu token và các thông tin nhạy cảm.
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Singleton
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  // ============ TOKEN ============
  
  /// Lưu token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lấy token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Xóa token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Kiểm tra có token không
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ============ USER DATA ============
  
  /// Lưu user data (JSON string)
  Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Lấy user data
  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  /// Xóa user data
  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  // ============ CLEAR ALL ============
  
  /// Xóa tất cả dữ liệu (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
