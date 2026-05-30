import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import 'order_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderCancellationScreen extends StatefulWidget {
  final String orderId;

  const OrderCancellationScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderCancellationScreen> createState() =>
      _OrderCancellationScreenState();
}

class _OrderCancellationScreenState extends State<OrderCancellationScreen> {
  String? _selectedReason;

  final List<String> _reasons = [
    'I changed my mind',
    'Wrong order placed',
    'Delivery time is too long',
    'Found a better option',
    'Payment issue',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>(),
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Order cancelled successfully!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            context.go(AppRouter.home);
          }
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
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
                      Text('Cancel Order', style: AppTextStyles.h3),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Warning ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusLG),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.error,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Are you sure you want to cancel this order? This action cannot be undone.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Reason ──
                        Text(
                          'Reason for cancellation',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 12),

                        // ── Reason List ──
                        ...(_reasons.map((reason) {
                          final isSelected = _selectedReason == reason;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedReason = reason),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.error.withValues(alpha: 0.05)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusMD),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.error
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.error
                                            : AppColors.border,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.error,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    reason,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isSelected
                                          ? AppColors.error
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  ),
                ),

                // ── Cancel Button ──
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Cancel Order',
                        color: AppColors.error,
                        isLoading: state is OrderLoading,
                        onPressed: _selectedReason == null
                            ? null
                            : () {
                                context.read<OrderBloc>().add(
                                      CancelOrderEvent(
                                        orderId: widget.orderId,
                                      ),
                                    );
                              },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
