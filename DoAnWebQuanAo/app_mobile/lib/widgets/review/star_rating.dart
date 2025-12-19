import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Star Rating - Widget hiển thị sao đánh giá
class StarRating extends StatelessWidget {
  final int rating; // 1-5
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showText;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final isFilled = index < rating;
          return Icon(
            isFilled ? Icons.star : Icons.star_border,
            size: size,
            color: isFilled 
                ? (activeColor ?? Colors.amber) 
                : (inactiveColor ?? Colors.grey[300]),
          );
        }),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            '$rating/5',
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Star Rating Input - Widget cho phép chọn số sao
class StarRatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 36,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isFilled = starNumber <= rating;
        
        return GestureDetector(
          onTap: () => onChanged(starNumber),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: size,
              color: isFilled 
                  ? (activeColor ?? Colors.amber) 
                  : (inactiveColor ?? Colors.grey[300]),
            ),
          ),
        );
      }),
    );
  }
}

/// Rating Summary - Widget hiển thị tổng hợp đánh giá
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution; // {5: 100, 4: 50, ...}

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Average & Total
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            StarRating(rating: averageRating.round(), size: 18),
            const SizedBox(height: 4),
            Text(
              '$totalReviews đánh giá',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        
        const SizedBox(width: 24),
        
        // Right: Distribution bars
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index;
              final count = distribution[star] ?? 0;
              final percentage = totalReviews > 0 
                  ? (count / totalReviews) * 100 
                  : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(
                      '$star',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            star >= 4 ? Colors.green : 
                            star >= 3 ? Colors.amber : Colors.orange,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
