import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/loading_widget.dart';
import 'order_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<OrderBloc>()..add(FetchOrderByIdEvent(orderId: orderId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) return const LoadingWidget();

              if (state is OrderError) {
                return Center(
                  child: Text(state.message, style: AppTextStyles.bodyMedium),
                );
              }

              if (state is OrderDetailLoaded) {
                return _buildContent(context, state.order);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderModel order) {
    return Column(
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusCircle),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 16, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Text('Order Details', style: AppTextStyles.h3),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Order ID & Status ──
                Container(
                  padding: const EdgeInsets.all(16),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order ID', style: AppTextStyles.caption),
                          Text(
                            '#${order.id.substring(0, 8).toUpperCase()}',
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status', style: AppTextStyles.caption),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
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
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date', style: AppTextStyles.caption),
                          Text(
                            order.createdAt != null
                                ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}'
                                : 'N/A',
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Restaurant ──
                Text('Restaurant', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSM),
                        ),
                        child: const Icon(
                          Icons.restaurant_outlined,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.restaurantName,
                                style: AppTextStyles.label),
                            Text('${order.totalItems} items',
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(
                          AppRouter.menuList,
                          extra: {
                            'restaurantId': order.restaurantId,
                            'restaurantName': order.restaurantName,
                            'restaurantImage': '',
                            'restaurantCategory': '',
                            'restaurantRating': 4.5,
                            'restaurantDeliveryTime': 30,
                            'restaurantAddress': '',
                          },
                        ),
                        child: Text(
                          'Reorder',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Order Items ──
                Text('Items', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Container(
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
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              '${item.quantity}x',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(item.foodItem.name,
                                  style: AppTextStyles.bodyMedium),
                            ),
                            Text(
                              '₹${item.totalPrice.toStringAsFixed(0)}',
                              style: AppTextStyles.label,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Price Summary ──
                Text('Price Summary', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
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
                    children: [
                      _priceRow(
                          'Subtotal', '₹${order.subtotal.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _priceRow('Delivery Fee',
                          '₹${order.deliveryFee.toStringAsFixed(0)}'),
                      if (order.discount > 0) ...[
                        const SizedBox(height: 8),
                        _priceRow('Discount',
                            '-₹${order.discount.toStringAsFixed(0)}',
                            color: AppColors.success),
                      ],
                      const Divider(height: 16),
                      _priceRow(
                        'Total',
                        '₹${order.total.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Delivery Address ──
                Text('Delivery Address', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.deliveryAddress['address'] ??
                              '${order.deliveryAddress['flat'] ?? ''}, ${order.deliveryAddress['area'] ?? ''}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Payment Method ──
                Text('Payment Method', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      const Icon(Icons.payment_outlined,
                          color: AppColors.error),
                      const SizedBox(width: 12),
                      Text(order.paymentMethod,
                          style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Actions ──
                if (order.isPending)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => context.go(
                        AppRouter.orderCancellation,
                        extra: {'orderId': order.id},
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                        ),
                      ),
                      child: Text(
                        'Cancel Order',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                if (order.isOnTheWay)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => context.go(
                        AppRouter.trackingMap,
                        extra: {'orderId': order.id},
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                        ),
                      ),
                      child: Text('Track Order', style: AppTextStyles.button),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppTextStyles.label : AppTextStyles.bodySmall,
        ),
        Text(
          value,
          style: (isBold ? AppTextStyles.label : AppTextStyles.bodySmall)
              .copyWith(color: color),
        ),
      ],
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
