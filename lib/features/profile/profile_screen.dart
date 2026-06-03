import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_cubit.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;
  bool _isUploadingAvatar = false;

  Future<void> _pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return;

      setState(() => _isUploadingAvatar = true);

      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();
        await userRepo.updateAvatar(
          userId: userId,
          imageFile: File(image.path),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // ── Refresh auth ──
          context.read<AuthBloc>().add(CheckAuthEvent());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update avatar'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    setState(() => _isUploadingAvatar = false);
  }

  final List<Map<String, dynamic>> _menuGroup1 = [
    {'icon': Icons.person_outline, 'label': 'Personal Info'},
    {'icon': Icons.location_on_outlined, 'label': 'Addresses'},
    {'icon': Icons.location_searching_outlined, 'label': 'Order tracking'},
  ];

  final List<Map<String, dynamic>> _menuGroup2 = [
    {'icon': Icons.shopping_cart_outlined, 'label': 'Cart'},
    {'icon': Icons.history_outlined, 'label': 'Order History'},
    {'icon': Icons.favorite_outline, 'label': 'Favourite'},
    {'icon': Icons.notifications_outlined, 'label': 'Notification'},
    {'icon': Icons.payment_outlined, 'label': 'Payment Method'},
    {'icon': Icons.person_add_outlined, 'label': 'Refer a Friend'},
    {'icon': Icons.local_offer_outlined, 'label': 'Coupons & Offers'},
    {'icon': Icons.history_edu_outlined, 'label': 'Payment History'},
  ];

  final List<Map<String, dynamic>> _menuGroup3 = [
    {'icon': Icons.dark_mode_outlined, 'label': 'Dark Mode'},
    {'icon': Icons.lock_outline, 'label': 'Privacy policy'},
    {'icon': Icons.info_outline, 'label': 'About'},
    {'icon': Icons.logout, 'label': 'Sign Out'},
    {'icon': Icons.settings_outlined, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(CheckAuthEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRouter.signIn);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
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
                        Text('Profile', style: AppTextStyles.h3),
                        const Spacer(),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusCircle),
                          ),
                          child: const Icon(
                            Icons.more_horiz,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Avatar ──
                  GestureDetector(
                    onTap: _pickAndUploadAvatar,
                    child: Stack(
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final avatarUrl = state is AuthAuthenticated
                                ? state.user.avatarUrl
                                : null;
                            return CircleAvatar(
                              radius: 48,
                              backgroundColor: AppColors.divider,
                              backgroundImage: avatarUrl != null
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: _isUploadingAvatar
                                  ? const CircularProgressIndicator(
                                      color: AppColors.error,
                                    )
                                  : avatarUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 48,
                                          color: AppColors.textSecondary,
                                        )
                                      : null,
                            );
                          },
                        ),
                        // ── Camera Icon ──
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final name =
                          state is AuthAuthenticated ? state.user.name : 'User';
                      return Text(name, style: AppTextStyles.h3);
                    },
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final email = state is AuthAuthenticated
                          ? state.user.email
                          : 'Explore the food';
                      return Text(
                        email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Menu Group 1 ──
                  _buildMenuGroup(_menuGroup1, context),
                  const SizedBox(height: 12),

                  // ── Menu Group 2 ──
                  _buildMenuGroup(_menuGroup2, context),
                  const SizedBox(height: 12),

                  // ── Menu Group 3 ──
                  _buildMenuGroup(_menuGroup3, context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() => _currentNavIndex = index);
              if (index == 0) context.go(AppRouter.home);
              if (index == 1) context.go(AppRouter.restaurant);
              if (index == 2) context.go(AppRouter.orderStatus);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGroup(
      List<Map<String, dynamic>> items, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return GestureDetector(
            onTap: () => _onMenuTap(item['label'], context),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'],
                        size: 22,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item['label'],
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      // Dark Mode item special handling
                      if (item['label'] == 'Dark Mode')
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, themeMode) {
                            return Switch(
                              value: themeMode == ThemeMode.dark,
                              activeThumbColor: AppColors.error,
                              onChanged: (_) =>
                                  context.read<ThemeCubit>().toggleTheme(),
                            );
                          },
                        )
                      else
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                ),
                if (!isLast) const Divider(height: 1, indent: 54),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onMenuTap(String label, BuildContext context) {
    switch (label) {
      case 'Dark Mode':
        context.read<ThemeCubit>().toggleTheme();
        break;
      case 'Cart':
        context.go(AppRouter.cart);
        break;
      case 'Favourite':
        context.go(AppRouter.favourites);
        break;
      case 'Order tracking':
        context.go(AppRouter.trackingMap);
        break;
      case 'Order History':
        context.go(AppRouter.orderHistory);
        break;
      case 'Payment Method':
        context.go(AppRouter.checkout);
        break;
      case 'Personal Info':
        context.go(AppRouter.personalInfo);
        break;
      case 'Privacy policy':
        context.go(AppRouter.privacyPolicy);
        break;
      case 'About':
        context.go(AppRouter.about);
        break;
      case 'Addresses':
        context.go(AppRouter.addresses);
        break;
      case 'Sign Out':
        context.read<AuthBloc>().add(SignOutEvent());
        break;
      case 'Refer a Friend':
        context.go(AppRouter.refer);
        break;
      case 'Payment History':
        context.go(AppRouter.paymentHistory);
        break;
      case 'Coupons & Offers':
        context.go(AppRouter.coupons);
        break;
      case 'Settings':
        context.go(AppRouter.appSettings);
        break;
    }
  }
}
