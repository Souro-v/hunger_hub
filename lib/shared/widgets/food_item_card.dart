import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/food_item_model.dart';
import 'network_image_widget.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItemModel foodItem;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final int quantity;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.onTap,
    required this.onAddToCart,
    this.quantity = 0,
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
        child: Row(
          children: [
            // ── Image ──
            NetworkImageWidget(
              imageUrl: foodItem.imageUrl,
              width: 110,
              height: 110,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLG),
                bottomLeft: Radius.circular(AppConstants.radiusLG),
              ),
            ),

            // ── Info ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Popular Badge ──
                    if (foodItem.isPopular)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusCircle,
                          ),
                        ),
                        child: Text(
                          'Popular',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    // ── Name ──
                    Text(
                      foodItem.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // ── Description ──
                    Text(
                      foodItem.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // ── Price & Add Button ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '৳${foodItem.price.toStringAsFixed(0)}',
                          style: AppTextStyles.price,
                        ),

                        // Add to Cart
                        quantity == 0
                            ? GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusSM,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.textWhite,
                              size: 20,
                            ),
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSM,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: onAddToCart,
                                icon: const Icon(
                                  Icons.remove,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              Text(
                                '$quantity',
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: onAddToCart,
                                icon: const Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}