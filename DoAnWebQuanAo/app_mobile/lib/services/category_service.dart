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
      // Backend chưa có endpoint /tree, nên ta gọi endpoint lấy tất cả (dạng phẳng)
      // sau đó tự build tree ở phía client.
      final response = await _apiClient.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data;

      // 1. Convert to List<Map> to easy manipulation
      List<Map<String, dynamic>> categoriesData =
          List<Map<String, dynamic>>.from(data);

      // 2. Build tree
      return _buildTree(categoriesData);
    } on DioException catch (e) {
      // Fallback or rethrow
      throw ApiException.fromDioException(e);
    }
  }

  List<Category> _buildTree(List<Map<String, dynamic>> flatList) {
    final Map<int, Map<String, dynamic>> map = {};
    final List<Map<String, dynamic>> roots = [];

    // 1. Create map for O(1) access
    for (var cat in flatList) {
      // Ensure children list exists
      cat['children'] = <Map<String, dynamic>>[];
      map[cat['DanhMucID']] = cat;
    }

    // 2. Link children to parents
    for (var cat in flatList) {
      final parentId = cat['DanhMucChaID'];
      if (parentId != null && map.containsKey(parentId)) {
        map[parentId]!['children'].add(cat);
      } else {
        // No parent, or parent not found -> Root
        roots.add(cat);
      }
    }

    // 3. Convert Map tree to List<Category>
    return roots.map((e) => Category.fromJson(e)).toList();
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
