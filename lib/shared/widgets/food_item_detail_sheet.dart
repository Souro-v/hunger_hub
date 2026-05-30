import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/food_item_model.dart';
import '../animations/scale_animation.dart';

class FoodItemDetailSheet extends StatefulWidget {
  final FoodItemModel foodItem;
  final VoidCallback onAddToCart;
  final int quantity;

  const FoodItemDetailSheet({
    super.key,
    required this.foodItem,
    required this.onAddToCart,
    this.quantity = 0,
  });

  @override
  State<FoodItemDetailSheet> createState() => _FoodItemDetailSheetState();
}

class _FoodItemDetailSheetState extends State<FoodItemDetailSheet> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity > 0 ? widget.quantity : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Image ──
          ScaleAnimation(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: Image.asset(
                widget.foodItem.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: AppColors.divider,
                  child: const Icon(
                    Icons.fastfood,
                    size: 60,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Name & Popular ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.foodItem.name,
                        style: AppTextStyles.h2,
                      ),
                    ),
                    if (widget.foodItem.isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusCircle),
                        ),
                        child: Text(
                          '🔥 Popular',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Rating ──
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.star),
                    const SizedBox(width: 4),
                    Text(
                      widget.foodItem.rating.toString(),
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(ratings)',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Description ──
                Text(
                  widget.foodItem.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Ingredients ──
                if (widget.foodItem.ingredients.isNotEmpty) ...[
                  Text('Ingredients', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: widget.foodItem.ingredients
                        .map((ing) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusCircle),
                      ),
                      child: Text(
                        ing,
                        style: AppTextStyles.caption,
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Price & Quantity ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price', style: AppTextStyles.caption),
                        Text(
                          '₹${widget.foodItem.price.toStringAsFixed(0)}',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    // ── Quantity Control ──
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: AppColors.border),
                              borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                            ),
                            child: const Icon(Icons.remove, size: 18),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: AppTextStyles.h3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _quantity++),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Add to Cart Button ──
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < _quantity; i++) {
                        widget.onAddToCart();
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppConstants.radiusMD),
                      ),
                    ),
                    child: Text(
                      'Add to Cart • ₹${(widget.foodItem.price * _quantity).toStringAsFixed(0)}',
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}