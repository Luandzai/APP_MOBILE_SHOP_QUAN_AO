import 'package:equatable/equatable.dart';

/// Model ProductVariant - Phiên bản sản phẩm
/// 
/// Mỗi sản phẩm có nhiều phiên bản (size, màu khác nhau)
class ProductVariant extends Equatable {
  final int id;
  final String? sku;
  final double giaBan;
  final int soLuongTonKho;
  final Map<String, String> options; // {"Màu": "Đen", "Size": "M"}

  const ProductVariant({
    required this.id,
    this.sku,
    required this.giaBan,
    required this.soLuongTonKho,
    required this.options,
  });

  /// Có còn hàng không
  bool get isInStock => soLuongTonKho > 0;

  /// Lấy giá trị của một thuộc tính
  String? getOption(String key) => options[key];

  /// Lấy tên hiển thị (ví dụ: "Đen - M")
  String get displayName => options.values.join(' - ');

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    // options có thể là JSON string hoặc Map
    Map<String, String> parsedOptions = {};
    
    final rawOptions = json['options'];
    if (rawOptions != null) {
      if (rawOptions is Map) {
        rawOptions.forEach((key, value) {
          parsedOptions[key.toString()] = value.toString();
        });
      }
    }

    return ProductVariant(
      id: json['PhienBanID'] ?? 0,
      sku: json['SKU'] ?? json['sku'],
      giaBan: _parseDouble(json['GiaBan'] ?? json['price']),
      soLuongTonKho: json['SoLuongTonKho'] ?? json['stock'] ?? 0,
      options: parsedOptions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PhienBanID': id,
      'SKU': sku,
      'GiaBan': giaBan,
      'SoLuongTonKho': soLuongTonKho,
      'options': options,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  List<Object?> get props => [id, sku];
}
