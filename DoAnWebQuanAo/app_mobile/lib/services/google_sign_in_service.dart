import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Google Sign-In Service
///
/// Xử lý việc đăng nhập bằng Google và lấy ID token
class GoogleSignInService {
  // Singleton
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  // Google Sign In instance
  // Phải config với Web Client ID (không phải Android Client ID)
  // Web Client ID lấy từ Google Cloud Console - cùng với GOOGLE_CLIENT_ID trong backend .env
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // ⚠️ QUAN TRỌNG: Thay bằng Web Client ID thật của bạn (lấy từ Google Cloud Console)
    // Phải giống với GOOGLE_CLIENT_ID trong file .env của server
    serverClientId:
        '951910480760-6f76pdqjc1fgb3uiq05ci69dn5ic7agg.apps.googleusercontent.com',
  );

  /// Đăng nhập với Google và trả về ID Token
  ///
  /// Returns ID token nếu thành công, null nếu user cancel hoặc có lỗi
  Future<String?> signIn() async {
    try {
      // Sign out trước để luôn hiển thị account picker
      await _googleSignIn.signOut();

      // Sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled
        debugPrint('Google Sign-In: User cancelled');
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication auth = await account.authentication;

      // Trả về ID token để gửi cho backend
      final idToken = auth.idToken;

      if (idToken == null) {
        debugPrint('Google Sign-In: No ID token received');
        return null;
      }

      debugPrint('Google Sign-In: Success - ${account.email}');
      return idToken;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Sign out khỏi Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out Error: $e');
    }
  }

  /// Kiểm tra đã đăng nhập Google chưa
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }

  /// Lấy thông tin tài khoản Google hiện tại (nếu có)
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
