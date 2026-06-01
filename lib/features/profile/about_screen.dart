import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                  Text('About', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Logo ──
                    Image.asset(
                      AppAssets.logo,
                      width: 120,
                    ),
                    const SizedBox(height: 16),

                    // ── App Name ──
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'YOU HUNGER. PARTNER',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Description ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'HungryHub is your ultimate food delivery partner. We connect you with the best restaurants in your area, offering a seamless ordering experience with real-time tracking and fast delivery.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Info Cards ──
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: 'support@hungryhub.com',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.language_outlined,
                      title: 'Website',
                      value: 'www.hungryhub.com',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: '+880 1234 567890',
                    ),
                    const SizedBox(height: 32),

                    // ── Social Media ──
                    Text('Follow Us', style: AppTextStyles.h3),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.facebook,
                          color: const Color(0xFF1877F2),
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.camera_alt_outlined,
                          color: const Color(0xFFE4405F),
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          icon: Icons.tag,
                          color: const Color(0xFF1DA1F2),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Copyright ──
                    Text(
                      '© 2025 HungryHub. All rights reserved.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(AppConstants.radiusMD),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset:  Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius:
              BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: Icon(icon, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}