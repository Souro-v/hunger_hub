import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/loading_widget.dart';
import '../orders/order_bloc.dart';
import '../orders/order_event.dart';
import '../orders/order_state.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>()
        ..add(FetchOrdersEvent(
          userId: LocalStorage.instance.getUserId() ?? '',
        )),
      child: Scaffold(
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
                    Text('Payment History', style: AppTextStyles.h3),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading) {
                      return const LoadingWidget();
                    }

                    if (state is OrderEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.payment_outlined,
                              size: 80,
                              color: AppColors.border,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No payment history',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your payment history will appear here',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is OrdersLoaded) {
                      // ── Total Spent ──
                      final totalSpent = state.orders
                          .fold(0.0, (sum, order) => sum + order.total);

                      return Column(
                        children: [
                          // ── Total Card ──
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.error,
                                    AppColors.primary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusLG),
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
                                        'Total Spent',
                                        style:
                                        AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white
                                              .withValues(alpha:0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${totalSpent.toStringAsFixed(0)}',
                                        style: AppTextStyles.h1.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Total Orders',
                                        style:
                                        AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white
                                              .withValues(alpha:0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${state.orders.length}',
                                        style: AppTextStyles.h1.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Payment List ──
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              itemCount: state.orders.length,
                              itemBuilder: (context, index) {
                                final order = state.orders[index];
                                return Container(
                                  margin:
                                  const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
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
                                  child: Row(
                                    children: [
                                      // ── Icon ──
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.success
                                              .withValues(alpha:0.1),
                                          borderRadius:
                                          BorderRadius.circular(
                                              AppConstants.radiusSM),
                                        ),
                                        child: const Icon(
                                          Icons.check_circle_outline,
                                          color: AppColors.success,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // ── Info ──
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.restaurantName,
                                              style: AppTextStyles.label,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${order.totalItems} items • ${order.paymentMethod}',
                                              style:
                                              AppTextStyles.caption,
                                            ),
                                            if (order.createdAt != null)
                                              Text(
                                                '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
                                                style:
                                                AppTextStyles.caption,
                                              ),
                                          ],
                                        ),
                                      ),

                                      // ── Amount ──
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹${order.total.toStringAsFixed(0)}',
                                            style: AppTextStyles.label
                                                .copyWith(
                                              color: AppColors.error,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.success
                                                  .withValues(alpha:0.1),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  AppConstants
                                                      .radiusCircle),
                                            ),
                                            child: Text(
                                              'Paid',
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                color: AppColors.success,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
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
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}