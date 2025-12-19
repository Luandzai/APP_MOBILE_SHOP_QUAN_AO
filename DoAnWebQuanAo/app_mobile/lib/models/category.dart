import 'package:equatable/equatable.dart';

/// Model Category - Danh mục sản phẩm
/// 
/// Hỗ trợ danh mục 2 cấp (cha/con)
class Category extends Equatable {
  final int id;
  final String tenDanhMuc;
  final String slug;
  final String? moTa;
  final String? hinhAnh;
  final int? danhMucChaId;
  final List<Category> children; // Danh mục con

  const Category({
    required this.id,
    required this.tenDanhMuc,
    required this.slug,
    this.moTa,
    this.hinhAnh,
    this.danhMucChaId,
    this.children = const [],
  });

  /// Có phải danh mục cha không
  bool get isParent => danhMucChaId == null;

  /// Có danh mục con không
  bool get hasChildren => children.isNotEmpty;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['DanhMucID'] ?? 0,
      tenDanhMuc: json['TenDanhMuc'] ?? '',
      slug: json['Slug'] ?? '',
      moTa: json['MoTa'],
      hinhAnh: json['HinhAnh'],
      danhMucChaId: json['DanhMucChaID'],
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DanhMucID': id,
      'TenDanhMuc': tenDanhMuc,
      'Slug': slug,
      'MoTa': moTa,
      'HinhAnh': hinhAnh,
      'DanhMucChaID': danhMucChaId,
    };
  }

  @override
  List<Object?> get props => [id, slug];
}
