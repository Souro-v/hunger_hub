import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentNavIndex = 2;
  final _reviewController = TextEditingController();

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'John wick',
      'date': '25/06/2020',
      'review':
          'Really convenient and the points system helps benefit loyalty. Some mild glitches here and there, but nothing too egregious. Obviously needs to roll out to more remote.',
      'rating': 4.0,
    },
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusCircle),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('Review', style: AppTextStyles.h3),
                    ],
                  ),
                ),

                // ── Write Review ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // ── User Avatar ──
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.divider,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ── Input ──
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.go(AppRouter.rating),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusMD),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Write your review...',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),

                // ── Reviews List ──
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return _ReviewCard(review: review);
                    },
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
              if (index == 2) context.go(AppRouter.orderStatus);
              if (index == 3) context.go(AppRouter.profile);
            },
          ),
    );
  }
}

// ── Review Card ──
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── User Info ──
          Row(
            children: [
              // ── Avatar ──
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.divider,
                child: Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),

              // ── Name & Date ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'], style: AppTextStyles.label),
                    Text(review['date'], style: AppTextStyles.caption),
                  ],
                ),
              ),

              // ── More ──
              const Icon(
                Icons.more_vert,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Review Text ──
          Text(
            review['review'],
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
