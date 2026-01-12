import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../router/app_router.dart';

/// Search Screen - Tìm kiếm sản phẩm
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _recentSearches = [];

  // Suggestions - có thể load từ API
  final List<String> _suggestions = [
    'Áo thun',
    'Quần jean',
    'Áo khoác',
    'Váy đầm',
    'Áo sơ mi',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;

    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }

    // Navigate to product list with search query
    context.push(
      '${Routes.search}/results?search=${Uri.encodeComponent(query)}',
    );
  }

  void _clearRecentSearches() {
    setState(() => _recentSearches.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: AppSizes.paddingMd),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd,
                vertical: AppSizes.sm,
              ),
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            textInputAction: TextInputAction.search,
            onChanged: (_) => setState(() {}),
            onSubmitted: _search,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent searches
            if (_recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tìm kiếm gần đây',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: _clearRecentSearches,
                    child: const Text('Xóa'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: _recentSearches.map((search) {
                  return ActionChip(
                    label: Text(
                      search,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    avatar: const Icon(
                      Icons.history,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      _searchController.text = search;
                      _search(search);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.xl),
            ],

            // Popular suggestions
            const Text(
              'Gợi ý tìm kiếm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: _suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(
                    suggestion,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  avatar: const Icon(
                    Icons.trending_up,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    _searchController.text = suggestion;
                    _search(suggestion);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
