import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  static const String _shareMessage =
      'Hey! I\'ve been using HungryHub for food delivery and it\'s amazing! 🍔\n\nGet ₹200 off your first order with my referral link:\nhttps://hungryhub.com/download\n\nYOU HUNGER. PARTNER 🚀';

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
                  Text('Share App', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Logo ──
                    Image.asset(AppAssets.logo, width: 120),
                    const SizedBox(height: 16),
                    Text(
                      'Share HungryHub',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share with friends and family and earn rewards!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // ── Share Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error,
                            AppColors.error.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Get ₹200 off',
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'When your friend places their first order',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Share Options ──
                    Text('Share via', style: AppTextStyles.h3),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareOption(
                          icon: Icons.message_outlined,
                          label: 'Message',
                          color: const Color(0xFF4CAF50),
                          onTap: () => Share.share(_shareMessage),
                        ),
                        _buildShareOption(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          color: AppColors.primary,
                          onTap: () => Share.share(_shareMessage),
                        ),
                        _buildShareOption(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          color: const Color(0xFFEA4335),
                          onTap: () => Share.share(_shareMessage),
                        ),
                        _buildShareOption(
                          icon: Icons.more_horiz,
                          label: 'More',
                          color: AppColors.textSecondary,
                          onTap: () => Share.share(_shareMessage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Share Button ──
                    AppButton(
                      text: 'Share Now',
                      color: AppColors.error,
                      icon: Icons.share_outlined,
                      onPressed: () => Share.share(_shareMessage),
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

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}