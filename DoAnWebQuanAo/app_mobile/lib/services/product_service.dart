import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/product.dart';

/// Product Service - Quản lý sản phẩm
class ProductService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  /// Lấy danh sách sản phẩm với filter
  /// 
  /// [page] Trang hiện tại (mặc định 1)
  /// [danhMuc] Filter theo danh mục (slug)
  /// [khoangGia] Filter theo khoảng giá (ví dụ: "0-500000,500000-1000000")
  /// [sortBy] Sắp xếp: newest, price-asc, price-desc
  /// [search] Tìm kiếm theo tên
  Future<ProductListResponse> getProducts({
    int page = 1,
    String? danhMuc,
    String? khoangGia,
    String? sortBy,
    String? search,
    Map<String, String>? attributeFilters, // {"mau-sac": "den,trang"}
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        if (danhMuc != null) 'danhMuc': danhMuc,
        if (khoangGia != null) 'khoangGia': khoangGia,
        if (sortBy != null) 'sortBy': sortBy,
        if (search != null) 'search': search,
        ...?attributeFilters,
      };

      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      return ProductListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy chi tiết sản phẩm theo slug
  Future<Product> getProductBySlug(String slug) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.products}/$slug');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy sản phẩm bán chạy
  Future<List<Product>> getBestSellingProducts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.bestSellingProducts);
      final List<dynamic> data = response.data;
      return data.map((e) => Product.fromJsonSimple(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy sản phẩm mới nhất
  Future<List<Product>> getNewestProducts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.newestProducts);
      final List<dynamic> data = response.data;
      return data.map((e) => Product.fromJsonSimple(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy sản phẩm liên quan
  Future<List<Product>> getRelatedProducts(String slug) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.products}/$slug/related');
      final List<dynamic> data = response.data;
      return data.map((e) => Product.fromJsonSimple(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

/// Response cho danh sách sản phẩm (có phân trang)
class ProductListResponse {
  final List<Product> products;
  final int currentPage;
  final int totalPages;
  final int totalProducts;

  ProductListResponse({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJsonSimple(e))
          .toList() ?? [],
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalProducts: json['totalProducts'] ?? 0,
    );
  }

  bool get hasMore => currentPage < totalPages;
}
