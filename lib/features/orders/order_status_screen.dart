import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hunger_hub/features/orders/order_bloc.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import 'order_event.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  int _currentNavIndex = 2;
  bool _showCoupon = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _showCoupon
              ? _buildCouponScreen(context)
              : _buildSuccessScreen(context),
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index == 0) context.go(AppRouter.home);
            if (index == 1) context.go(AppRouter.restaurant);
            if (index == 3) context.go(AppRouter.profile);
          },
        ),
      ),
    );
  }

  // ── Success Screen ──
  Widget _buildSuccessScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // ── Success Image ──
          Image.asset(
            AppAssets.success,
            height: 220,
          ),

          const Spacer(),

          // ── Congratulations ──
          Text(
            'Congratulations!',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          Text(
            'You successfully maked a payment,\nenjoy our Food !',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // ── Track Button ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final userId = LocalStorage.instance.getUserId() ?? '';
                context.read<OrderBloc>().add(
                      FetchOrdersEvent(userId: userId),
                    );
                setState(() => _showCoupon = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                ),
              ),
              child: Text('TRACK YOUR ORDER', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Coupon Screen ──
  Widget _buildCouponScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // ── Delivery Bike ──
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: AppColors.divider,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.asset(
                AppAssets.deliveryBike,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Coupon Text ──
          Text(
            'Get 20% off on\norder to use this coupon',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // ── Coupon Code ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            ),
            child: Text(
              '#hby6791i',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Arriving Soon ──
          Text(
            'Your order arriving soon',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // ── View Tracker ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => context.go(AppRouter.trackingMap),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                ),
              ),
              child: Text('VIEW TRACKER', style: AppTextStyles.button),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
