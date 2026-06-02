import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../firebase/realtime/promo_rtdb_service.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  List<Map<String, dynamic>> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    try {
      final promoService = PromoRtdbService();
      final coupons = await promoService.getAllPromoCodes();
      setState(() {
        _coupons = coupons
            .where((c) => c['isActive'] == true)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
                  Text('Coupons & Offers', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.error,
                ),
              )
                  : _coupons.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_offer_outlined,
                      size: 80,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No coupons available',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for offers',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                itemCount: _coupons.length,
                itemBuilder: (context, index) {
                  final coupon = _coupons[index];
                  return _CouponCard(coupon: coupon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Coupon Card ──
class _CouponCard extends StatelessWidget {
  final Map<String, dynamic> coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final expiryTimestamp = coupon['expiryDate'];
    final expiryDate = expiryTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(expiryTimestamp as int)
        : null;
    final isExpired =
        expiryDate != null && expiryDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: const[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isExpired
                    ? [AppColors.border, AppColors.divider]
                    : [
                  AppColors.error,
                  AppColors.error.withValues(alpha:0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '৳${coupon['discountAmount']?.toStringAsFixed(0)} OFF',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      coupon['description'] ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.local_offer_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ),

          // ── Bottom ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ── Code ──
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius:
                      BorderRadius.circular(AppConstants.radiusSM),
                      border: Border.all(
                        color: AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Text(
                      coupon['code'] ?? '',
                      style: AppTextStyles.label.copyWith(
                        letterSpacing: 2,
                        color: isExpired
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Copy Button ──
                GestureDetector(
                  onTap: isExpired
                      ? null
                      : () {
                    Clipboard.setData(ClipboardData(
                        text: coupon['code'] ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${coupon['code']} copied!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? AppColors.border
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusSM),
                    ),
                    child: Text(
                      isExpired ? 'Expired' : 'Copy',
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Expiry ──
          if (expiryDate != null)
            Padding(
              padding:
              const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isExpired
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isExpired
                        ? 'Expired'
                        : 'Valid till ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
                    style: AppTextStyles.caption.copyWith(
                      color: isExpired
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}