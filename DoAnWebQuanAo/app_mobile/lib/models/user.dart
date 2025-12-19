import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Model User - Người dùng
/// 
/// Dựa trên response từ backend /api/auth/login
class User extends Equatable {
  final int id;
  final String hoTen;
  final String email;
  final String? dienThoai;
  final DateTime? ngaySinh;
  final String? gioiTinh;
  final String? diaChi;
  final String vaiTro;     // KHACHHANG, ADMIN
  final String trangThai;  // ACTIVE, INACTIVE

  const User({
    required this.id,
    required this.hoTen,
    required this.email,
    this.dienThoai,
    this.ngaySinh,
    this.gioiTinh,
    this.diaChi,
    this.vaiTro = 'KHACHHANG',
    this.trangThai = 'ACTIVE',
  });

  /// Kiểm tra có phải admin không
  bool get isAdmin => vaiTro == 'ADMIN';

  /// Kiểm tra tài khoản có active không
  bool get isActive => trangThai == 'ACTIVE';

  /// Lấy tên viết tắt cho avatar
  String get initials {
    if (hoTen.isEmpty) return 'U';
    final parts = hoTen.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Parse từ JSON (response từ server)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['NguoiDungID'] ?? 0,
      hoTen: json['hoTen'] ?? json['HoTen'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      dienThoai: json['dienThoai'] ?? json['DienThoai'],
      ngaySinh: _parseDate(json['ngaySinh'] ?? json['NgaySinh']),
      gioiTinh: json['gioiTinh'] ?? json['GioiTinh'],
      diaChi: json['diaChi'] ?? json['DiaChi'],
      vaiTro: json['vaiTro'] ?? json['VaiTro'] ?? 'KHACHHANG',
      trangThai: json['trangThai'] ?? json['TrangThai'] ?? 'ACTIVE',
    );
  }

  /// Convert sang JSON (để lưu local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hoTen': hoTen,
      'email': email,
      'dienThoai': dienThoai,
      'ngaySinh': ngaySinh?.toIso8601String(),
      'gioiTinh': gioiTinh,
      'diaChi': diaChi,
      'vaiTro': vaiTro,
      'trangThai': trangThai,
    };
  }

  /// Convert sang JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Parse từ JSON string
  factory User.fromJsonString(String jsonString) {
    return User.fromJson(jsonDecode(jsonString));
  }

  /// CopyWith - tạo bản sao với một số field thay đổi
  User copyWith({
    int? id,
    String? hoTen,
    String? email,
    String? dienThoai,
    DateTime? ngaySinh,
    String? gioiTinh,
    String? diaChi,
    String? vaiTro,
    String? trangThai,
  }) {
    return User(
      id: id ?? this.id,
      hoTen: hoTen ?? this.hoTen,
      email: email ?? this.email,
      dienThoai: dienThoai ?? this.dienThoai,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      gioiTinh: gioiTinh ?? this.gioiTinh,
      diaChi: diaChi ?? this.diaChi,
      vaiTro: vaiTro ?? this.vaiTro,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  /// Parse date từ string
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
  List<Object?> get props => [
    id, hoTen, email, dienThoai, ngaySinh, 
    gioiTinh, diaChi, vaiTro, trangThai
  ];

  @override
  String toString() => 'User(id: $id, hoTen: $hoTen, email: $email)';
}

/// Auth Response - Response từ login/register
class AuthResponse {
  final String token;
  final User user;
  final String? message;

  const AuthResponse({
    required this.token,
    required this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      message: json['message'],
    );
  }
}
