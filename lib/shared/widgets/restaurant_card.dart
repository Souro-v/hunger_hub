import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/restaurant_model.dart';
import 'network_image_widget.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            Stack(
              children: [
                NetworkImageWidget(
                  imageUrl: restaurant.imageUrl,
                  width: double.infinity,
                  height: 160,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusLG),
                    topRight: Radius.circular(AppConstants.radiusLG),
                  ),
                ),
                // ── Open/Closed Badge ──
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: restaurant.isOpen
                          ? AppColors.success
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusCircle,
                      ),
                    ),
                    child: Text(
                      restaurant.isOpen ? 'Open' : 'Closed',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info ──
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name ──
                  Text(
                    restaurant.name,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // ── Category ──
                  Text(
                    restaurant.category,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // ── Rating, Delivery Time, Fee ──
                  Row(
                    children: [
                      // Rating
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${restaurant.totalReviews})',
                        style: AppTextStyles.caption,
                      ),

                      const Spacer(),

                      // Delivery Time
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.deliveryTime} min',
                        style: AppTextStyles.caption,
                      ),

                      const SizedBox(width: 12),

                      // Delivery Fee
                      const Icon(
                        Icons.delivery_dining_rounded,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryFee == 0
                            ? 'Free'
                            : '৳${restaurant.deliveryFee.toStringAsFixed(0)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}