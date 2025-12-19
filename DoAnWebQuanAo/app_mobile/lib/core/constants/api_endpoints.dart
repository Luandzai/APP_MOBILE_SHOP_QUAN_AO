/// API Endpoints cho ứng dụng Blank Canvas
///
/// File này chứa tất cả các endpoint API được sử dụng trong ứng dụng
/// để đảm bảo tính nhất quán và dễ bảo trì.

class ApiEndpoints {
  // Base URL - thay đổi theo môi trường
  // Android Emulator: 10.0.2.2
  // iOS Simulator: localhost
  // Real device: IP máy chủ thật
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // ============ AUTH ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleLogin = '/auth/google';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password'; // + /:token

  // ============ PRODUCTS ============
  static const String products = '/products';
  static const String productBySlug = '/products'; // + /:slug
  static const String bestSellingProducts = '/products/bestselling';
  static const String newestProducts = '/products/newest';

  // ============ CATEGORIES ============
  static const String categories = '/categories';

  // ============ ATTRIBUTES ============
  static const String attributes = '/attributes';

  // ============ CART ============
  static const String cart = '/cart';
  // DELETE: /cart/:phienBanId

  // ============ ORDERS ============
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String cancelOrder = '/orders/:id/cancel';
  static const String confirmDelivery = '/orders/:id/confirm-delivery';
  static const String retryPayment = '/orders/:id/retry-payment';
  static const String orderCounts = '/orders/counts';

  // ============ USER ============
  static const String userProfile = '/user/profile';
  static const String userWishlist = '/user/wishlist';
  static const String userVouchers = '/user/my-vouchers';
  static const String userApplicableVouchers = '/user/my-applicable-vouchers';
  static const String userReturns = '/user/returns';

  // ============ REVIEWS ============
  static const String reviews = '/reviews';
  static const String myReview = '/reviews/my-review'; // + /:phienBanId

  // ============ VOUCHERS ============
  static const String vouchers = '/vouchers';
  static const String vouchersForProduct = '/vouchers/product'; // + /:sanPhamId
  static const String collectVoucher = '/vouchers/collect';
  static const String applyVoucher = '/vouchers/apply';

  // ============ WISHLIST ============
  static const String wishlist = '/wishlist';
  // DELETE: /wishlist/:sanPhamId

  // ============ RETURNS ============
  static const String returns = '/returns';
  static const String createReturn = '/orders/:orderId/return';

  // ============ LOCATIONS ============
  static const String provinces = '/locations/provinces';
  static const String districts = '/locations/districts';
  static const String wards = '/locations/wards';

  // ============ SHIPPING ============
  static const String shipping = '/shipping';
  
  // ============ ADDRESSES ============
  static const String savedAddresses = '/user/addresses';

  // ============ SIZE CHART ============
  static const String sizeChart = '/sizecharts'; // + /:danhMucId

  // ============ CHAT ============
  static const String chat = '/chat';

  // ============ CONTACT ============
  static const String contact = '/contact';
}

