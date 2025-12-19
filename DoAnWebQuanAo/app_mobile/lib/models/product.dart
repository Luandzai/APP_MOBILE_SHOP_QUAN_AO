import 'package:equatable/equatable.dart';
import 'product_variant.dart';

/// Model Product - Sản phẩm
/// 
/// Dựa trên response từ backend /api/products
class Product extends Equatable {
  final int id;
  final String tenSanPham;
  final String slug;
  final String? moTa;
  final double giaGoc;       // Giá gốc
  final double giaBan;       // Giá bán thấp nhất (từ variants)
  final String? hinhAnhChinh; // URL ảnh chính
  final String? thuongHieu;
  final String? chatLieu;
  final int? danhMucId;
  final String? danhMucSlug;
  final int? totalSold;      // Tổng số đã bán
  final bool isNew;          // Sản phẩm mới (< 7 ngày)
  final bool hasVoucher;     // Có khuyến mãi
  final List<ProductImage> hinhAnh;      // Danh sách ảnh
  final List<ProductVariant> phienBan;   // Danh sách phiên bản
  final List<ProductReview> danhGia;     // Đánh giá

  const Product({
    required this.id,
    required this.tenSanPham,
    required this.slug,
    this.moTa,
    required this.giaGoc,
    required this.giaBan,
    this.hinhAnhChinh,
    this.thuongHieu,
    this.chatLieu,
    this.danhMucId,
    this.danhMucSlug,
    this.totalSold,
    this.isNew = false,
    this.hasVoucher = false,
    this.hinhAnh = const [],
    this.phienBan = const [],
    this.danhGia = const [],
  });

  /// Tính % giảm giá
  int get discountPercent {
    if (giaGoc <= 0 || giaBan >= giaGoc) return 0;
    return ((giaGoc - giaBan) / giaGoc * 100).round();
  }

  /// Có giảm giá không
  bool get hasDiscount => giaBan < giaGoc;

  /// Parse từ JSON (list response)
  factory Product.fromJsonSimple(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['SanPhamID'] ?? json['id']),
      tenSanPham: json['TenSanPham'] ?? '',
      slug: json['Slug'] ?? '',
      giaGoc: _parseDouble(json['GiaGoc']),
      giaBan: _parseDouble(json['GiaBan'] ?? json['GiaGoc']),
      hinhAnhChinh: json['HinhAnhChinh'],
      isNew: json['IsNew'] == 1 || json['IsNew'] == true,
      hasVoucher: json['HasVoucher'] == 1 || json['HasVoucher'] == true,
      totalSold: _parseInt(json['totalSold'] ?? json['TotalSold']),
    );
  }

  /// Parse từ JSON (detail response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['SanPhamID'] ?? json['id']),
      tenSanPham: json['TenSanPham'] ?? '',
      slug: json['Slug'] ?? '',
      moTa: json['MoTa'],
      giaGoc: _parseDouble(json['GiaGoc']),
      giaBan: _parseDouble(json['GiaBan'] ?? json['GiaGoc']),
      hinhAnhChinh: json['HinhAnhChinh'],
      thuongHieu: json['ThuongHieu'],
      chatLieu: json['ChatLieu'],
      danhMucId: _parseInt(json['DanhMucID']),
      danhMucSlug: json['DanhMucSlug'],
      totalSold: _parseInt(json['TotalSold']),
      isNew: json['IsNew'] == 1 || json['IsNew'] == true,
      hasVoucher: json['HasVoucher'] == 1 || json['HasVoucher'] == true,
      hinhAnh: (json['HinhAnh'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e))
          .toList() ?? [],
      phienBan: (json['PhienBan'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromJson(e))
          .toList() ?? [],
      danhGia: (json['DanhGia'] as List<dynamic>?)
          ?.map((e) => ProductReview.fromJson(e))
          .toList() ?? [],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [id, slug];
}


/// Model ProductImage - Hình ảnh sản phẩm
class ProductImage extends Equatable {
  final int? id;
  final String url;
  final String? moTa;

  const ProductImage({
    this.id,
    required this.url,
    this.moTa,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['HinhAnhID'],
      url: json['URL'] ?? '',
      moTa: json['MoTa'],
    );
  }

  @override
  List<Object?> get props => [id, url];
}

/// Model ProductReview - Đánh giá sản phẩm
class ProductReview extends Equatable {
  final int id;
  final int diemSo;          // 1-5 sao
  final String? binhLuan;
  final String hoTen;        // Tên người đánh giá
  final String? thuocTinh;   // "Màu: Đen, Size: M"
  final String? hinhAnhUrl;
  final String? videoUrl;
  final String? phanHoi;     // Phản hồi từ shop
  final DateTime? ngayTao;
  final DateTime? ngayPhanHoi;

  const ProductReview({
    required this.id,
    required this.diemSo,
    this.binhLuan,
    required this.hoTen,
    this.thuocTinh,
    this.hinhAnhUrl,
    this.videoUrl,
    this.phanHoi,
    this.ngayTao,
    this.ngayPhanHoi,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['DanhGiaID'] ?? 0,
      diemSo: json['DiemSo'] ?? 5,
      binhLuan: json['BinhLuan'],
      hoTen: json['HoTen'] ?? 'Khách hàng',
      thuocTinh: json['ThuocTinh'],
      hinhAnhUrl: json['HinhAnhURL'],
      videoUrl: json['VideoURL'],
      phanHoi: json['PhanHoi'],
      ngayTao: _parseDate(json['NgayTao']),
      ngayPhanHoi: _parseDate(json['NgayPhanHoi']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [id];
}

