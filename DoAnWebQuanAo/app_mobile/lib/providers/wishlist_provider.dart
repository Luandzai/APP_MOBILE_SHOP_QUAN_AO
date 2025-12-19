import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../core/network/api_exception.dart';

/// Wishlist Provider - Quản lý sản phẩm yêu thích
class WishlistProvider extends ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();

  // State
  List<Product> _wishlist = [];
  Set<int> _wishlistIds = {}; // Để check nhanh
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  List<Product> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get count => _wishlist.length;
  bool get isEmpty => _wishlist.isEmpty;

  /// Kiểm tra sản phẩm có trong wishlist không
  bool isInWishlist(int sanPhamId) => _wishlistIds.contains(sanPhamId);

  /// Lấy danh sách yêu thích
  Future<void> loadWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wishlist = await _wishlistService.getWishlist();
      _wishlistIds = _wishlist.map((p) => p.id).toSet();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Không thể tải danh sách yêu thích';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle yêu thích
  Future<bool> toggleWishlist(int sanPhamId, {Product? product}) async {
    final wasInWishlist = isInWishlist(sanPhamId);
    
    // Optimistic update
    if (wasInWishlist) {
      _wishlistIds.remove(sanPhamId);
      _wishlist.removeWhere((p) => p.id == sanPhamId);
    } else {
      _wishlistIds.add(sanPhamId);
      if (product != null) {
        _wishlist.insert(0, product);
      }
    }
    notifyListeners();

    try {
      if (wasInWishlist) {
        // Remove
        await _wishlistService.removeFromWishlist(sanPhamId);
        _successMessage = 'Đã xóa khỏi yêu thích';
      } else {
        // Add
        await _wishlistService.addToWishlist(sanPhamId);
        _successMessage = 'Đã thêm vào yêu thích';
      }
      
      return true;
    } on ApiException catch (e) {
      // Rollback
      if (wasInWishlist) {
        _wishlistIds.add(sanPhamId);
        if (product != null) {
          _wishlist.insert(0, product);
        }
      } else {
        _wishlistIds.remove(sanPhamId);
        _wishlist.removeWhere((p) => p.id == sanPhamId);
      }
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      // Rollback
      if (wasInWishlist) {
        _wishlistIds.add(sanPhamId);
      } else {
        _wishlistIds.remove(sanPhamId);
      }
      _error = 'Đã có lỗi xảy ra';
      notifyListeners();
      return false;
    }
  }

  /// Thêm vào wishlist
  Future<bool> addToWishlist(int sanPhamId, {Product? product}) async {
    if (isInWishlist(sanPhamId)) return true;
    return toggleWishlist(sanPhamId, product: product);
  }

  /// Xóa khỏi wishlist
  Future<bool> removeFromWishlist(int sanPhamId) async {
    if (!isInWishlist(sanPhamId)) return true;
    return toggleWishlist(sanPhamId);
  }

  /// Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
