/// Formatters cho hiển thị dữ liệu
/// 
/// Các hàm format giá tiền, ngày tháng, v.v.
class Formatters {
  Formatters._();

  /// Format giá tiền VND
  /// Ví dụ: 150000 -> "150.000₫"
  static String currency(dynamic value) {
    if (value == null) return '0₫';
    
    double amount;
    if (value is String) {
      amount = double.tryParse(value) ?? 0;
    } else if (value is num) {
      amount = value.toDouble();
    } else {
      return '0₫';
    }
    
    return '${_formatNumber(amount.round())}₫';
  }

  /// Format số với dấu chấm phân cách
  /// Ví dụ: 150000 -> "150.000"
  static String number(dynamic value) {
    if (value == null) return '0';
    
    num amount;
    if (value is String) {
      amount = num.tryParse(value) ?? 0;
    } else if (value is num) {
      amount = value;
    } else {
      return '0';
    }
    
    return _formatNumber(amount.round());
  }

  /// Helper để format số với dấu chấm
  static String _formatNumber(int number) {
    String numStr = number.abs().toString();
    String result = '';
    int count = 0;
    
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count == 3 && i > 0) {
        result = '.$result';
        count = 0;
      }
    }
    
    return number < 0 ? '-$result' : result;
  }

  /// Format ngày
  /// Ví dụ: DateTime -> "17/12/2024"
  static String date(DateTime? date) {
    if (date == null) return '';
    return '${_pad(date.day)}/${_pad(date.month)}/${date.year}';
  }

  /// Format ngày giờ
  /// Ví dụ: DateTime -> "14:30 17/12/2024"
  static String dateTime(DateTime? date) {
    if (date == null) return '';
    return '${time(date)} ${Formatters.date(date)}';
  }

  /// Format giờ
  /// Ví dụ: DateTime -> "14:30"
  static String time(DateTime? date) {
    if (date == null) return '';
    return '${_pad(date.hour)}:${_pad(date.minute)}';
  }

  /// Helper để pad số với 0
  static String _pad(int number) {
    return number.toString().padLeft(2, '0');
  }

  /// Parse date từ string ISO
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Format phần trăm giảm giá
  /// Ví dụ: (100000, 80000) -> "-20%"
  static String discountPercent(num originalPrice, num salePrice) {
    if (originalPrice <= 0) return '';
    final percent = ((originalPrice - salePrice) / originalPrice * 100).round();
    if (percent <= 0) return '';
    return '-$percent%';
  }

  /// Format số lượng đã bán
  /// Ví dụ: 1500 -> "1.5K đã bán"
  static String soldCount(int? count) {
    if (count == null || count == 0) return '';
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K đã bán';
    }
    return '$count đã bán';
  }

  /// Format thời gian tương đối
  /// Ví dụ: "2 giờ trước", "3 ngày trước"
  static String relativeTime(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inSeconds < 60) {
      return 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} tuần trước';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} tháng trước';
    } else {
      return '${(diff.inDays / 365).floor()} năm trước';
    }
  }
}

