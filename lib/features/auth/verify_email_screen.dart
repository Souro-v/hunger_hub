import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_emailController.text.isEmpty) return;
    setState(() => _isLoading = true);
    // TODO: AuthRepository resetPassword connect late process
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: _emailSent
              ? _EmailSentView(email: _emailController.text)
              : _ResetLinkView(
            emailController: _emailController,
            isLoading: _isLoading,
            onReset: _resetPassword,
          ),
        ),
      ),
    );
  }
}

// ── Reset Link View ──
class _ResetLinkView extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onReset;

  const _ResetLinkView({
    required this.emailController,
    required this.isLoading,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Back ──
        GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: [
              const Icon(Icons.arrow_back,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Forgot password',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Title ──
        Text('Reset link', style: AppTextStyles.h1),
        const SizedBox(height: 12),

        // ── Subtitle ──
        Text(
          'Enter your email address and we will send you the reset link',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // ── Email ──
        Text('Email address', style: AppTextStyles.label),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'fooddeliveryabx@gmail.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
        ),
        const SizedBox(height: 32),

        // ── Reset Button ──
        AppButton(
          text: 'RESET PASSWORD',
          isLoading: isLoading,
          color: AppColors.error,
          onPressed: onReset,
        ),
      ],
    );
  }
}

// ── Email Sent View ──
class _EmailSentView extends StatelessWidget {
  final String email;
  const _EmailSentView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Back ──
        GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: [
              const Icon(Icons.arrow_back,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Forgot password',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Title ──
        Text('check your email', style: AppTextStyles.h1),
        const SizedBox(height: 12),

        // ── Subtitle ──
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            children: [
              const TextSpan(
                  text: 'We have just sent a instructions email to '),
              TextSpan(
                text: email,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Having Problem ──
        Text('Having a problem ?', style: AppTextStyles.label),
        const SizedBox(height: 12),

        // ── Resend Timer ──
        Center(
          child: Text(
            'Resend in 32',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Resend Button ──
        AppButton(
          text: 'RESEND LINK',
          color: AppColors.error,
          onPressed: () => context.go(AppRouter.signIn),
        ),
      ],
    );
  }
}