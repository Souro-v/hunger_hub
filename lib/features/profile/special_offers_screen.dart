import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SpecialOffersScreen extends StatelessWidget {
  const SpecialOffersScreen({super.key});

  final List<Map<String, dynamic>> _offers = const [
    {
      'title': 'Weekend Special',
      'description': 'Get 50% off on all BBQ items this weekend',
      'image': AppAssets.bbq,
      'discount': '50% OFF',
      'code': 'WEEKEND50',
      'validTill': '31/12/2025',
      'color': 0xFFFF6B35,
    },
    {
      'title': 'Free Delivery',
      'description': 'Free delivery on orders above ₹500',
      'image': AppAssets.banner1,
      'discount': 'FREE DELIVERY',
      'code': 'FREEDEL',
      'validTill': '31/12/2025',
      'color': 0xFF4CAF50,
    },
    {
      'title': 'New User Offer',
      'description': 'Get ₹200 off on your first order',
      'image': AppAssets.banner2,
      'discount': '₹200 OFF',
      'code': 'WELCOME20',
      'validTill': '31/12/2025',
      'color': 0xFF2196F3,
    },
    {
      'title': 'Lunch Special',
      'description': 'Order between 12-3pm and get 20% off',
      'image': AppAssets.banner3,
      'discount': '20% OFF',
      'code': 'LUNCH20',
      'validTill': '31/12/2025',
      'color': 0xFFFF9800,
    },
  ];

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
                  Text('Special Offers', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Offers List ──
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _offers.length,
                itemBuilder: (context, index) {
                  final offer = _offers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusLG),
                      boxShadow: const[
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image ──
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                offer['image'],
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                  Color(offer['color'] as int),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusCircle),
                                ),
                                child: Text(
                                  offer['discount'],
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ── Info ──
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(offer['title'],
                                  style: AppTextStyles.h3),
                              const SizedBox(height: 4),
                              Text(
                                offer['description'],
                                style: AppTextStyles.bodySmall
                                    .copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // ── Code & Copy ──
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.divider,
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppConstants.radiusSM),
                                      ),
                                      child: Text(
                                        offer['code'],
                                        style: AppTextStyles.label
                                            .copyWith(
                                          letterSpacing: 2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: offer['code']));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${offer['code']} copied!'),
                                          backgroundColor:
                                          AppColors.success,
                                          behavior:
                                          SnackBarBehavior.floating,
                                          duration: const Duration(
                                              seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Color(
                                            offer['color'] as int),
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppConstants.radiusSM),
                                      ),
                                      child: Text(
                                        'Copy',
                                        style: AppTextStyles.label
                                            .copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Valid till ${offer['validTill']}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}