import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/app_button.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _currentNavIndex = 2;
  double _rating = 4.0;
  final _reviewController = TextEditingController();

  String get _ratingLabel {
    if (_rating <= 1) return 'Terrible';
    if (_rating <= 2) return 'Bad';
    if (_rating <= 3) return 'Okay';
    if (_rating <= 4) return 'Good';
    return 'Excellent';
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Restaurant Banner ──
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      AppAssets.rest8,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ── Breadcrumb ──
                  Positioned(
                    top: 12,
                    left: 16,
                    child: Row(
                      children: [
                        _breadcrumb('Home'),
                        _breadcrumbArrow(),
                        _breadcrumb('location'),
                        _breadcrumbArrow(),
                        _breadcrumb('food'),
                        _breadcrumbArrow(),
                        _breadcrumb('about us'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Restaurant Name ──
                    Text('House of BBQ', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      'Chinese  Africian Deshi food',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 24),

                    // ── Rate Delivery ──
                    Center(
                      child: Text(
                        'Please Rate Delivery service',
                        style: AppTextStyles.h3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Rating Label ──
                    Center(
                      child: Text(
                        _ratingLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Stars ──
                    Center(
                      child: RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 40,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.star,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() => _rating = rating);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Review Input ──
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusMD),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Write review',
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textHint,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Submit ──
                    AppButton(
                      text: 'SUBMIT',
                      color: AppColors.error,
                      onPressed: () => context.go(AppRouter.review),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _breadcrumb(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _breadcrumbArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.chevron_right,
        size: 12,
        color: AppColors.textWhite,
      ),
    );
  }
}