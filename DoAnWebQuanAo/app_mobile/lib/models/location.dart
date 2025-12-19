import 'package:equatable/equatable.dart';

/// Model Location - Địa điểm (Tỉnh/Huyện/Xã)

/// Tỉnh thành
class Province extends Equatable {
  final String code;
  final String name;
  final String? codename;

  const Province({
    required this.code,
    required this.name,
    this.codename,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      // Ưu tiên ProvinceID (GHN ID) trước Code (mã hành chính)
      code: json['ProvinceID']?.toString() ?? 
            json['code']?.toString() ?? 
            json['Code']?.toString() ?? '',
      name: json['ProvinceName'] ?? 
            json['name'] ?? 
            json['Name'] ?? '',
      codename: json['codename'] ?? json['Codename'] ?? json['Code'],
    );
  }

  @override
  List<Object?> get props => [code];
}

/// Quận huyện
class District extends Equatable {
  final String code;
  final String name;
  final String provinceCode;
  final String? codename;

  const District({
    required this.code,
    required this.name,
    required this.provinceCode,
    this.codename,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      // Ưu tiên DistrictID (GHN ID) trước
      code: json['DistrictID']?.toString() ?? 
            json['code']?.toString() ?? 
            json['Code']?.toString() ?? '',
      name: json['DistrictName'] ?? 
            json['name'] ?? 
            json['Name'] ?? '',
      provinceCode: json['ProvinceID']?.toString() ?? 
                    json['province_code']?.toString() ?? 
                    json['ProvinceCode']?.toString() ?? '',
      codename: json['codename'] ?? json['Codename'] ?? json['Code'],
    );
  }

  @override
  List<Object?> get props => [code];
}

/// Phường xã
class Ward extends Equatable {
  final String code;
  final String name;
  final String districtCode;
  final String? codename;

  const Ward({
    required this.code,
    required this.name,
    required this.districtCode,
    this.codename,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      // Ưu tiên WardCode (GHN ID) trước
      code: json['WardCode']?.toString() ?? 
            json['code']?.toString() ?? 
            json['Code']?.toString() ?? '',
      name: json['WardName'] ?? 
            json['name'] ?? 
            json['Name'] ?? '',
      districtCode: json['DistrictID']?.toString() ?? 
                    json['district_code']?.toString() ?? 
                    json['DistrictCode']?.toString() ?? '',
      codename: json['codename'] ?? json['Codename'],
    );
  }

  @override
  List<Object?> get props => [code];
}

/// Địa chỉ đầy đủ
class ShippingAddress extends Equatable {
  final String hoTen;
  final String soDienThoai;
  final String diaChiChiTiet; // Số nhà, tên đường
  final Province? tinh;
  final District? huyen;
  final Ward? xa;
  final bool isDefault;

  const ShippingAddress({
    required this.hoTen,
    required this.soDienThoai,
    required this.diaChiChiTiet,
    this.tinh,
    this.huyen,
    this.xa,
    this.isDefault = false,
  });

  /// Địa chỉ đầy đủ dạng text
  String get fullAddress {
    final parts = <String>[];
    if (diaChiChiTiet.isNotEmpty) parts.add(diaChiChiTiet);
    if (xa != null) parts.add(xa!.name);
    if (huyen != null) parts.add(huyen!.name);
    if (tinh != null) parts.add(tinh!.name);
    return parts.join(', ');
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      hoTen: json['HoTen'] ?? '',
      soDienThoai: json['SoDienThoai'] ?? '',
      diaChiChiTiet: json['DiaChiChiTiet'] ?? json['DiaChi'] ?? '',
      tinh: json['Tinh'] != null ? Province.fromJson(json['Tinh']) : null,
      huyen: json['Huyen'] != null ? District.fromJson(json['Huyen']) : null,
      xa: json['Xa'] != null ? Ward.fromJson(json['Xa']) : null,
      isDefault: json['IsDefault'] == 1 || json['IsDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HoTen': hoTen,
      'SoDienThoai': soDienThoai,
      'DiaChiChiTiet': diaChiChiTiet,
      'TinhCode': tinh?.code,
      'HuyenCode': huyen?.code,
      'XaCode': xa?.code,
    };
  }

  @override
  List<Object?> get props => [hoTen, soDienThoai, diaChiChiTiet];
}
