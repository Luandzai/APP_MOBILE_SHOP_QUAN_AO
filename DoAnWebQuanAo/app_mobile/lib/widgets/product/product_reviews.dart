import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/product.dart';
import '../../router/app_router.dart';
import 'product_review_item.dart';

class ProductReviews extends StatelessWidget {
  final List<ProductReview> reviews;

  const ProductReviews({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    double avgRating = 0;
    if (reviews.isNotEmpty) {
      avgRating =
          reviews.map((e) => e.diemSo).reduce((a, b) => a + b) / reviews.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá (${reviews.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length > 3 ? 3 : reviews.length, // Show max 3 reviews
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ProductReviewItem(review: review);
          },
        ),
        if (reviews.length > 3)
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: OutlinedButton(
              onPressed: () {
                context.push(
                  Routes.productReviews,
                  extra: {
                    'reviews': reviews,
                    'avgRating': avgRating,
                  },
                );
              },
              child: const Center(child: Text('Xem tất cả')),
            ),
          ),
      ],
    );
  }
}
