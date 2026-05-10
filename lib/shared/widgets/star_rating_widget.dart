import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final bool isInteractive;
  final Function(double)? onRatingUpdate;
  final double size;
  final bool showLabel;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.isInteractive = false,
    this.onRatingUpdate,
    this.size = 20,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: size,
          ignoreGestures: !isInteractive,
          itemBuilder: (context, _) => const Icon(
            Icons.star_rounded,
            color: AppColors.star,
          ),
          onRatingUpdate: onRatingUpdate ?? (_) {},
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.label,
          ),
        ],
      ],
    );
  }
}