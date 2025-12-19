import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../models/review.dart';
import 'star_rating.dart';

/// Review Card - Widget hiển thị đánh giá
class ReviewCard extends StatelessWidget {
  final Review review;
  final bool showProductInfo;
  final VoidCallback? onImageTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.showProductInfo = false,
    this.onImageTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Date
            _buildHeader(),
            
            const SizedBox(height: AppSizes.sm),
            
            // Star rating
            StarRating(rating: review.soSao, size: 16),
            
            // Product info (optional)
            if (showProductInfo && review.thuocTinhSanPham != null) ...[
              const SizedBox(height: 4),
              Text(
                review.thuocTinhSanPham!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
            
            // Content
            if (review.noiDung != null && review.noiDung!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              Text(
                review.noiDung!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            
            // Images
            if (review.hinhAnh.isNotEmpty) ...[
              const SizedBox(height: AppSizes.sm),
              _buildImages(),
            ],
            
            // Admin response
            if (review.phanHoiAdmin != null) ...[
              const SizedBox(height: AppSizes.sm),
              _buildAdminResponse(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surfaceVariant,
          backgroundImage: review.avatar != null 
              ? CachedNetworkImageProvider(review.avatar!)
              : null,
          child: review.avatar == null 
              ? Text(
                  review.tenNguoiDung[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: AppSizes.sm),
        
        // Name & Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.tenNguoiDung,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                Formatters.relativeTime(review.ngayTao),
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        
        // Actions
        if (onEdit != null || onDelete != null)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            itemBuilder: (context) => [
              if (onEdit != null)
                const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
              if (onDelete != null)
                const PopupMenuItem(
                  value: 'delete', 
                  child: Text('Xóa', style: TextStyle(color: AppColors.error)),
                ),
            ],
            onSelected: (value) {
              if (value == 'edit') onEdit?.call();
              if (value == 'delete') onDelete?.call();
            },
          ),
      ],
    );
  }

  Widget _buildImages() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: review.hinhAnh.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: CachedNetworkImage(
                  imageUrl: review.hinhAnh[index],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surfaceVariant,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.broken_image, size: 24),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminResponse() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'Phản hồi từ Shop',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (review.ngayPhanHoi != null) ...[
                const Spacer(),
                Text(
                  Formatters.relativeTime(review.ngayPhanHoi!),
                  style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review.phanHoiAdmin!,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
