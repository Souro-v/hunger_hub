import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expController = TextEditingController();
  final _nameController = TextEditingController();
  final int  _currentCard = 0;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Credit Card ──
              _buildCreditCard(),
              const SizedBox(height: 16),

              // ── Card Dots ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentCard == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentCard == index
                          ? AppColors.error
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // ── USE THIS CARD ──
              _buildOutlinedButton(
                label: 'USE THIS CARD',
                onTap: () => context.go(AppRouter.orderStatus),
              ),
              const SizedBox(height: 12),

              // ── OR ──
              Center(
                child: Text('OR', style: AppTextStyles.bodySmall),
              ),
              const SizedBox(height: 12),

              // ── ADD NEW CARD ──
              _buildOutlinedButton(
                label: 'ADD NEW CARD',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // ── Card Number ──
              _buildCardField(
                hint: 'Card Number',
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
              const SizedBox(height: 12),

              // ── CVV & Exp ──
              Row(
                children: [
                  Expanded(
                    child: _buildCardField(
                      hint: 'CVV',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCardField(
                      hint: 'Exp',
                      controller: _expController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── ADD CARD ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRouter.orderStatus),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusMD),
                    ),
                  ),
                  child: Text('ADD CARD', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 12),

              // ── SCAN CARD ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusMD),
                    ),
                  ),
                  child: Text('SCAN CARD', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Credit Card Widget ──
  Widget _buildCreditCard() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E6B), Color(0xFF1A2340)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Credit Label & Mastercard ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              // Mastercard Logo
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // ── Card Lines ──
          Container(
            height: 2,
            width: 120,
            color: Colors.white.withValues(alpha: 0.3),
            margin: const EdgeInsets.only(bottom: 4),
          ),
          Container(
            height: 2,
            width: 80,
            color: Colors.white.withValues(alpha: 0.2),
            margin: const EdgeInsets.only(bottom: 12),
          ),

          // ── Name ──
          Text(
            'Emiway Bantai',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // ── Card Number ──
          Text(
            _cardNumberController.text.isEmpty
                ? '2221 - 0057 - 4680 - 2089'
                : _formatCardNumber(_cardNumberController.text),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textWhite.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCardNumber(String number) {
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' - ');
      buffer.write(number[i]);
    }
    return buffer.toString();
  }

  // ── Outlined Button ──
  Widget _buildOutlinedButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ── Card Field ──
  Widget _buildCardField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}