import 'package:flutter/material.dart';

/// Màu sắc chủ đạo của ứng dụng Blank Canvas
/// 
/// Sử dụng hệ màu tối giản, thanh lịch phù hợp với thương hiệu thời trang.
class AppColors {
  // Ngăn khởi tạo
  AppColors._();

  // ============ PRIMARY COLORS ============
  static const Color primary = Color(0xFF1A1A1A);      // Đen chủ đạo
  static const Color primaryLight = Color(0xFF333333);
  static const Color primaryDark = Color(0xFF000000);
  
  // ============ ACCENT / SECONDARY ============
  static const Color accent = Color(0xFFD4A574);       // Màu be/vàng ấm
  static const Color accentLight = Color(0xFFE8C9A0);
  static const Color accentDark = Color(0xFFB8894E);

  // ============ BACKGROUND ============
  static const Color background = Color(0xFFF8F8F8);   // Trắng xám nhẹ
  static const Color surface = Color(0xFFFFFFFF);      // Trắng
  static const Color surfaceVariant = Color(0xFFF0F0F0);

  // ============ TEXT ============
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF1A1A1A);

  // ============ STATUS COLORS ============
  static const Color success = Color(0xFF4CAF50);      // Xanh lá
  static const Color error = Color(0xFFE53935);        // Đỏ
  static const Color warning = Color(0xFFFFC107);      // Vàng
  static const Color info = Color(0xFF2196F3);         // Xanh dương

  // ============ ORDER STATUS COLORS ============
  static const Color statusPending = Color(0xFFFFC107);     // CHO_XAC_NHAN - Vàng
  static const Color statusConfirmed = Color(0xFF2196F3);   // DA_XAC_NHAN - Xanh dương
  static const Color statusShipping = Color(0xFF4CAF50);    // DANG_GIAO - Xanh lá
  static const Color statusDelivered = Color(0xFF1B5E20);   // DA_GIAO - Xanh đậm
  static const Color statusCancelled = Color(0xFFE53935);   // DA_HUY - Đỏ

  // ============ MISC ============
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFD0D0D0);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ============ GRADIENT ============
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
