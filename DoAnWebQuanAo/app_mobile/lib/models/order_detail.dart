import 'package:equatable/equatable.dart';

/// Model OrderDetail - Chi tiết đơn hàng (từng sản phẩm trong đơn)
class OrderDetail extends Equatable {
  final int id;
  final int sanPhamId;
  final int phienBanId;
  final String tenSanPham;
  final String slug;
  final String? hinhAnh;
  final String? thuocTinh; // "Màu: Đen, Size: M"
  final double giaBan;
  final int soLuong;
  final double thanhTien;

  // Thông tin đánh giá
  final bool daHoanThanh;
  final bool daDanhGia;

  const OrderDetail({
    required this.id,
    required this.sanPhamId,
    required this.phienBanId,
    required this.tenSanPham,
    required this.slug,
    this.hinhAnh,
    this.thuocTinh,
    required this.giaBan,
    required this.soLuong,
    required this.thanhTien,
    this.daHoanThanh = false,
    this.daDanhGia = false,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final gia = _parseDouble(
      json['GiaLucMua'] ?? json['GiaBan'] ?? json['DonGia'],
    );
    final qty = json['SoLuong'] ?? 1;

    return OrderDetail(
      id: json['ChiTietDonHangID'] ?? json['id'] ?? 0,
      sanPhamId: json['SanPhamID'] ?? 0,
      phienBanId: json['PhienBanID'] ?? 0,
      tenSanPham: json['TenSanPham'] ?? '',
      slug: json['Slug'] ?? '',
      hinhAnh: json['HinhAnh'],
      thuocTinh: json['ThuocTinh'],
      giaBan: gia,
      soLuong: qty,
      thanhTien: _parseDouble(json['ThanhTien']) > 0
          ? _parseDouble(json['ThanhTien'])
          : gia * qty,
      daHoanThanh: json['DaHoanThanh'] == 1 || json['DaHoanThanh'] == true,
      daDanhGia: json['DaDanhGia'] == 1 || json['DaDanhGia'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ChiTietDonHangID': id,
      'SanPhamID': sanPhamId,
      'PhienBanID': phienBanId,
      'TenSanPham': tenSanPham,
      'GiaBan': giaBan,
      'SoLuong': soLuong,
      'ThanhTien': thanhTien,
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
  List<Object?> get props => [id, phienBanId];
}
