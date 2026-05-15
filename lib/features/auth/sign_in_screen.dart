import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRouter.home);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ──
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.h1,
                            children: [
                              const TextSpan(text: 'Just '),
                              TextSpan(
                                text: 'Sign in,',
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                              const TextSpan(
                                  text: ' we\'ll\nprepar your order'),
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
                              onTap: () => context.push(AppRouter.signUp),
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

                        // ── Email ──
                        Text('Email address', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        AppTextField(
                          hint: 'fooddeliveryabx@gmail.com',
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
                        const SizedBox(height: 12),

                        // ── Forgot Password ──
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () =>
                                context.push(AppRouter.verifyEmail),
                            child: Text(
                              'Forgot password ?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Sign In Button ──
                        AppButton(
                          text: 'SIGN IN',
                          isLoading: isLoading,
                          color: AppColors.error,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                SignInEvent(
                                  email: _emailController.text
                                      .trim(),
                                  password:
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // ── Or ──
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Text('Or',
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
                    );
                  },
                ),
              ),
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
          borderRadius:
          BorderRadius.circular(AppConstants.radiusMD),
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