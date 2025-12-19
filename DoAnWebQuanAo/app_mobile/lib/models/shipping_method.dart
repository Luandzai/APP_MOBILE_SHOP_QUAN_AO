import 'package:equatable/equatable.dart';

/// Model ShippingMethod - Phương thức vận chuyển
class ShippingMethod extends Equatable {
  final int id;
  final String tenPhuongThuc;
  final String? moTa;
  final double phiVanChuyen;
  final String? thoiGianGiao; // "3-5 ngày"
  final bool isDefault;

  const ShippingMethod({
    required this.id,
    required this.tenPhuongThuc,
    this.moTa,
    required this.phiVanChuyen,
    this.thoiGianGiao,
    this.isDefault = false,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id:
          json['PhuongThucID'] ??
          json['PhuongThucVanChuyenID'] ??
          json['id'] ??
          0,
      tenPhuongThuc: json['TenPhuongThuc'] ?? '',
      moTa: json['MoTa'],
      phiVanChuyen: _parseDouble(json['PhiCoDinh'] ?? json['PhiVanChuyen']),
      thoiGianGiao: json['ThoiGianGiao'],
      isDefault: json['IsDefault'] == 1 || json['IsDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PhuongThucVanChuyenID': id,
      'TenPhuongThuc': tenPhuongThuc,
      'PhiVanChuyen': phiVanChuyen,
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
  List<Object?> get props => [id];
}
