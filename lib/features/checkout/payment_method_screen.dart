import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _currentNavIndex = 2;
  bool _hasCard = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'icon': AppAssets.paypal, 'name': 'Paypal'},
    {'icon': AppAssets.mastercard, 'name': 'Mastercard'},
    {'icon': AppAssets.gpay, 'name': 'Google Pay'},
    {'icon': AppAssets.amazonPay, 'name': 'Amazon Pay'},
    {'icon': AppAssets.visa, 'name': 'Visa'},
  ];

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
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Payment', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: _hasCard
                  ? _buildPaymentList(context)
                  : _buildNoCard(context),
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

  // ── Payment List ──
  Widget _buildPaymentList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.h1,
              children: [
                const TextSpan(text: 'You are almost\nthere...'),
                TextSpan(
                  text: 'Choose',
                  style: AppTextStyles.h1.copyWith(color: AppColors.error),
                ),
                const TextSpan(text: ' your\npayment method'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Payment Methods ──
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return GestureDetector(
                onTap: () => context.go(AppRouter.orderStatus),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(AppConstants.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Image.asset(method['icon'],
                          width: 40, height: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(method['name'],
                            style: AppTextStyles.bodyMedium),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // ── Add New ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () => context.go(AppRouter.addCard),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(AppConstants.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('ADD NEW',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Total ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyles.bodyMedium),
              Row(
                children: [
                  const Text('₹ ', style: TextStyle(fontSize: 13)),
                  Text('1250', style: AppTextStyles.label),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── No Card ──
  Widget _buildNoCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── 404 Image ──
          Image.asset(
            AppAssets.error404,
            height: 200,
          ),
          const SizedBox(height: 24),

          // ── Message ──
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: AppTextStyles.h2,
              children: [
                TextSpan(
                  text: 'Oops',
                  style: AppTextStyles.h2.copyWith(color: AppColors.error),
                ),
                const TextSpan(
                    text:
                    ', seems you dont\'t\nhave anty card yet.Let\'s\nquickly add one for you.'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Add Credit Card ──
          GestureDetector(
            onTap: () => context.go(AppRouter.addCard),
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B4EFF), Color(0xFFFF4E9F)],
                ),
                borderRadius:
                BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: Center(
                child: Text(
                  'Add Crediti Card',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── ADD CREDIT CARD Button ──
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(AppConstants.radiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                'ADD CREDIT CARD',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}