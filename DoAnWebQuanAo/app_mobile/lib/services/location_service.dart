import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/location.dart';

/// Service xử lý địa điểm (Tỉnh/Huyện/Xã)
class LocationService {
  final ApiClient _apiClient = ApiClient();

  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Lấy danh sách tỉnh thành
  Future<List<Province>> getProvinces() async {
    final response = await _apiClient.get(ApiEndpoints.provinces);

    if (response.data is List) {
      return (response.data as List).map((e) => Province.fromJson(e)).toList();
    }

    final data = response.data['data'] ?? response.data['provinces'] ?? [];
    return (data as List).map((e) => Province.fromJson(e)).toList();
  }

  /// Lấy danh sách quận huyện theo tỉnh
  Future<List<District>> getDistricts(dynamic provinceCode) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.districts}?province_id=$provinceCode',
    );

    if (response.data is List) {
      return (response.data as List).map((e) => District.fromJson(e)).toList();
    }
    return [];
  }

  /// Lấy danh sách phường xã theo quận huyện
  Future<List<Ward>> getWards(dynamic districtCode) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.wards}?district_id=$districtCode',
    );

    if (response.data is List) {
      return (response.data as List).map((e) => Ward.fromJson(e)).toList();
    }
    return [];
  }

  /// Lấy địa chỉ đã lưu của user
  Future<List<ShippingAddress>> getSavedAddresses() async {
    final response = await _apiClient.get(ApiEndpoints.savedAddresses);

    if (response.data is List) {
      return (response.data as List)
          .map((e) => ShippingAddress.fromJson(e))
          .toList();
    }

    final data = response.data['data'] ?? response.data['addresses'] ?? [];
    return (data as List).map((e) => ShippingAddress.fromJson(e)).toList();
  }

  /// Lưu địa chỉ mới
  Future<ShippingAddress> saveAddress(ShippingAddress address) async {
    final response = await _apiClient.post(
      ApiEndpoints.savedAddresses,
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response.data);
  }

  /// Cập nhật địa chỉ
  Future<ShippingAddress> updateAddress(
    int addressId,
    ShippingAddress address,
  ) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.savedAddresses}/$addressId',
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response.data);
  }

  /// Xóa địa chỉ
  Future<bool> deleteAddress(int addressId) async {
    await _apiClient.delete('${ApiEndpoints.savedAddresses}/$addressId');
    return true;
  }

  /// Đặt địa chỉ mặc định
  Future<bool> setDefaultAddress(int addressId) async {
    await _apiClient.put('${ApiEndpoints.savedAddresses}/$addressId/default');
    return true;
  }
}
