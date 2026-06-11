import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final OrderModel order;

  const OrderInvoiceScreen({super.key, required this.order});

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
                  Text('Invoice', style: AppTextStyles.h3),
                  const Spacer(),
                  // ── Share ──
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusCircle),
                      ),
                      child: const Icon(Icons.share_outlined,
                          size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        AppConstants.radiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ── Logo ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HungryHub',
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'INVOICE',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white
                                        .withValues(alpha: 0.8),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              AppAssets.logo,
                              width: 60,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // ── Order Info ──
                            _invoiceRow('Order ID',
                                '#${order.id.substring(0, 8).toUpperCase()}'),
                            _invoiceRow(
                              'Date',
                              order.createdAt != null
                                  ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}'
                                  : 'N/A',
                            ),
                            _invoiceRow('Restaurant',
                                order.restaurantName),
                            _invoiceRow(
                                'Payment', order.paymentMethod),
                            const Divider(height: 24),

                            // ── Items ──
                            Text('Items', style: AppTextStyles.h3),
                            const SizedBox(height: 12),
                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    '${item.quantity}x',
                                    style: AppTextStyles.caption
                                        .copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.foodItem.name,
                                      style:
                                      AppTextStyles.bodySmall,
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
                                    style: AppTextStyles.label,
                                  ),
                                ],
                              ),
                            )),
                            const Divider(height: 24),

                            // ── Price Summary ──
                            _invoiceRow('Subtotal',
                                '₹${order.subtotal.toStringAsFixed(0)}'),
                            _invoiceRow('Delivery Fee',
                                '₹${order.deliveryFee.toStringAsFixed(0)}'),
                            if (order.discount > 0)
                              _invoiceRow(
                                'Discount',
                                '-₹${order.discount.toStringAsFixed(0)}',
                                valueColor: AppColors.success,
                              ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: AppTextStyles.h3),
                                Text(
                                  '₹${order.total.toStringAsFixed(0)}',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // ── Thank You ──
                            Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: AppColors.error,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Thank you for your order!',
                                    style: AppTextStyles.label,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'support@hungryhub.com',
                                    style:
                                    AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceRow(String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(
            value,
            style: AppTextStyles.label.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}