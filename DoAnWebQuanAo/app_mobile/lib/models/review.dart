/// Review Model - Đánh giá sản phẩm
class Review {
  final int id;
  final int sanPhamId;
  final int? phienBanId;
  final int nguoiDungId;
  final String tenNguoiDung;
  final String? avatar;
  final int soSao;
  final String? noiDung;
  final List<String> hinhAnh;
  final String? phanHoiAdmin;
  final DateTime? ngayPhanHoi;
  final DateTime ngayTao;
  final DateTime? ngayCapNhat;
  final String? thuocTinhSanPham; // "Size: M, Màu: Đen"

  Review({
    required this.id,
    required this.sanPhamId,
    this.phienBanId,
    required this.nguoiDungId,
    required this.tenNguoiDung,
    this.avatar,
    required this.soSao,
    this.noiDung,
    this.hinhAnh = const [],
    this.phanHoiAdmin,
    this.ngayPhanHoi,
    required this.ngayTao,
    this.ngayCapNhat,
    this.thuocTinhSanPham,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['DanhGiaID'] ?? json['id'],
      sanPhamId: json['SanPhamID'] ?? json['sanPhamId'] ?? 0,
      phienBanId: json['PhienBanID'] ?? json['phienBanId'],
      nguoiDungId: json['NguoiDungID'] ?? json['nguoiDungId'] ?? 0,
      tenNguoiDung:
          json['TenNguoiDung'] ??
          json['tenNguoiDung'] ??
          json['NguoiDung']?['HoTen'] ??
          'Ẩn danh',
      avatar: json['Avatar'] ?? json['avatar'] ?? json['NguoiDung']?['Avatar'],
      soSao: json['SoSao'] ?? json['soSao'] ?? 5,
      noiDung: json['NoiDung'] ?? json['noiDung'],
      hinhAnh: _parseImages(json['HinhAnh'] ?? json['hinhAnh']),
      phanHoiAdmin: json['PhanHoiAdmin'] ?? json['phanHoiAdmin'],
      ngayPhanHoi: _parseDate(json['NgayPhanHoi'] ?? json['ngayPhanHoi']),
      ngayTao:
          _parseDate(json['NgayTao'] ?? json['ngayTao'] ?? json['createdAt']) ??
          DateTime.now(),
      ngayCapNhat: _parseDate(json['NgayCapNhat'] ?? json['ngayCapNhat']),
      thuocTinhSanPham:
          json['ThuocTinhSanPham'] ??
          json['thuocTinhSanPham'] ??
          _buildThuocTinh(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SanPhamID': sanPhamId,
      'PhienBanID': phienBanId,
      'SoSao': soSao,
      'NoiDung': noiDung,
      'HinhAnh': hinhAnh,
    };
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is String) {
      // Could be JSON string or comma-separated
      if (images.startsWith('[')) {
        try {
          return List<String>.from(
            (images as String)
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .split(',')
                .map((e) => e.trim()),
          );
        } catch (_) {}
      }
      return images.split(',').map((e) => e.trim()).toList();
    }
    if (images is List) {
      return images.map((e) => e.toString()).toList();
    }
    return [];
  }

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  static String? _buildThuocTinh(Map<String, dynamic> json) {
    final phienBan = json['PhienBan'];
    if (phienBan == null) return null;

    final parts = <String>[];
    if (phienBan['TenMauSac'] != null)
      parts.add('Màu: ${phienBan['TenMauSac']}');
    if (phienBan['TenKichThuoc'] != null)
      parts.add('Size: ${phienBan['TenKichThuoc']}');
    return parts.isEmpty ? null : parts.join(', ');
  }

  /// Copy with
  Review copyWith({
    int? id,
    int? sanPhamId,
    int? phienBanId,
    int? nguoiDungId,
    String? tenNguoiDung,
    String? avatar,
    int? soSao,
    String? noiDung,
    List<String>? hinhAnh,
    String? phanHoiAdmin,
    DateTime? ngayPhanHoi,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
    String? thuocTinhSanPham,
  }) {
    return Review(
      id: id ?? this.id,
      sanPhamId: sanPhamId ?? this.sanPhamId,
      phienBanId: phienBanId ?? this.phienBanId,
      nguoiDungId: nguoiDungId ?? this.nguoiDungId,
      tenNguoiDung: tenNguoiDung ?? this.tenNguoiDung,
      avatar: avatar ?? this.avatar,
      soSao: soSao ?? this.soSao,
      noiDung: noiDung ?? this.noiDung,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      phanHoiAdmin: phanHoiAdmin ?? this.phanHoiAdmin,
      ngayPhanHoi: ngayPhanHoi ?? this.ngayPhanHoi,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      thuocTinhSanPham: thuocTinhSanPham ?? this.thuocTinhSanPham,
    );
  }
}

/// Review Stats - Thống kê đánh giá
class ReviewStats {
  final double diemTrungBinh;
  final int tongSoDanhGia;
  final Map<int, int> phanBoSao; // {5: 100, 4: 50, 3: 20, 2: 5, 1: 2}

  ReviewStats({
    required this.diemTrungBinh,
    required this.tongSoDanhGia,
    required this.phanBoSao,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    final phanBo = <int, int>{};

    // Parse distribution
    final dist = json['phanBoSao'] ?? json['distribution'] ?? {};
    if (dist is Map) {
      for (var i = 1; i <= 5; i++) {
        phanBo[i] = dist[i.toString()] ?? dist[i] ?? 0;
      }
    }

    return ReviewStats(
      diemTrungBinh: _parseDouble(
        json['diemTrungBinh'] ?? json['average'] ?? 0,
      ),
      tongSoDanhGia: json['tongSoDanhGia'] ?? json['total'] ?? 0,
      phanBoSao: phanBo,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Phần trăm cho mỗi mức sao
  double getPercentage(int star) {
    if (tongSoDanhGia == 0) return 0;
    return ((phanBoSao[star] ?? 0) / tongSoDanhGia) * 100;
  }
}
