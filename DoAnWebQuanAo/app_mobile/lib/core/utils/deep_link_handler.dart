import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import '../../router/app_router.dart';

/// Deep Link Handler - Xử lý deep links từ VNPAY/MoMo
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  BuildContext? _context;

  /// Khởi tạo handler
  Future<void> init(BuildContext context) async {
    _context = context;
    _appLinks = AppLinks();

    // Handle app launch from deep link
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Listen for deep links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handleDeepLink(uri),
      onError: (err) => debugPrint('Deep link error: $err'),
    );
  }

  /// Xử lý deep link
  void _handleDeepLink(Uri uri) {
    debugPrint('Received deep link: $uri');

    // blankcanvas://payment-result?success=true&orderId=123
    // blankcanvas://momo-result?status=0&orderId=123

    if (_context == null) return;

    switch (uri.host) {
      case 'payment-result':
        _handlePaymentResult(uri);
        break;
      case 'momo-result':
        _handleMomoResult(uri);
        break;
      default:
        debugPrint('Unknown deep link host: ${uri.host}');
    }
  }

  /// Xử lý kết quả VNPAY
  void _handlePaymentResult(Uri uri) {
    final params = uri.queryParameters;

    // VNPAY response params
    final vnpResponseCode = params['vnp_ResponseCode'];
    final vnpTxnRef = params['vnp_TxnRef'];

    // Custom params
    final success = params['success'] == 'true' || vnpResponseCode == '00';
    final orderId = params['orderId'] ?? vnpTxnRef;
    final message = params['message'] ?? _getVnpayMessage(vnpResponseCode);

    _navigateToPaymentResult(success, orderId, message);
  }

  /// Xử lý kết quả MoMo
  void _handleMomoResult(Uri uri) {
    final params = uri.queryParameters;

    // Backend MoMo return params: success=true/false, orderId=xxx
    final successParam = params['success'];
    final orderId = params['orderId'] ?? params['requestId'];
    final message = params['message'] ?? params['localMessage'];

    // Check success param from backend or MoMo status
    final status = params['status'] ?? params['errorCode'];
    final success = successParam == 'true' || status == '0';

    _navigateToPaymentResult(success, orderId, message);
  }

  /// Navigate đến PaymentResult screen
  void _navigateToPaymentResult(
    bool success,
    String? orderId,
    String? message,
  ) {
    if (_context == null) return;

    final queryParams = <String, String>{
      'success': success.toString(),
      if (orderId != null) 'orderId': orderId,
      if (message != null) 'message': message,
    };

    final query = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    _context!.go('${Routes.paymentResult}?$query');
  }

  /// Lấy message từ VNPAY response code
  String? _getVnpayMessage(String? responseCode) {
    switch (responseCode) {
      case '00':
        return 'Thanh toán thành công';
      case '07':
        return 'Trừ tiền thành công. Giao dịch bị nghi ngờ';
      case '09':
        return 'Thẻ/Tài khoản chưa đăng ký InternetBanking';
      case '10':
        return 'Xác thực thông tin thẻ/tài khoản không đúng quá 3 lần';
      case '11':
        return 'Đã hết hạn chờ thanh toán';
      case '12':
        return 'Thẻ/Tài khoản bị khóa';
      case '13':
        return 'Mật khẩu OTP không chính xác';
      case '24':
        return 'Khách hàng hủy giao dịch';
      case '51':
        return 'Tài khoản không đủ số dư';
      case '65':
        return 'Tài khoản đã vượt quá hạn mức giao dịch trong ngày';
      case '75':
        return 'Ngân hàng thanh toán đang bảo trì';
      case '79':
        return 'Nhập sai mật khẩu quá số lần quy định';
      case '99':
        return 'Lỗi không xác định';
      default:
        return null;
    }
  }

  /// Hủy subscription
  void dispose() {
    _linkSubscription?.cancel();
  }
}

/// Singleton instance
final deepLinkHandler = DeepLinkHandler();
