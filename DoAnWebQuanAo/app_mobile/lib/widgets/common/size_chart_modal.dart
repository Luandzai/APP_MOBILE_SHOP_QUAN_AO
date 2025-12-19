import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Size Chart Modal - Hiển thị bảng size sản phẩm
class SizeChartModal extends StatelessWidget {
  final String? categoryName;
  final List<SizeChartRow> rows;
  final List<String> headers;

  const SizeChartModal({
    super.key,
    this.categoryName,
    required this.rows,
    required this.headers,
  });

  /// Show as modal
  static Future<void> show(
    BuildContext context, {
    String? categoryName,
    required List<SizeChartRow> rows,
    required List<String> headers,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SizeChartModal(
          categoryName: categoryName,
          rows: rows,
          headers: headers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName != null ? 'Bảng size - $categoryName' : 'Bảng size',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        
        const Divider(),
        
        // Table
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: _buildTable(),
          ),
        ),
        
        // Tip
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          color: AppColors.surfaceVariant,
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Các số đo trong bảng là cm. Vui lòng đo kỹ trước khi chọn size.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(
        color: AppColors.divider,
        width: 1,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      columnWidths: {
        0: const FlexColumnWidth(1),
        for (var i = 1; i < headers.length; i++)
          i: const FlexColumnWidth(1),
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
          ),
          children: headers.map((h) => _buildHeaderCell(h)).toList(),
        ),
        // Data rows
        ...rows.map((row) => TableRow(
          children: [
            _buildCell(row.size, isSize: true),
            ...row.values.map((v) => _buildCell(v)),
          ],
        )),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCell(String text, {bool isSize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isSize ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
          color: isSize ? AppColors.primary : null,
        ),
      ),
    );
  }
}

/// Size Chart Row data
class SizeChartRow {
  final String size;
  final List<String> values;

  SizeChartRow({required this.size, required this.values});

  factory SizeChartRow.fromJson(Map<String, dynamic> json) {
    return SizeChartRow(
      size: json['size'] ?? json['KichThuoc'] ?? '',
      values: List<String>.from(json['values'] ?? []),
    );
  }
}
