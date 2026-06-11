import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I place an order?',
        'answer':
        'Browse restaurants, select your food items, add them to cart, and proceed to checkout. Choose your payment method and confirm your order.',
      },
      {
        'question': 'How long does delivery take?',
        'answer':
        'Delivery time varies by restaurant and location. You can see the estimated delivery time on each restaurant\'s page. Typically it takes 20-60 minutes.',
      },
      {
        'question': 'Can I cancel my order?',
        'answer':
        'You can cancel your order before it is confirmed by the restaurant. Go to Order History, select your order, and tap Cancel Order.',
      },
      {
        'question': 'How do I track my order?',
        'answer':
        'After placing your order, go to Order History and tap "Track" on your active order. You can see real-time updates on your delivery.',
      },
      {
        'question': 'What payment methods are accepted?',
        'answer':
        'We accept Paypal, Mastercard, Google Pay, Amazon Pay, Visa, and credit/debit cards.',
      },
      {
        'question': 'How do I apply a promo code?',
        'answer':
        'In the cart screen, enter your promo code in the "Add Promo code" field and tap Apply. The discount will be applied to your order.',
      },
      {
        'question': 'Can I change my delivery address?',
        'answer':
        'You can add and manage delivery addresses in Profile → Addresses. Select your preferred address during checkout.',
      },
      {
        'question': 'How do I contact support?',
        'answer':
        'You can contact us through the Help section in the app, or email us at support@hungryhub.com. We\'re available 24/7.',
      },
      {
        'question': 'Is my payment information secure?',
        'answer':
        'Yes, we use industry-standard encryption to protect your payment information. We never store your complete card details.',
      },
      {
        'question': 'How do I refer a friend?',
        'answer':
        'Go to Profile → Refer a Friend. Share your unique referral link. When your friend signs up using your link, you both get rewards.',
      },
    ];

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
                  Text('FAQ', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── FAQ List ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return _FaqItem(faq: faqs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final Map<String, String> faq;
  const _FaqItem({required this.faq});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: const[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            widget.faq['question']!,
            style: AppTextStyles.label,
          ),
          trailing: Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: AppColors.error,
          ),
          onExpansionChanged: (expanded) =>
              setState(() => _isExpanded = expanded),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16),
              child: Text(
                widget.faq['answer']!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}