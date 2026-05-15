import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class TrackingMapScreen extends StatefulWidget {
  const TrackingMapScreen({super.key});

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  int _currentNavIndex = 2;

  final List<Map<String, dynamic>> _orderSteps = [
    {'label': 'Your order has been received', 'done': true},
    {'label': 'The restaurant is preparing your food', 'done': false},
    {'label': 'Your order has been picked up for delivery', 'done': false},
    {'label': 'Order arriving soon!', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Map ──
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.mapPlaceholder,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // ── Bottom Sheet ──
            Expanded(
              flex: 3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // ── Delivery Time ──
                    Text(
                      '20 min',
                      style: AppTextStyles.h1.copyWith(fontSize: 36),
                    ),
                    Text(
                      'ESTIMATED DELIVERY TIME',
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Order Steps ──
                    Expanded(
                      child: ListView.builder(
                        itemCount: _orderSteps.length,
                        itemBuilder: (context, index) {
                          final step = _orderSteps[index];
                          final isFirst = index == 0;
                          final isLast = index == _orderSteps.length - 1;
                          return _OrderStep(
                            label: step['label'],
                            isDone: step['done'],
                            isFirst: isFirst,
                            isLast: isLast,
                          );
                        },
                      ),
                    ),

                    // ── Courier Card ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLG),
                      ),
                      child: Row(
                        children: [
                          // ── Avatar ──
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                AssetImage(AppAssets.courierAvatar),
                          ),
                          const SizedBox(width: 12),

                          // ── Name ──
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sam Curver', style: AppTextStyles.label),
                                Text('Courier', style: AppTextStyles.caption),
                              ],
                            ),
                          ),

                          // ── Call ──
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // ── Messenger ──
                          GestureDetector(
                            onTap: () => context.go(AppRouter.help),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(AppAssets.messenger),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 0) context.go(AppRouter.home);
          if (index == 1) context.go(AppRouter.restaurant);
          if (index == 3) context.go(AppRouter.profile);
        },
      ),
    );
  }
}

// ── Order Step Widget ──
class _OrderStep extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isFirst;
  final bool isLast;

  const _OrderStep({
    required this.label,
    required this.isDone,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Timeline ──
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isDone ? AppColors.error : AppColors.border,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),

        // ── Label ──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDone ? AppColors.error : AppColors.textSecondary,
                fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
