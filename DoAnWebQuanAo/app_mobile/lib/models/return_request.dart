import 'package:equatable/equatable.dart';

/// Model ReturnRequest - Yêu cầu hoàn trả
///
/// Trạng thái: CHO_XU_LY → DA_DUYET / TU_CHOI → HOAN_THANH
class ReturnRequest extends Equatable {
  final int id;
  final int donHangId;
  final String maDonHang;
  final String lyDoHoanTra;
  final String trangThai;
  final DateTime ngayYeuCau;
  final DateTime? ngayXuLy;
  final String? ghiChuAdmin;
  final double soTienHoanTra;
  final List<ReturnItem> sanPhamHoanTra;
  final List<String> hinhAnh;

  const ReturnRequest({
    required this.id,
    required this.donHangId,
    required this.maDonHang,
    required this.lyDoHoanTra,
    required this.trangThai,
    required this.ngayYeuCau,
    this.ngayXuLy,
    this.ghiChuAdmin,
    required this.soTienHoanTra,
    this.sanPhamHoanTra = const [],
    this.hinhAnh = const [],
  });

  /// Lấy tên trạng thái
  String get trangThaiText => _getTrangThaiText(trangThai);

  /// Có thể hủy yêu cầu không (chỉ khi đang chờ xử lý)
  bool get canCancel => trangThai == 'PENDING' || trangThai == 'CHO_XU_LY';

  factory ReturnRequest.fromJson(Map<String, dynamic> json) {
    return ReturnRequest(
      // Server trả về ReturnID thay vì HoanTraID
      id: json['ReturnID'] ?? json['HoanTraID'] ?? json['id'] ?? 0,
      donHangId: json['DonHangID'] ?? 0,
      maDonHang: json['MaDonHang'] ?? 'ORD_${json['DonHangID'] ?? 0}',
      // Server trả về Reason thay vì LyDoHoanTra
      lyDoHoanTra: json['Reason'] ?? json['LyDoHoanTra'] ?? '',
      // Server trả về Status thay vì TrangThai
      trangThai: json['Status'] ?? json['TrangThai'] ?? 'CHO_XU_LY',
      ngayYeuCau: _parseDate(json['NgayYeuCau']) ?? DateTime.now(),
      ngayXuLy: _parseDate(json['NgayXuLy']),
      ghiChuAdmin: json['GhiChuAdmin'] ?? json['AdminNote'],
      // Server không trả về SoTienHoanTra, default 0
      soTienHoanTra: _parseDouble(
        json['SoTienHoanTra'] ?? json['RefundAmount'],
      ),
      sanPhamHoanTra:
          (json['SanPhamHoanTra'] as List<dynamic>?)
              ?.map((e) => ReturnItem.fromJson(e))
              .toList() ??
          [],
      hinhAnh:
          (json['HinhAnh'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
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

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _getTrangThaiText(String trangThai) {
    switch (trangThai) {
      // Backend trả về status tiếng Anh
      case 'PENDING':
        return 'Chờ xử lý';
      case 'APPROVED':
        return 'Đã duyệt';
      case 'REJECTED':
        return 'Từ chối';
      case 'COMPLETED':
        return 'Hoàn thành';
      // Fallback cho status tiếng Việt (nếu có)
      case 'CHO_XU_LY':
        return 'Chờ xử lý';
      case 'DA_DUYET':
        return 'Đã duyệt';
      case 'TU_CHOI':
        return 'Từ chối';
      case 'HOAN_THANH':
        return 'Hoàn thành';
      default:
        return trangThai;
    }
  }

  @override
  List<Object?> get props => [id, donHangId];
}

/// Model ReturnItem - Sản phẩm trong yêu cầu hoàn trả
class ReturnItem extends Equatable {
  final int chiTietDonHangId;
  final String tenSanPham;
  final String? thuocTinh;
  final String? hinhAnh;
  final int soLuongHoanTra;
  final double giaBan;

  const ReturnItem({
    required this.chiTietDonHangId,
    required this.tenSanPham,
    this.thuocTinh,
    this.hinhAnh,
    required this.soLuongHoanTra,
    required this.giaBan,
  });

  double get thanhTien => giaBan * soLuongHoanTra;

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      chiTietDonHangId: json['ChiTietDonHangID'] ?? 0,
      tenSanPham: json['TenSanPham'] ?? '',
      thuocTinh: json['ThuocTinh'],
      hinhAnh: json['HinhAnh'],
      soLuongHoanTra: json['SoLuongHoanTra'] ?? 1,
      giaBan: _parseDouble(json['GiaBan']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  List<Object?> get props => [chiTietDonHangId];
}
