import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RestaurantFilterSheet extends StatefulWidget {
  final Function(RestaurantFilter) onApply;
  final RestaurantFilter currentFilter;

  const RestaurantFilterSheet({
    super.key,
    required this.onApply,
    required this.currentFilter,
  });

  @override
  State<RestaurantFilterSheet> createState() => _RestaurantFilterSheetState();
}

class _RestaurantFilterSheetState extends State<RestaurantFilterSheet> {
  late double _minRating;
  late int _maxDeliveryTime;
  late bool _freeDelivery;
  late String _sortBy;

  final List<String> _sortOptions = [
    'Relevance',
    'Rating',
    'Delivery Time',
    'Distance',
  ];

  @override
  void initState() {
    super.initState();
    _minRating = widget.currentFilter.minRating;
    _maxDeliveryTime = widget.currentFilter.maxDeliveryTime;
    _freeDelivery = widget.currentFilter.freeDelivery;
    _sortBy = widget.currentFilter.sortBy;
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
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter', style: AppTextStyles.h2),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _minRating = 0.0;
                    _maxDeliveryTime = 60;
                    _freeDelivery = false;
                    _sortBy = 'Relevance';
                  });
                },
                child: Text(
                  'Reset',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Sort By ──
          Text('Sort By', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _sortOptions.map((option) {
              final isSelected = _sortBy == option;
              return GestureDetector(
                onTap: () => setState(() => _sortBy = option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.error : AppColors.divider,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusCircle),
                  ),
                  child: Text(
                    option,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // ── Min Rating ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minimum Rating', style: AppTextStyles.h3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.star.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.star),
                    const SizedBox(width: 4),
                    Text(
                      _minRating.toStringAsFixed(1),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.star,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: AppColors.error,
            inactiveColor: AppColors.border,
            onChanged: (value) => setState(() => _minRating = value),
          ),
          const SizedBox(height: 12),

          // ── Max Delivery Time ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Max Delivery Time', style: AppTextStyles.h3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '$_maxDeliveryTime min',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Slider(
            value: _maxDeliveryTime.toDouble(),
            min: 10,
            max: 60,
            divisions: 10,
            activeColor: AppColors.error,
            inactiveColor: AppColors.border,
            onChanged: (value) =>
                setState(() => _maxDeliveryTime = value.toInt()),
          ),
          const SizedBox(height: 12),

          // ── Free Delivery ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Free Delivery Only', style: AppTextStyles.h3),
              Switch(
                value: _freeDelivery,
                activeThumbColor: AppColors.error,
                onChanged: (value) => setState(() => _freeDelivery = value),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Apply Button ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(RestaurantFilter(
                  minRating: _minRating,
                  maxDeliveryTime: _maxDeliveryTime,
                  freeDelivery: _freeDelivery,
                  sortBy: _sortBy,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
              ),
              child: Text('Apply Filter', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class RestaurantFilter {
  final double minRating;
  final int maxDeliveryTime;
  final bool freeDelivery;
  final String sortBy;

  const RestaurantFilter({
    this.minRating = 0.0,
    this.maxDeliveryTime = 60,
    this.freeDelivery = false,
    this.sortBy = 'Relevance',
  });
}
