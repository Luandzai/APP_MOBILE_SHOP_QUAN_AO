/// Các chuỗi văn bản tiếng Việt trong ứng dụng
///
/// Tập trung tất cả text để dễ bảo trì và hỗ trợ đa ngôn ngữ sau này.
class AppStrings {
  AppStrings._();

  // ============ APP ============
  static const String appName = 'Blank Canvas';
  static const String vouchers = 'Mã giảm giá';
  static const String appSlogan = 'Thời trang của bạn';

  // ============ AUTH ============
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String logout = 'Đăng xuất';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String confirmPassword = 'Xác nhận mật khẩu';
  static const String fullName = 'Họ và tên';
  static const String phoneNumber = 'Số điện thoại';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String resetPassword = 'Đặt lại mật khẩu';
  static const String noAccount = 'Chưa có tài khoản?';
  static const String haveAccount = 'Đã có tài khoản?';
  static const String loginWithGoogle = 'Đăng nhập với Google';
  static const String sendResetLink = 'Gửi link đặt lại';

  // ============ HOME ============
  static const String home = 'Trang chủ';
  static const String bestSelling = 'Sản phẩm bán chạy 🔥';
  static const String newArrivals = 'Sản phẩm mới nhất ⚡';
  static const String categories = 'Danh mục';
  static const String seeAll = 'Xem tất cả';

  // ============ PRODUCTS ============
  static const String products = 'Sản phẩm';
  static const String productDetail = 'Chi tiết sản phẩm';
  static const String addToCart = 'Thêm vào giỏ';
  static const String buyNow = 'Mua ngay';
  static const String outOfStock = 'Hết hàng';
  static const String inStock = 'Còn hàng';
  static const String quantity = 'Số lượng';
  static const String selectColor = 'Chọn màu';
  static const String selectSize = 'Chọn size';
  static const String description = 'Mô tả chi tiết';
  static const String reviews = 'Đánh giá';
  static const String relatedProducts = 'Có thể bạn sẽ thích';
  static const String sizeGuide = 'Hướng dẫn chọn size';
  static const String noProductsFound = 'Không tìm thấy sản phẩm';
  static const String sold = 'Đã bán';

  // ============ FILTER & SORT ============
  static const String filter = 'Lọc';
  static const String sort = 'Sắp xếp';
  static const String apply = 'Áp dụng';
  static const String reset = 'Đặt lại';
  static const String priceRange = 'Khoảng giá';
  static const String sortNewest = 'Mới nhất';
  static const String sortPriceLowHigh = 'Giá tăng dần';
  static const String sortPriceHighLow = 'Giá giảm dần';
  static const String sortBestSelling = 'Bán chạy nhất';

  // ============ CART ============
  static const String cart = 'Giỏ hàng';
  static const String emptyCart = 'Giỏ hàng trống';
  static const String emptyCartMessage =
      'Bạn chưa có sản phẩm nào trong giỏ hàng.';
  static const String continueShopping = 'Tiếp tục mua sắm';
  static const String selectAll = 'Chọn tất cả';
  static const String subtotal = 'Tạm tính';
  static const String total = 'Tổng cộng';
  static const String checkout = 'Tiến hành đặt hàng';
  static const String removeFromCart = 'Xóa khỏi giỏ';

  // ============ CHECKOUT ============
  static const String orderSummary = 'Tóm tắt đơn hàng';
  static const String shippingInfo = 'Thông tin giao hàng';
  static const String paymentMethod = 'Phương thức thanh toán';
  static const String shippingMethod = 'Phương thức vận chuyển';
  static const String address = 'Địa chỉ';
  static const String province = 'Tỉnh/Thành phố';
  static const String district = 'Quận/Huyện';
  static const String ward = 'Phường/Xã';
  static const String notes = 'Ghi chú';
  static const String shippingFee = 'Phí vận chuyển';
  static const String discount = 'Giảm giá';
  static const String placeOrder = 'Hoàn tất đặt hàng';
  static const String cod = 'Thanh toán khi nhận hàng (COD)';
  static const String vnpay = 'Thanh toán VNPAY';
  static const String momo = 'Thanh toán MoMo';

  // ============ VOUCHER ============
  static const String voucher = 'Mã giảm giá';
  static const String myVouchers = 'Mã của tôi';
  static const String collectVoucher = 'Thu thập';
  static const String collected = 'Đã thu thập';
  static const String applyVoucher = 'Áp dụng';
  static const String selectVoucher = 'Chọn mã giảm giá';
  static const String noVouchers = 'Không có mã giảm giá';
  static const String minOrderValue = 'Đơn tối thiểu';
  static const String expiresOn = 'Hết hạn';

  // ============ ORDERS ============
  static const String orders = 'Đơn hàng';
  static const String myOrders = 'Đơn hàng của tôi';
  static const String orderDetail = 'Chi tiết đơn hàng';
  static const String orderCode = 'Mã đơn hàng';
  static const String orderDate = 'Ngày đặt';
  static const String orderStatus = 'Trạng thái';
  static const String cancelOrder = 'Hủy đơn';
  static const String retryPayment = 'Thanh toán lại';
  static const String noOrders = 'Bạn chưa có đơn hàng nào';

  // Order Status
  static const String statusPending = 'Chờ xác nhận';
  static const String statusConfirmed = 'Đã xác nhận';
  static const String statusShipping = 'Đang giao';
  static const String statusDelivered = 'Đã giao';
  static const String statusCancelled = 'Đã hủy';
  static const String statusUnpaid = 'Chưa thanh toán';
  static const String statusPaid = 'Đã thanh toán';

  // ============ PROFILE ============
  static const String profile = 'Tài khoản';
  static const String editProfile = 'Cập nhật tài khoản';
  static const String wishlist = 'Yêu thích';
  static const String emptyWishlist = 'Danh sách yêu thích trống';
  static const String emptyWishlistMessage = 
      'Hãy thêm những sản phẩm bạn yêu thích vào đây để mua sắm dễ dàng hơn';
  static const String returnRequests = 'Yêu cầu đổi trả';
  static const String dateOfBirth = 'Ngày sinh';
  static const String gender = 'Giới tính';
  static const String saveChanges = 'Lưu thay đổi';
  static const String noWishlist = 'Chưa có sản phẩm yêu thích';

  // ============ RETURNS ============
  static const String requestReturn = 'Yêu cầu đổi trả';
  static const String returnReason = 'Lý do';
  static const String returnDescription = 'Mô tả chi tiết';
  static const String submitRequest = 'Gửi yêu cầu';
  static const String noReturns = 'Không có yêu cầu đổi trả';

  // ============ CHAT ============
  static const String chatbot = 'Trợ lý ảo';
  static const String typeMessage = 'Nhập tin nhắn...';

  // ============ SEARCH ============
  static const String search = 'Tìm kiếm';
  static const String searchHint = 'Tìm kiếm sản phẩm...';
  static const String recentSearches = 'Tìm kiếm gần đây';
  static const String clearAll = 'Xóa tất cả';
  static const String noResults = 'Không tìm thấy kết quả';

  // ============ COMMON ============
  static const String loading = 'Đang tải...';
  static const String error = 'Có lỗi xảy ra';
  static const String retry = 'Thử lại';
  static const String cancel = 'Hủy';
  static const String confirm = 'Xác nhận';
  static const String save = 'Lưu';
  static const String delete = 'Xóa';
  static const String edit = 'Sửa';
  static const String close = 'Đóng';
  static const String back = 'Quay lại';
  static const String success = 'Thành công';
  static const String vnd = '₫';

  // ============ VALIDATION ============
  static const String required = 'Trường này là bắt buộc';
  static const String invalidEmail = 'Email không hợp lệ';
  static const String invalidPhone = 'Số điện thoại không hợp lệ';
  static const String passwordTooShort = 'Mật khẩu phải có ít nhất 6 ký tự';
  static const String passwordNotMatch = 'Mật khẩu không khớp';

  // ============ PAYMENT RESULT ============
  static const String paymentSuccess = 'Đặt hàng thành công!';
  static const String paymentFailed = 'Thanh toán thất bại';
  static const String paymentSuccessMessage =
      'Cảm ơn bạn đã mua hàng. Đơn hàng đang được xử lý.';
  static const String paymentFailedMessage =
      'Đã có lỗi xảy ra. Vui lòng thử lại.';
  static const String goToHome = 'Về trang chủ';
  static const String viewOrder = 'Xem đơn hàng';
}
