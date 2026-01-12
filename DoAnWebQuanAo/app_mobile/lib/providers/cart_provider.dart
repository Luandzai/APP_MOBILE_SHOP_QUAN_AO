import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/product_variant.dart';
import '../services/cart_service.dart';
import '../core/network/api_exception.dart';

/// Cart Provider - Quản lý state giỏ hàng
class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  // State
  List<CartItem> _items = [];
  double _tongTien = 0;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  List<CartItem> get items => _items;
  double get tongTien => _tongTien;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.soLuong);
  bool get isEmpty => _items.isEmpty;

  /// Lấy các items đã chọn (chỉ lấy items còn hàng)
  List<CartItem> get selectedItems =>
      _items.where((item) => item.daChon && !item.isOutOfStock).toList();

  /// Tổng tiền các items đã chọn
  double get selectedTotal =>
      selectedItems.fold(0.0, (sum, item) => sum + item.thanhTien);

  /// Lấy giỏ hàng từ server
  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _cartService.getCart();
      // Auto deselect out of stock items
      _items = response.items.map((item) {
        if (item.isOutOfStock && item.daChon) {
          return item.copyWithSelected(false);
        }
        return item;
      }).toList();
      _tongTien = response.tongTien;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải giỏ hàng';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm sản phẩm vào giỏ
  Future<bool> addToCart({
    required Product product,
    required ProductVariant variant,
    required int quantity,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final message = await _cartService.addToCart(
        phienBanId: variant.id,
        soLuong: quantity,
      );

      _successMessage = message;

      // Reload cart để sync với server
      await loadCart();

      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Không thể thêm vào giỏ hàng';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cập nhật số lượng
  Future<bool> updateQuantity(int gioHangId, int newQuantity) async {
    if (newQuantity < 1) return false;

    // Optimistic update
    final index = _items.indexWhere((item) => item.id == gioHangId);
    if (index == -1) return false;

    final oldItem = _items[index];
    _items[index] = oldItem.copyWithQuantity(newQuantity);
    _recalculateTotal();
    notifyListeners();

    try {
      await _cartService.updateQuantity(
        gioHangId: gioHangId,
        soLuong: newQuantity,
      );
      return true;
    } on ApiException catch (e) {
      // Rollback on failure
      _items[index] = oldItem;
      _recalculateTotal();
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _items[index] = oldItem;
      _recalculateTotal();
      _error = 'Không thể cập nhật số lượng';
      notifyListeners();
      return false;
    }
  }

  /// Xóa sản phẩm khỏi giỏ
  Future<bool> removeFromCart(int gioHangId) async {
    final index = _items.indexWhere((item) => item.id == gioHangId);
    if (index == -1) return false;

    // Optimistic remove
    final removedItem = _items.removeAt(index);
    _recalculateTotal();
    notifyListeners();

    try {
      await _cartService.removeFromCart(gioHangId);
      return true;
    } on ApiException catch (e) {
      // Rollback on failure
      _items.insert(index, removedItem);
      _recalculateTotal();
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _items.insert(index, removedItem);
      _recalculateTotal();
      _error = 'Không thể xóa sản phẩm';
      notifyListeners();
      return false;
    }
  }

  /// Toggle chọn item
  void toggleItemSelection(int gioHangId) {
    final index = _items.indexWhere((item) => item.id == gioHangId);
    if (index == -1) return;

    // Không cho phép chọn nếu hết hàng
    if (_items[index].isOutOfStock) return;

    _items[index] = _items[index].copyWithSelected(!_items[index].daChon);
    notifyListeners();
  }

  /// Chọn/Bỏ chọn tất cả
  void toggleSelectAll() {
    // Chỉ tính các item còn hàng
    final availableItems = _items.where((item) => !item.isOutOfStock).toList();
    if (availableItems.isEmpty) return;

    final allSelected = availableItems.every((item) => item.daChon);

    _items = _items.map((item) {
      // Không thay đổi trạng thái của item hết hàng (luôn false)
      if (item.isOutOfStock) return item.copyWithSelected(false);
      return item.copyWithSelected(!allSelected);
    }).toList();
    notifyListeners();
  }

  /// Xóa các items đã chọn
  Future<void> removeSelectedItems() async {
    final selectedIds = selectedItems.map((item) => item.id).toList();
    if (selectedIds.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _cartService.removeMultiple(selectedIds);
      await loadCart();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể xóa các sản phẩm';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _cartService.clearCart();
      _items = [];
      _tongTien = 0;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể xóa giỏ hàng';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tính lại tổng tiền
  void _recalculateTotal() {
    _tongTien = _items.fold(0.0, (sum, item) => sum + item.thanhTien);
  }

  /// Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
