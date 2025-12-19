import 'package:flutter/foundation.dart';
import '../models/voucher.dart' as model;
import '../services/voucher_service.dart';
import '../core/network/api_exception.dart';

/// Voucher Provider - Quản lý mã khuyến mãi
class VoucherProvider extends ChangeNotifier {
  final VoucherService _voucherService = VoucherService();

  // State
  List<model.Voucher> _availableVouchers = []; // Voucher có thể thu thập
  List<model.Voucher> _myVouchers = []; // Voucher đã thu thập
  model.Voucher? _appliedVoucher; // Voucher đang áp dụng
  double _discountAmount = 0; // Số tiền giảm
  bool _isLoading = false;
  bool _isApplying = false;
  String? _error;
  String? _successMessage;

  // Getters
  List<model.Voucher> get availableVouchers => _availableVouchers;
  List<model.Voucher> get myVouchers => _myVouchers;
  model.Voucher? get appliedVoucher => _appliedVoucher;
  double get discountAmount => _discountAmount;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  String? get error => _error;
  String? get successMessage => _successMessage;
  bool get hasAppliedVoucher => _appliedVoucher != null;

  /// Lấy danh sách voucher có thể thu thập
  Future<void> loadAvailableVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availableVouchers = await _voucherService.getAvailableVouchers();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải mã giảm giá';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách voucher đã thu thập
  Future<void> loadMyVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myVouchers = await _voucherService.getMyVouchers();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải mã giảm giá';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách voucher có thể áp dụng cho sản phẩm trong giỏ
  Future<void> loadApplicableVouchers(List<Map<String, dynamic>> cartItems) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myVouchers = await _voucherService.getApplicableVouchers(cartItems);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải mã giảm giá';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Thu thập voucher
  Future<bool> collectVoucher(String maKhuyenMai) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final message = await _voucherService.collectVoucher(maKhuyenMai);
      _successMessage = message;

      // Cập nhật trạng thái voucher (nếu có trong list available)
      final index = _availableVouchers.indexWhere(
        (v) => v.maKhuyenMai == maKhuyenMai,
      );
      if (index != -1) {
        await loadMyVouchers();
      }

      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Không thể thu thập mã giảm giá';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Áp dụng voucher
  Future<bool> applyVoucher({
    required String maKhuyenMai,
    required double tongTienDonHang,
  }) async {
    _isApplying = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _voucherService.applyVoucher(
        maKhuyenMai: maKhuyenMai,
        tongTienDonHang: tongTienDonHang,
      );

      if (response.success) {
        _appliedVoucher = response.voucher;
        _discountAmount = response.giaTriGiam;
        _successMessage = response.message;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Không thể áp dụng mã giảm giá';
      notifyListeners();
      return false;
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }

  /// Hủy áp dụng voucher
  void removeAppliedVoucher() {
    _appliedVoucher = null;
    _discountAmount = 0;
    notifyListeners();
  }

  /// Chọn voucher từ danh sách (manual client-side calculation if needed)
  void selectVoucher(model.Voucher voucher, double orderTotal) {
    _appliedVoucher = voucher;
    _discountAmount = voucher.calculateDiscount(orderTotal);
    debugPrint('VoucherProvider.selectVoucher: Applied ${voucher.maKhuyenMai}, discount: $_discountAmount');
    notifyListeners();
  }

  /// Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Reset state (sau khi đặt hàng)
  void reset() {
    _appliedVoucher = null;
    _discountAmount = 0;
    notifyListeners();
  }
}
