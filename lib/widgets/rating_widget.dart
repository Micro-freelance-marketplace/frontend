import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool showValue;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfRating;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.showValue = true,
    this.interactive = false,
    this.onRatingChanged,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStars(),
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStars() {
    if (interactive) {
      return _buildInteractiveStars();
    } else {
      return _buildStaticStars();
    }
  }

  Widget _buildStaticStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return _buildStar(index);
      }),
    );
  }

  Widget _buildInteractiveStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: () {
            final newRating = allowHalfRating 
                ? (index + 0.5).toDouble()
                : (index + 1).toDouble();
            onRatingChanged?.call(newRating);
          },
          child: _buildStar(index),
        );
      }),
    );
  }

  Widget _buildStar(int index) {
    final starValue = index + 1;
    final isActive = starValue <= rating;
    final isHalfActive = allowHalfRating && 
        (rating > index && rating < starValue);
    
    final activeColorValue = activeColor ?? Colors.amber;
    final inactiveColorValue = inactiveColor ?? AppTheme.textSecondary.withOpacity(0.3);

    if (isHalfActive) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Background star (inactive)
            Icon(
              Icons.star,
              size: size,
              color: inactiveColorValue,
            ),
            // Clip for half star
            ClipRect(
              clipper: HalfClipper(),
              child: Icon(
                Icons.star,
                size: size,
                color: activeColorValue,
              ),
            ),
          ],
        ),
      );
    }

    return Icon(
      isActive ? Icons.star : Icons.star_border,
      size: size,
      color: isActive ? activeColorValue : inactiveColorValue,
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 0, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class RatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final bool showCount;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;

  const RatingBar({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 16,
    this.showCount = true,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingWidget(
          rating: rating,
          size: size,
          interactive: interactive,
          onRatingChanged: onRatingChanged,
        ),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '($reviewCount)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class DetailedRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final Map<String, double>? subRatings;
  final double size;

  const DetailedRating({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.subRatings,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RatingWidget(
              rating: rating,
              size: size * 1.2,
              showValue: false,
            ),
            const SizedBox(width: 8),
            Text(
              rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reviewCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '($reviewCount reviews)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ],
        ),
        if (subRatings != null && subRatings!.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...subRatings!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: entry.value / 5,
                      backgroundColor: AppTheme.surfaceColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}

class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Average rating
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            RatingWidget(
              rating: averageRating,
              size: 20,
              showValue: false,
            ),
            Text(
              '$totalReviews reviews',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 32),
        // Rating distribution
        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final starRating = 5 - index;
              final count = ratingDistribution[starRating] ?? 0;
              final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                  '$starRating',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppTheme.surfaceColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    count.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
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
