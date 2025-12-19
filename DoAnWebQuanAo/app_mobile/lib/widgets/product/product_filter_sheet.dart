import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/category.dart';

/// Product Filter Sheet - Bottom sheet để filter sản phẩm
class ProductFilterSheet extends StatefulWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final String? selectedPriceRange;
  final String? selectedSort;
  final Function(String? category, String? priceRange, String? sort) onApply;

  const ProductFilterSheet({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.selectedPriceRange,
    this.selectedSort,
    required this.onApply,
  });

  /// Hiển thị filter sheet
  static Future<void> show({
    required BuildContext context,
    required List<Category> categories,
    String? selectedCategory,
    String? selectedPriceRange,
    String? selectedSort,
    required Function(String? category, String? priceRange, String? sort)
    onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFilterSheet(
        categories: categories,
        selectedCategory: selectedCategory,
        selectedPriceRange: selectedPriceRange,
        selectedSort: selectedSort,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late String? _selectedCategory;
  late String? _selectedPriceRange;
  late String? _selectedSort;

  final List<Map<String, dynamic>> _priceRanges = [
    {'label': 'Dưới 500K', 'value': '0-500000', 'icon': Icons.money_off},
    {
      'label': '500K - 1Tr',
      'value': '500000-1000000',
      'icon': Icons.attach_money,
    },
    {
      'label': '1Tr - 2Tr',
      'value': '1000000-2000000',
      'icon': Icons.monetization_on,
    },
    {'label': 'Trên 2Tr', 'value': '2000000-100000000', 'icon': Icons.diamond},
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'label': 'Mới nhất', 'value': 'newest', 'icon': Icons.fiber_new},
    {'label': 'Giá tăng dần', 'value': 'price-asc', 'icon': Icons.arrow_upward},
    {
      'label': 'Giá giảm dần',
      'value': 'price-desc',
      'icon': Icons.arrow_downward,
    },
    {
      'label': 'Bán chạy',
      'value': 'bestselling',
      'icon': Icons.local_fire_department,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedPriceRange = widget.selectedPriceRange;
    _selectedSort = widget.selectedSort;
  }

  void _handleReset() {
    setState(() {
      _selectedCategory = null;
      _selectedPriceRange = null;
      _selectedSort = null;
    });
  }

  void _handleApply() {
    widget.onApply(_selectedCategory, _selectedPriceRange, _selectedSort);
    Navigator.pop(context);
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedPriceRange != null) count++;
    if (_selectedSort != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bộ lọc',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_activeFiltersCount > 0)
                          Text(
                            '$_activeFiltersCount bộ lọc đang áp dụng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _handleReset,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Đặt lại'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[200]),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort Section
                  _buildSection(
                    icon: Icons.sort,
                    title: 'Sắp xếp theo',
                    color: Colors.blue,
                    child: _buildSortOptions(),
                  ),

                  const SizedBox(height: 24),

                  // Price Range Section
                  _buildSection(
                    icon: Icons.payments,
                    title: 'Khoảng giá',
                    color: Colors.green,
                    child: _buildPriceOptions(),
                  ),

                  const SizedBox(height: 24),

                  // Categories Section
                  if (widget.categories.isNotEmpty)
                    _buildSection(
                      icon: Icons.category,
                      title: 'Danh mục',
                      color: Colors.orange,
                      child: _buildCategoryOptions(),
                    ),
                ],
              ),
            ),
          ),

          // Bottom actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Clear button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleReset,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Xóa bộ lọc',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Apply button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleApply,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _activeFiltersCount > 0
                                ? 'Áp dụng ($_activeFiltersCount)'
                                : 'Áp dụng',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  Widget _buildSortOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _sortOptions.map((option) {
        final isSelected = option['value'] == _selectedSort;
        return _buildChip(
          label: option['label'],
          icon: option['icon'],
          isSelected: isSelected,
          onTap: () => setState(() {
            _selectedSort = isSelected ? null : option['value'];
          }),
        );
      }).toList(),
    );
  }

  Widget _buildPriceOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _priceRanges.map((option) {
        final isSelected = option['value'] == _selectedPriceRange;
        return _buildChip(
          label: option['label'],
          icon: option['icon'],
          isSelected: isSelected,
          color: Colors.green,
          onTap: () => setState(() {
            _selectedPriceRange = isSelected ? null : option['value'];
          }),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.categories.map((category) {
        final isSelected = category.slug == _selectedCategory;
        return _buildChip(
          label: category.tenDanhMuc,
          icon: Icons.label_outline,
          isSelected: isSelected,
          color: Colors.orange,
          onTap: () => setState(() {
            _selectedCategory = isSelected ? null : category.slug;
          }),
        );
      }).toList(),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    Color color = AppColors.primary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(25) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : icon,
              size: 18,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
