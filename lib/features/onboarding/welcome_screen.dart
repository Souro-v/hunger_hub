import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hunger_hub/core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'onboarding_cubit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      imagePath: null, // Screen 1 = Logo only
      title: '',
      description: '',
      isLogo: true,
    ),
    _OnboardingData(
      imagePath: AppAssets.onboarding1,
      title: 'All your favorites',
      description:
      'Get all your loved foods in one once place, you just place the order we do the rest',
      isLogo: false,
    ),
    _OnboardingData(
      imagePath: AppAssets.onboarding2,
      title: 'Order from chosen chef',
      description:
      'Get all your loved foods in one once place, you just place the order we do the rest',
      isLogo: false,
    ),
    _OnboardingData(
      imagePath: AppAssets.onboarding3,
      title: 'Free delivery offers',
      description:
      'Get all your loved foods in one once place, you just place the order we do the rest',
      isLogo: false,
    ),
  ];

  void _goToSignIn(BuildContext context) async {
    await LocalStorage.instance.setFirstTime(false);
    if (context.mounted) context.go(AppRouter.signIn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocListener<OnboardingCubit, int>(
        listener: (context, page) {
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: BlocBuilder<OnboardingCubit, int>(
              builder: (context, currentPage) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        // ── PageView ──
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              context.read<OnboardingCubit>().skipTo(index);
                            },
                            itemCount: _pages.length,
                            itemBuilder: (context, index) {
                              return _OnboardingPage(data: _pages[index]);
                            },
                          ),
                        ),

                        // ── Dots ──
                        if (currentPage != 0) ...[
                          _DotsIndicator(
                            count: 3,
                            current: currentPage - 1,
                          ),
                          const SizedBox(height: 32),
                        ],

                        // ── Buttons ──
                        if (currentPage != 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                // NEXT / GET STARTED Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (currentPage == 3) {
                                        _goToSignIn(context); // Handles setFirstTime(false) and navigation
                                      } else {
                                        context.read<OnboardingCubit>().nextPage();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      currentPage == 3 ? 'GET STARTED' : 'NEXT',
                                      style: AppTextStyles.button,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),

                        // ── Screen 1 spacing ──
                        if (currentPage == 0) const SizedBox(height: 80),
                      ],
                    ),

                    // ── Top Right Skip Button ──
                    if (currentPage != 0)
                      Positioned(
                        top: 16,
                        right: 20,
                        child: GestureDetector(
                          onTap: () => _goToSignIn(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusCircle),
                            ),
                            child: Text(
                              'Skip',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Onboarding Page Item ──
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isLogo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 200,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60), // Space to avoid overlap with top Skip button
            // ── Illustration ──
            Image.asset(
              data.imagePath!,
              height: 240,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),

            // ── Title ──
            Text(
              data.title,
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // ── Description ──
            Text(
              data.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Dots Indicator ──
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == current ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == current ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Data Model ──
class _OnboardingData {
  final String? imagePath;
  final String title;
  final String description;
  final bool isLogo;

  _OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isLogo,
  });
}