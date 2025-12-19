import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/voucher_service.dart';
import '../models/voucher.dart' as model; // Alias to avoid conflict
import '../core/network/api_exception.dart';

/// Product Provider - Quản lý state sản phẩm
class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  // State cho danh sách sản phẩm
  List<Product> _products = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalProducts = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Filter state
  String? _currentCategory;
  String? _currentPriceRange;
  String? _currentSort;
  String? _currentSearch;

  // State cho sản phẩm bán chạy và mới nhất
  List<Product> _bestSellingProducts = [];
  List<Product> _newestProducts = [];
  bool _isLoadingFeatured = false;

  // State cho chi tiết sản phẩm
  Product? _currentProduct;
  List<model.Voucher> _productVouchers = []; // Vouchers for current product
  bool _isLoadingDetail = false;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _totalPages;
  String? get error => _error;

  List<Product> get bestSellingProducts => _bestSellingProducts;
  List<Product> get newestProducts => _newestProducts;
  bool get isLoadingFeatured => _isLoadingFeatured;

  Product? get currentProduct => _currentProduct;
  List<model.Voucher> get productVouchers => _productVouchers;
  bool get isLoadingDetail => _isLoadingDetail;

  /// Lấy chi tiết sản phẩm
  Future<void> loadProductDetail(String slug) async {
    _isLoadingDetail = true;
    _error = null;
    notifyListeners();

    try {
      _currentProduct = await _productService.getProductBySlug(slug);

      // Load vouchers if product loaded successfully
      if (_currentProduct != null) {
        try {
          _productVouchers = await VoucherService().getVouchersForProduct(
            _currentProduct!.id,
          );
        } catch (e) {
          debugPrint('Error loading vouchers: $e');
          _productVouchers = [];
        }
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã có lỗi xảy ra';
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts({
    String? category,
    String? priceRange,
    String? sortBy,
    String? search,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    if (refresh) {
      _products = [];
      _currentPage = 1;
    }

    // Lưu filters
    _currentCategory = category;
    _currentPriceRange = priceRange;
    _currentSort = sortBy;
    _currentSearch = search;

    notifyListeners();

    try {
      final response = await _productService.getProducts(
        page: 1,
        danhMuc: category,
        khoangGia: priceRange,
        sortBy: sortBy,
        search: search,
      );

      _products = response.products;
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
      _totalProducts = response.totalProducts;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã có lỗi xảy ra';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tải thêm sản phẩm (infinite scroll)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        page: _currentPage + 1,
        danhMuc: _currentCategory,
        khoangGia: _currentPriceRange,
        sortBy: _currentSort,
        search: _currentSearch,
      );

      _products.addAll(response.products);
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Đã có lỗi xảy ra';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Lấy sản phẩm bán chạy và mới nhất (cho Home)
  Future<void> loadFeaturedProducts() async {
    if (_isLoadingFeatured) return;

    _isLoadingFeatured = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _productService.getBestSellingProducts(),
        _productService.getNewestProducts(),
      ]);

      _bestSellingProducts = results[0];
      _newestProducts = results[1];
    } catch (e) {
      debugPrint('Error loading featured products: $e');
    } finally {
      _isLoadingFeatured = false;
      notifyListeners();
    }
  }

  /// Clear current product (khi rời khỏi detail screen)
  void clearCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadProducts(
        category: _currentCategory,
        priceRange: _currentPriceRange,
        sortBy: _currentSort,
        search: _currentSearch,
        refresh: true,
      ),
      loadFeaturedProducts(),
    ]);
  }
}
