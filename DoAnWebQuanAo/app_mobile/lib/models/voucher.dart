import 'package:equatable/equatable.dart';

/// Model Voucher - Mã khuyến mãi
class Voucher extends Equatable {
  final int id;
  final String maKhuyenMai; // Mã code
  final String? tenKhuyenMai; // Tên khuyến mãi
  final String? moTa;
  final String loaiKhuyenMai; // PHAN_TRAM, TIEN_MAT, FREESHIP
  final double giaTriGiam; // Giá trị giảm (% hoặc tiền)
  final double? giaTriGiamToiDa; // Giảm tối đa (cho % discount)
  final double? giaTriDonHangToiThieu; // Đơn tối thiểu
  final int soLuong; // Số lượng còn lại
  final int? soLanSuDungToiDa; // Số lần dùng tối đa/user
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final String trangThai; // ACTIVE, INACTIVE, EXPIRED
  final bool daThuThap; // User đã thu thập chưa

  // Aliases for compatibility
  String get loaiGiamGia => loaiKhuyenMai;
  double get apDungToiThieu => giaTriDonHangToiThieu ?? 0;

  const Voucher({
    required this.id,
    required this.maKhuyenMai,
    this.tenKhuyenMai,
    this.moTa,
    required this.loaiKhuyenMai,
    required this.giaTriGiam,
    this.giaTriGiamToiDa,
    this.giaTriDonHangToiThieu,
    required this.soLuong,
    this.soLanSuDungToiDa,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    this.trangThai = 'ACTIVE',
    this.daThuThap = false,
  });

  /// Có còn hiệu lực không
  bool get isValid {
    final now = DateTime.now();
    return trangThai == 'ACTIVE' &&
        now.isAfter(ngayBatDau) &&
        now.isBefore(ngayKetThuc) &&
        soLuong > 0;
  }

  /// Đã hết hạn chưa
  bool get isExpired => DateTime.now().isAfter(ngayKetThuc);

  /// Còn bao nhiêu ngày hết hạn
  int get daysRemaining {
    final diff = ngayKetThuc.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Mô tả giảm giá
  String get discountDescription {
    switch (loaiKhuyenMai) {
      case 'PHAN_TRAM':
        final maxText = giaTriGiamToiDa != null
            ? ' (tối đa ${_formatCurrency(giaTriGiamToiDa!)})'
            : '';
        return 'Giảm ${giaTriGiam.toInt()}%$maxText';
      case 'TIEN_MAT':
        return 'Giảm ${_formatCurrency(giaTriGiam)}';
      case 'FREESHIP':
        return 'Miễn phí vận chuyển';
      default:
        return 'Giảm $giaTriGiam';
    }
  }

  /// Tính giá trị giảm thực tế
  double calculateDiscount(double orderTotal) {
    if (giaTriDonHangToiThieu != null && orderTotal < giaTriDonHangToiThieu!) {
      return 0;
    }

    double discount = 0;
    switch (loaiKhuyenMai) {
      case 'PHAN_TRAM':
      case 'PHANTRAM':
        discount = orderTotal * (giaTriGiam / 100);
        if (giaTriGiamToiDa != null && discount > giaTriGiamToiDa!) {
          discount = giaTriGiamToiDa!;
        }
        break;
      case 'FREESHIP':
        // Freeship xử lý riêng (không giảm tiền hàng)
        discount = 0;
        break;
      case 'TIEN_MAT':
      case 'SOTIEN':
      default:
        discount = giaTriGiam;
        break;
    }
    return discount > orderTotal ? orderTotal : discount;
  }

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['KhuyenMaiID'] ?? json['id'] ?? 0,
      maKhuyenMai: json['MaKhuyenMai'] ?? '',
      tenKhuyenMai: json['TenKhuyenMai'] ?? json['MoTa'],
      moTa: json['MoTa'],
      loaiKhuyenMai: json['LoaiKhuyenMai'] ?? 'TIEN_MAT',
      giaTriGiam: _parseDouble(json['GiaTriGiam']),
      giaTriGiamToiDa: _parseDoubleNullable(json['GiaTriGiamToiDa']),
      giaTriDonHangToiThieu: _parseDoubleNullable(
        json['GiaTriDonHangToiThieu'],
      ),
      soLuong: json['SoLuong'] ?? 0,
      soLanSuDungToiDa: json['SoLanSuDungToiDa'],
      ngayBatDau: _parseDate(json['NgayBatDau']) ?? DateTime.now(),
      ngayKetThuc: _parseDate(json['NgayKetThuc']) ?? DateTime.now(),
      trangThai: json['TrangThai'] ?? 'ACTIVE',
      daThuThap: json['DaThuThap'] == 1 || json['DaThuThap'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KhuyenMaiID': id,
      'MaKhuyenMai': maKhuyenMai,
      'MoTa': moTa,
      'LoaiKhuyenMai': loaiKhuyenMai,
      'GiaTriGiam': giaTriGiam,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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

  static String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}tr';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return '${value.toInt()}₫';
  }

  @override
  List<Object?> get props => [id, maKhuyenMai];
}
