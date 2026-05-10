import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: AuthBloc connect করবো
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    if (mounted) context.go(AppRouter.verifyPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ──
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.h1,
                    children: [
                      const TextSpan(text: 'Let\'s '),
                      TextSpan(
                        text: 'Sign you up,',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      const TextSpan(text: '\nyour meal awaits'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Subtitle ──
                Row(
                  children: [
                    Text(
                      'If you don\'t have an account please ',
                      style: AppTextStyles.bodySmall,
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRouter.signIn),
                      child: Text(
                        'Sign up here',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Full Name ──
                Text('Full name', style: AppTextStyles.label),
                const SizedBox(height: 8),
                AppTextField(
                  hint: 'Pranav s',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 20),

                // ── Email ──
                Text('Email address', style: AppTextStyles.label),
                const SizedBox(height: 8),
                AppTextField(
                  hint: 'pranav123@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),

                // ── Password ──
                Text('Password', style: AppTextStyles.label),
                const SizedBox(height: 8),
                AppTextField(
                  hint: '••••••••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 24),

                // ── Sign Up Button ──
                AppButton(
                  text: 'SIGN IN',
                  isLoading: _isLoading,
                  color: AppColors.error,
                  onPressed: _signUp,
                ),
                const SizedBox(height: 16),

                // ── Terms ──
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.caption,
                      children: [
                        const TextSpan(
                            text: 'By signing up, you have agreed to our\n'),
                        TextSpan(
                          text: 'Terms and conditions',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy policy',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Or ──
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Or connect with',
                          style: AppTextStyles.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Facebook ──
                _SocialButton(
                  icon: AppAssets.facebook,
                  label: 'Connect with facebook',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // ── Google ──
                _SocialButton(
                  icon: AppAssets.google,
                  label: 'Connect with Google',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Social Button ──
class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}