import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import 'order_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _currentNavIndex = 2;

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
                    Text('Order History', style: AppTextStyles.h3),
                  ],
                ),
              ),

              // ── Orders ──
              Expanded(
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading) {
                      return const LoadingWidget();
                    }

                    if (state is OrderError) {
                      return AppErrorWidget(
                        message: state.message,
                        onRetry: () => context.read<OrderBloc>().add(
                              FetchOrdersEvent(
                                userId: LocalStorage.instance.getUserId() ?? '',
                              ),
                            ),
                      );
                    }

                    if (state is OrderEmpty) {
                      return EmptyWidget(
                        message: 'No orders yet',
                        subMessage: 'Your order history will appear here',
                        icon: Icons.receipt_long_outlined,
                        action: ElevatedButton(
                          onPressed: () => context.go(AppRouter.restaurant),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: Text('Order Now', style: AppTextStyles.button),
                        ),
                      );
                    }

                    if (state is OrdersLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusLG),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Restaurant Name & Status ──
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.restaurantName,
                                        style: AppTextStyles.h3
                                            .copyWith(fontSize: 15),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order.status)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _getStatusLabel(order.status),
                                        style: AppTextStyles.caption.copyWith(
                                          color: _getStatusColor(order.status),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // ── Items ──
                                Text(
                                  '${order.totalItems} items',
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 4),

                                // ── Date ──
                                Text(
                                  order.createdAt != null
                                      ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}'
                                      : '',
                                  style: AppTextStyles.caption,
                                ),
                                const Divider(height: 16),

                                // ── Total & Track ──
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Total',
                                            style: AppTextStyles.caption),
                                        Text(
                                          '₹${order.total.toStringAsFixed(0)}',
                                          style: AppTextStyles.label.copyWith(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (order.isPending)
                                      TextButton(
                                        onPressed: () => context.go(
                                          AppRouter.orderCancellation,
                                          extra: {'orderId': order.id},
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style:
                                              AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    if (order.isOnTheWay)
                                      ElevatedButton(
                                        onPressed: () =>
                                            context.go(AppRouter.trackingMap),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.error,
                                          minimumSize: const Size(100, 36),
                                        ),
                                        child: Text(
                                          'Track',
                                          style: AppTextStyles.button
                                              .copyWith(fontSize: 13),
                                        ),
                                      ),
                                    if (order.isDelivered)
                                      OutlinedButton(
                                        onPressed: () => context.go(
                                          AppRouter.rating,
                                          extra: {
                                            'restaurantId': order.restaurantId,
                                            'restaurantName':
                                                order.restaurantName,
                                            'restaurantImage': '',
                                          },
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: AppColors.error),
                                          minimumSize: const Size(100, 36),
                                        ),
                                        child: Text(
                                          'Rate',
                                          style: AppTextStyles.button.copyWith(
                                            fontSize: 13,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.info;
      case 'preparing':
        return AppColors.secondary;
      case 'on_the_way':
        return AppColors.primary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'on_the_way':
        return 'On the way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
