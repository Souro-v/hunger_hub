import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/user_repository.dart';

class LoyaltyPointsScreen extends StatefulWidget {
  const LoyaltyPointsScreen({super.key});

  @override
  State<LoyaltyPointsScreen> createState() =>
      _LoyaltyPointsScreenState();
}

class _LoyaltyPointsScreenState extends State<LoyaltyPointsScreen> {
  int _points = 0;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _history = [
    {
      'title': 'Order from House of BBQ',
      'points': '+50',
      'date': '25/06/2025',
      'type': 'earned',
    },
    {
      'title': 'Referral bonus',
      'points': '+100',
      'date': '20/06/2025',
      'type': 'earned',
    },
    {
      'title': 'Redeemed for discount',
      'points': '-200',
      'date': '15/06/2025',
      'type': 'redeemed',
    },
    {
      'title': 'Order from Golden Restaurant',
      'points': '+30',
      'date': '10/06/2025',
      'type': 'earned',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      final userId = LocalStorage.instance.getUserId();
      if (userId != null) {
        final userRepo = sl<UserRepository>();
        final user = await userRepo.getUser(userId);
        setState(() {
          _points = (user.toMap()['loyaltyPoints'] ?? 0) as int;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _points = 350;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Loyalty Points', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Points Card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.error,
                            AppColors.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_points',
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                            ),
                          ),
                          Text(
                            'Available Points',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusCircle),
                            ),
                            child: Text(
                              '${(_points / 100).floor()} rewards available',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── How it works ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                        boxShadow: const[
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset:  Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('How it works',
                              style: AppTextStyles.h3),
                          const SizedBox(height: 12),
                          _buildHowItem(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Earn Points',
                            desc:
                            'Get 10 points for every ₹100 spent',
                          ),
                          const SizedBox(height: 8),
                          _buildHowItem(
                            icon: Icons.person_add_outlined,
                            title: 'Refer Friends',
                            desc: 'Earn 100 points per referral',
                          ),
                          const SizedBox(height: 8),
                          _buildHowItem(
                            icon: Icons.redeem_outlined,
                            title: 'Redeem Rewards',
                            desc: '100 points = ₹10 discount',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── History ──
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Points History',
                            style: AppTextStyles.h3),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                        boxShadow: const[
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _history.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          final isEarned =
                              item['type'] == 'earned';
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isEarned
                                        ? AppColors.success
                                        .withValues(alpha: 0.1)
                                        : AppColors.error
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isEarned
                                        ? Icons.add_circle_outline
                                        : Icons
                                        .remove_circle_outline,
                                    color: isEarned
                                        ? AppColors.success
                                        : AppColors.error,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(item['title'],
                                          style: AppTextStyles.label,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis),
                                      Text(item['date'],
                                          style:
                                          AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                Text(
                                  item['points'],
                                  style: AppTextStyles.label.copyWith(
                                    color: isEarned
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.error, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label),
              Text(desc, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}