import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (_phoneController.text.isEmpty) return;
    setState(() => _isLoading = true);
    // TODO: FirebaseAuthService phone verify connect করবো
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    if (mounted) context.go(AppRouter.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              RichText(
                text: TextSpan(
                  style: AppTextStyles.h1,
                  children: [
                    const TextSpan(text: 'Get started with\nHunger '),
                    TextSpan(
                      text: 'Hub',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Subtitle ──
              Text(
                'Enter your phone number to use Hunger hub and enjoy',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // ── Phone Number ──
              Text('Phone number', style: AppTextStyles.label),
              const SizedBox(height: 8),

              // ── Phone Field with Flag ──
              Row(
                children: [
                  // ── Flag + Code ──
                  Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text('🇧🇩', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text('+880', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ── Phone Input ──
                  Expanded(
                    child: AppTextField(
                      hint: '1*********',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Sign Up Button ──
              AppButton(
                text: 'SIGN UP',
                isLoading: _isLoading,
                color: AppColors.error,
                onPressed: _sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}