import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/star_rating_widget.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  double _rating = 0;
  final _feedbackController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRouter.home),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusCircle),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Rate App', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _submitted
                    ? _buildThankYou(context)
                    : _buildRateForm(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateForm(BuildContext context) {
    return Column(
      children: [
        // ── Logo ──
        Image.asset(AppAssets.logo, width: 100),
        const SizedBox(height: 16),
        Text(
          'Enjoying HungryHub?',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Your feedback helps us improve!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // ── Stars ──
        StarRatingWidget(
          rating: _rating,
          isInteractive: true,
          size: 48,
          onRatingUpdate: (rating) =>
              setState(() => _rating = rating),
        ),
        const SizedBox(height: 8),
        Text(
          _getRatingLabel(),
          style: AppTextStyles.label.copyWith(
            color: AppColors.star,
          ),
        ),
        const SizedBox(height: 24),

        // ── Feedback ──
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius:
            BorderRadius.circular(AppConstants.radiusMD),
          ),
          child: TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us what you think...',
              hintStyle: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textHint),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Submit ──
        AppButton(
          text: 'Submit Review',
          color: AppColors.error,
          onPressed: _rating == 0
              ? null
              : () => setState(() => _submitted = true),
        ),
      ],
    );
  }

  Widget _buildThankYou(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text('Thank You!', style: AppTextStyles.h1),
        const SizedBox(height: 8),
        Text(
          'Your feedback means a lot to us.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppButton(
          text: 'Back to Home',
          color: AppColors.error,
          onPressed: () => context.go(AppRouter.home),
        ),
      ],
    );
  }

  String _getRatingLabel() {
    if (_rating == 0) return 'Tap to rate';
    if (_rating <= 1) return 'Terrible';
    if (_rating <= 2) return 'Bad';
    if (_rating <= 3) return 'Okay';
    if (_rating <= 4) return 'Good';
    return 'Excellent!';
  }
}