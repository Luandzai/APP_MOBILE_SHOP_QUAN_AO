import 'package:dio/dio.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/category.dart';

/// Category Service - Quản lý danh mục
class CategoryService {
  final ApiClient _apiClient = ApiClient();

  // Singleton
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  /// Lấy tất cả danh mục (dạng phẳng)
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data;
      return data.map((e) => Category.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy danh mục dạng cây (cha-con)
  Future<List<Category>> getCategoriesTree() async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.categories}/tree');
      final List<dynamic> data = response.data;
      return data.map((e) => Category.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Lấy chi tiết danh mục theo slug
  Future<Category> getCategoryBySlug(String slug) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.categories}/$slug');
      return Category.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
