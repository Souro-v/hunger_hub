import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 3;

  final List<Map<String, dynamic>> _menuGroup1 = [
    {'icon': Icons.person_outline, 'label': 'Personal Info'},
    {'icon': Icons.location_on_outlined, 'label': 'Addresses'},
    {'icon': Icons.location_searching_outlined, 'label': 'Order tracking'},
  ];

  final List<Map<String, dynamic>> _menuGroup2 = [
    {'icon': Icons.shopping_cart_outlined, 'label': 'Cart'},
    {'icon': Icons.favorite_outline, 'label': 'Favourite'},
    {'icon': Icons.notifications_outlined, 'label': 'Notification'},
    {'icon': Icons.payment_outlined, 'label': 'Payment Method'},
  ];

  final List<Map<String, dynamic>> _menuGroup3 = [
    {'icon': Icons.lock_outline, 'label': 'Privacy policy'},
    {'icon': Icons.info_outline, 'label': 'About'},
    {'icon': Icons.logout, 'label': 'Sign Out'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusCircle),
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
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusCircle),
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
              Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.divider,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Pranav Raji', style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Text(
                    'Explore the food',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
      case 'Cart':
        context.go(AppRouter.cart);
        break;
      case 'Order tracking':
        context.go(AppRouter.trackingMap);
        break;
      case 'Payment Method':
        context.go(AppRouter.checkout);
        break;
      case 'Refer a Friend':
        context.go(AppRouter.refer);
        break;
      case 'Sign Out':
        //sign out work left......
        context.go(AppRouter.signIn);
        break;
      default:
        break;
    }
  }
}
