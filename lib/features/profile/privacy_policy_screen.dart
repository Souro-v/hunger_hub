import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                  Text('Privacy Policy', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last updated: January 1, 2025',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 20),

                    _buildSection(
                      '1. Information We Collect',
                      'We collect information you provide directly to us, such as when you create an account, place an order, or contact us for support. This includes your name, email address, phone number, delivery address, and payment information.',
                    ),
                    _buildSection(
                      '2. How We Use Your Information',
                      'We use the information we collect to process your orders, send you order confirmations and updates, provide customer support, send promotional communications (with your consent), and improve our services.',
                    ),
                    _buildSection(
                      '3. Information Sharing',
                      'We do not sell, trade, or otherwise transfer your personal information to outside parties except to provide our services. We may share your information with restaurants and delivery partners to fulfill your orders.',
                    ),
                    _buildSection(
                      '4. Data Security',
                      'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.',
                    ),
                    _buildSection(
                      '5. Location Information',
                      'We collect location information to provide delivery services and show you nearby restaurants. You can disable location access in your device settings.',
                    ),
                    _buildSection(
                      '6. Cookies',
                      'We use cookies and similar tracking technologies to track activity on our app and hold certain information to improve and analyze our service.',
                    ),
                    _buildSection(
                      '7. Your Rights',
                      'You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us directly.',
                    ),
                    _buildSection(
                      '8. Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us at support@hungryhub.com',
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}