import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import '../storage/secure_storage.dart';

/// API Client wrapper sử dụng Dio
/// 
/// Cung cấp các phương thức HTTP cơ bản (GET, POST, PUT, DELETE)
/// với xử lý lỗi và logging tự động.
class ApiClient {
  late final Dio _dio;
  final SecureStorage _storage = SecureStorage();

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Request Interceptor - thêm token vào header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Debug logging
          if (kDebugMode) {
            print('🌐 ${options.method} ${options.uri}');
            if (options.data != null) {
              print('📤 Body: ${options.data}');
            }
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ Response: ${response.statusCode}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('❌ Error: ${error.response?.statusCode} - ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }

  /// POST request với FormData (upload file)
  Future<Response> postFormData(
    String path, {
    required FormData data,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}
