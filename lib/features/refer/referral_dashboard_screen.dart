import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';

class ReferralDashboardScreen extends StatelessWidget {
  const ReferralDashboardScreen({super.key});

  static const String _referLink = 'https://hungryhub.com/ref/USER123';

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Total Referrals', 'value': '12', 'icon': Icons.people_outline},
      {'label': 'Successful', 'value': '8', 'icon': Icons.check_circle_outline},
      {'label': 'Pending', 'value': '4', 'icon': Icons.pending_outlined},
      {'label': 'Earnings', 'value': '₹800', 'icon': Icons.account_balance_wallet_outlined},
    ];

    final referrals = [
      {'name': 'Rahul S.', 'date': '25/06/2025', 'status': 'completed', 'earned': '₹100'},
      {'name': 'Priya M.', 'date': '20/06/2025', 'status': 'completed', 'earned': '₹100'},
      {'name': 'Amit K.', 'date': '15/06/2025', 'status': 'pending', 'earned': '₹0'},
      {'name': 'Sara J.', 'date': '10/06/2025', 'status': 'completed', 'earned': '₹100'},
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
                  Text('Referral Dashboard', style: AppTextStyles.h3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── Stats Grid ──
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final stat = stats[index];
                        return Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                stat['icon'] as IconData,
                                color: AppColors.error,
                                size: 24,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stat['value'] as String,
                                    style: AppTextStyles.h2.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  Text(stat['label'] as String,
                                      style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Referral Link ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.error, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusLG),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Referral Link',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _referLink,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        const ClipboardData(
                                            text: _referLink));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text('Link copied!'),
                                        behavior:
                                        SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withValues(alpha:0.2),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.copy,
                                            color: Colors.white,
                                            size: 16),
                                        const SizedBox(width: 6),
                                        Text('Copy',
                                            style:
                                            AppTextStyles.bodySmall
                                                .copyWith(
                                                color:
                                                Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Share.share(_referLink),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withValues(alpha:0.2),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.share,
                                            color: Colors.white,
                                            size: 16),
                                        const SizedBox(width: 6),
                                        Text('Share',
                                            style:
                                            AppTextStyles.bodySmall
                                                .copyWith(
                                                color:
                                                Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Referral History ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Referral History',
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
                        itemCount: referrals.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                        itemBuilder: (context, index) {
                          final ref = referrals[index];
                          final isCompleted =
                              ref['status'] == 'completed';
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // ── Avatar ──
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                  AppColors.error.withValues(alpha:0.1),
                                  child: Text(
                                    ref['name']![0],
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // ── Info ──
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(ref['name']!,
                                          style: AppTextStyles.label),
                                      Text(ref['date']!,
                                          style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),

                                // ── Status ──
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.success
                                            .withValues(alpha:0.1)
                                            : AppColors.warning
                                            .withValues(alpha:0.1),
                                        borderRadius:
                                        BorderRadius.circular(
                                            AppConstants.radiusCircle),
                                      ),
                                      child: Text(
                                        isCompleted
                                            ? 'Completed'
                                            : 'Pending',
                                        style:
                                        AppTextStyles.caption.copyWith(
                                          color: isCompleted
                                              ? AppColors.success
                                              : AppColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ref['earned']!,
                                      style: AppTextStyles.label.copyWith(
                                        color: isCompleted
                                            ? AppColors.success
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Invite More ──
                    AppButton(
                      text: 'Invite More Friends',
                      color: AppColors.error,
                      icon: Icons.person_add_outlined,
                      onPressed: () => Share.share(
                        'Join HungryHub and get ₹200 off your first order! $_referLink',
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
}