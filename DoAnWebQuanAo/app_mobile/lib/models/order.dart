import 'package:equatable/equatable.dart';
import 'order_detail.dart';

/// Model Order - Đơn hàng
/// 
/// Trạng thái đơn: CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO → HOAN_THANH
/// Hoặc: HUY → (cancelled)
class Order extends Equatable {
  final int id;
  final String maDonHang;
  final DateTime ngayDatHang;
  final String trangThai;
  final String trangThaiThanhToan;
  final String phuongThucThanhToan;
  
  // Thông tin giao hàng
  final String hoTenNguoiNhan;
  final String soDienThoai;
  final String diaChi;
  final String? ghiChu;
  
  // Tổng tiền
  final double tongTienSanPham;
  final double phiVanChuyen;
  final double giamGia;
  final double tongThanhToan;
  
  // Chi tết đơn hàng
  final List<OrderDetail> chiTiet;
  
  // Thông tin voucher
  final String? maKhuyenMai;
  final double? giaTriKhuyenMai;
  
  // Thông tin bổ sung từ server
  final int? methodId; // 701=COD, 702=VNPAY, 703=MOMO
  final bool daYeuCauTraHang;

  const Order({
    required this.id,
    required this.maDonHang,
    required this.ngayDatHang,
    required this.trangThai,
    required this.trangThaiThanhToan,
    required this.phuongThucThanhToan,
    required this.hoTenNguoiNhan,
    required this.soDienThoai,
    required this.diaChi,
    this.ghiChu,
    required this.tongTienSanPham,
    required this.phiVanChuyen,
    required this.giamGia,
    required this.tongThanhToan,
    this.chiTiet = const [],
    this.maKhuyenMai,
    this.giaTriKhuyenMai,
    this.methodId,
    this.daYeuCauTraHang = false,
  });

  /// Lấy tên trạng thái
  String get trangThaiText => _getTrangThaiText(trangThai);
  
  /// Lấy màu trạng thái
  String get trangThaiColor => _getTrangThaiColor(trangThai);
  
  /// Có thể hủy đơn không
  /// Website logic: CHUA_THANH_TOAN luôn cho hủy, DANG_XU_LY chỉ COD (methodId=701)
  bool get canCancel {
    if (trangThai == 'CHUA_THANH_TOAN') return true;
    if (trangThai == 'DANG_XU_LY') return methodId == 701; // COD
    return false;
  }
  
  /// Có thể yêu cầu hoàn trả không
  bool get canRequestReturn => 
      (trangThai == 'DA_GIAO' || trangThai == 'HOAN_THANH') && 
      !daYeuCauTraHang;
  
  /// Có thể thanh toán lại không (cho CHUA_THANH_TOAN online payment)
  bool get canRetryPayment => 
      trangThai == 'CHUA_THANH_TOAN' && 
      (methodId == 702 || methodId == 703); // VNPAY hoặc MOMO

  factory Order.fromJson(Map<String, dynamic> json) {
    // Server trả về MethodID để biết phương thức thanh toán
    // 701 = COD, 702 = VNPAY, 703 = MOMO
    final methodId = json['MethodID'];
    String phuongThucThanhToan = 'COD';
    if (methodId == 702) phuongThucThanhToan = 'VNPAY';
    if (methodId == 703) phuongThucThanhToan = 'MOMO';
    
    // Xác định trạng thái thanh toán từ TrangThai
    final trangThai = json['TrangThai'] ?? 'DANG_XU_LY';
    String trangThaiThanhToan = 'DA_THANH_TOAN';
    if (trangThai == 'CHUA_THANH_TOAN') {
      trangThaiThanhToan = 'CHUA_THANH_TOAN';
    }
    
    return Order(
      id: json['DonHangID'] ?? 0,
      maDonHang: 'ORD_${json['DonHangID'] ?? 0}',
      ngayDatHang: _parseDate(json['NgayDatHang']) ?? DateTime.now(),
      trangThai: trangThai,
      trangThaiThanhToan: trangThaiThanhToan,
      phuongThucThanhToan: json['TenPhuongThucThanhToan'] ?? phuongThucThanhToan,
      hoTenNguoiNhan: json['TenNguoiNhan'] ?? '',
      soDienThoai: json['DienThoaiNhan'] ?? '',
      diaChi: json['DiaChiChiTiet'] ?? '',
      ghiChu: json['GhiChu'],
      tongTienSanPham: _parseDouble(json['TongTienHang']),
      phiVanChuyen: _parseDouble(json['PhiVanChuyen']),
      giamGia: _parseDouble(json['GiamGia']),
      tongThanhToan: _parseDouble(json['TongThanhToan']),
      chiTiet: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderDetail.fromJson(e))
          .toList() ?? [],
      maKhuyenMai: json['MaKhuyenMai'],
      giaTriKhuyenMai: _parseDoubleNullable(json['GiaTriKhuyenMai']),
      methodId: methodId,
      daYeuCauTraHang: json['DaYeuCauTraHang'] == 1 || json['DaYeuCauTraHang'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DonHangID': id,
      'MaDonHang': maDonHang,
      'TrangThai': trangThai,
      'TongThanhToan': tongThanhToan,
    };
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

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    return _parseDouble(value);
  }

  static String _getTrangThaiText(String trangThai) {
    switch (trangThai) {
      case 'CHO_XAC_NHAN': return 'Chờ xác nhận';
      case 'DANG_XU_LY': return 'Đang xử lý';
      case 'DA_XAC_NHAN': return 'Đã xác nhận';
      case 'DANG_GIAO': return 'Đang giao hàng';
      case 'DA_GIAO': return 'Đã giao hàng';
      case 'HOAN_THANH': return 'Hoàn thành';
      case 'DA_HUY': return 'Đã hủy';
      case 'HUY': return 'Đã hủy';
      case 'CHUA_THANH_TOAN': return 'Chờ thanh toán';
      default: return trangThai;
    }
  }

  static String _getTrangThaiColor(String trangThai) {
    switch (trangThai) {
      case 'CHO_XAC_NHAN': return 'warning';
      case 'DANG_XU_LY': return 'info';
      case 'DA_XAC_NHAN': return 'info';
      case 'DANG_GIAO': return 'primary';
      case 'DA_GIAO': return 'success';
      case 'HOAN_THANH': return 'success';
      case 'DA_HUY': return 'error';
      case 'HUY': return 'error';
      case 'CHUA_THANH_TOAN': return 'warning';
      default: return 'default';
    }
  }

  @override
  List<Object?> get props => [id, maDonHang];
}
