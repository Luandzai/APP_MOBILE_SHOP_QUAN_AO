/// Form Validators
///
/// Các hàm validate input cho forms
class Validators {
  Validators._();

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  /// Validate mật khẩu
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  /// Validate xác nhận mật khẩu
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }

    if (value != password) {
      return 'Mật khẩu không khớp';
    }

    return null;
  }

  /// Validate số điện thoại Việt Nam
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }

    // Số điện thoại VN: 10 số, bắt đầu bằng 0
    final phoneRegex = RegExp(r'^0[35789]\d{8}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'Vui lòng nhập $fieldName'
          : 'Trường này là bắt buộc';
    }
    return null;
  }

  /// Validate họ tên
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }

    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }

    return null;
  }

  /// Validate địa chỉ
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ';
    }

    if (value.trim().length < 10) {
      return 'Vui lòng nhập địa chỉ chi tiết hơn';
    }

    return null;
  }
}

