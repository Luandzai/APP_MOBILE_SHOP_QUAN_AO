import 'package:equatable/equatable.dart';
import 'product.dart';
import 'product_variant.dart';

/// Model CartItem - Sản phẩm trong giỏ hàng
///
/// Mỗi item trong giỏ là một sản phẩm + phiên bản cụ thể
class CartItem extends Equatable {
  final int id; // GioHangID từ DB hoặc local ID
  final int sanPhamId;
  final int phienBanId;
  final int soLuong;
  final bool daChon; // Đã chọn để checkout chưa

  // Thông tin sản phẩm đi kèm (để hiển thị)
  final String? tenSanPham;
  final String? hinhAnh;
  final double? giaBan;
  final String? thuocTinh; // "Màu: Đen, Size: M"
  final int? soLuongTonKho; // Số lượng tồn kho hiện tại

  const CartItem({
    required this.id,
    required this.sanPhamId,
    required this.phienBanId,
    required this.soLuong,
    this.daChon = true,
    this.tenSanPham,
    this.hinhAnh,
    this.giaBan,
    this.thuocTinh,
    this.soLuongTonKho,
  });

  /// Tổng tiền của item
  double get thanhTien => (giaBan ?? 0) * soLuong;

  /// Kiểm tra còn hàng không
  bool get isOutOfStock => soLuongTonKho != null && soLuongTonKho! <= 0;

  /// Kiểm tra số lượng vượt quá tồn kho
  bool get isExceedsStock => soLuongTonKho != null && soLuong > soLuongTonKho!;

  /// Cập nhật số lượng
  CartItem copyWithQuantity(int newQuantity) {
    return CartItem(
      id: id,
      sanPhamId: sanPhamId,
      phienBanId: phienBanId,
      soLuong: newQuantity,
      daChon: daChon,
      tenSanPham: tenSanPham,
      hinhAnh: hinhAnh,
      giaBan: giaBan,
      thuocTinh: thuocTinh,
      soLuongTonKho: soLuongTonKho,
    );
  }

  /// Cập nhật trạng thái chọn
  CartItem copyWithSelected(bool selected) {
    return CartItem(
      id: id,
      sanPhamId: sanPhamId,
      phienBanId: phienBanId,
      soLuong: soLuong,
      daChon: selected,
      tenSanPham: tenSanPham,
      hinhAnh: hinhAnh,
      giaBan: giaBan,
      thuocTinh: thuocTinh,
      soLuongTonKho: soLuongTonKho,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      // Server trả về PhienBanID nhưng không trả về GioHangID (hoặc id).
      // Vì cart item được định danh bằng PhienBanID, nên ta dùng nó làm id chính.
      id: json['GioHangID'] ?? json['id'] ?? json['PhienBanID'] ?? 0,
      sanPhamId: json['SanPhamID'] ?? 0,
      phienBanId: json['PhienBanID'] ?? 0,
      soLuong: json['SoLuong'] ?? 1,
      daChon: json['DaChon'] ?? true,
      tenSanPham: json['TenSanPham'],
      hinhAnh: json['HinhAnh'],
      giaBan: _parseDouble(json['GiaBan']),
      thuocTinh: json['ThuocTinh'],
      soLuongTonKho: _parseInt(json['SoLuongTonKho']),
    );
  }

  /// Tạo CartItem từ Product và Variant
  factory CartItem.fromProductAndVariant({
    required int id,
    required Product product,
    required ProductVariant variant,
    required int quantity,
  }) {
    return CartItem(
      id: id,
      sanPhamId: product.id,
      phienBanId: variant.id,
      soLuong: quantity,
      daChon: true,
      tenSanPham: product.tenSanPham,
      hinhAnh: product.hinhAnhChinh,
      giaBan: variant.giaBan,
      thuocTinh: variant.displayName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SanPhamID': sanPhamId,
      'PhienBanID': phienBanId,
      'SoLuong': soLuong,
      'DaChon': daChon,
      'TenSanPham': tenSanPham,
      'HinhAnh': hinhAnh,
      'GiaBan': giaBan,
      'ThuocTinh': thuocTinh,
      'SoLuongTonKho': soLuongTonKho,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [id, sanPhamId, phienBanId, soLuong];
}
