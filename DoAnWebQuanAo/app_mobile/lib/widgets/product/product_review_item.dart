import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProductReviewItem extends StatelessWidget {
  final ProductReview review;

  const ProductReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceVariant,
                child: const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.hoTen,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.diemSo ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 12,
                          );
                        }),
                        const SizedBox(width: 8),
                        if (review.ngayTao != null)
                          Text(
                            DateFormat('dd/MM/yyyy').format(review.ngayTao!),
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          if (review.thuocTinh != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Phân loại: ${review.thuocTinh}',
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ),
          if (review.binhLuan != null)
            Text(review.binhLuan!),
          if (review.hinhAnhUrl != null && review.hinhAnhUrl!.isNotEmpty)
             Padding(
               padding: const EdgeInsets.only(top: 8),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(4),
                 child: CachedNetworkImage(
                   imageUrl: review.hinhAnhUrl!,
                   width: 60,
                   height: 60,
                   fit: BoxFit.cover,
                   errorWidget: (context, url, error) => const SizedBox.shrink(),
                 ),
               ),
             ),
          if (review.phanHoi != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Phản hồi từ người bán:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(review.phanHoi!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
