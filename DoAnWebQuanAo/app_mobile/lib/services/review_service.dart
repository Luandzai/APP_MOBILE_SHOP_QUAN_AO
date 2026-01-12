import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';
import '../core/storage/secure_storage.dart';

class ReviewService {
  final SecureStorage _storage = SecureStorage();

  // Tạo headers có token
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final token = await _storage.getToken();
    final headers = {'Authorization': 'Bearer $token'};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  // Gửi đánh giá
  Future<void> createReview({
    required int phienBanId,
    required int rating,
    String? comment,
    // Sau này có thể thêm image/video file path vào đây
  }) async {
    final headers = await _getHeaders(isMultipart: true);

    // Sử dụng MultipartRequest để sau này dễ mở rộng upload ảnh/video
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiEndpoints.baseUrl}/reviews'),
    );

    request.headers.addAll(headers);
    request.fields['PhienBanID'] = phienBanId.toString();
    request.fields['DiemSo'] = rating.toString();
    if (comment != null && comment.isNotEmpty) {
      request.fields['BinhLuan'] = comment;
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Lỗi khi gửi đánh giá');
    }
  }

  // Lấy đánh giá của tôi cho sản phẩm này (để check hoặc hiển thị lại nếu cần)
  Future<Map<String, dynamic>?> getMyReview(int phienBanId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/reviews/my-review/$phienBanId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body; // Trả về Map review hoặc null
    } else {
      // Có thể return null hoặc throw tùy logic
      return null;
    }
  }
}
