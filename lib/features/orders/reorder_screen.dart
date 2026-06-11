import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/app_button.dart';
import '../cart/cart_cubit.dart';

class ReorderScreen extends StatefulWidget {
  final OrderModel order;

  const ReorderScreen({super.key, required this.order});

  @override
  State<ReorderScreen> createState() => _ReorderScreenState();
}

class _ReorderScreenState extends State<ReorderScreen> {
  late List<bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems =
        List.filled(widget.order.items.length, true);
  }

  void _addToCart() {
    final cubit = context.read<CartCubit>();
    cubit.clearCart();

    for (int i = 0; i < widget.order.items.length; i++) {
      if (_selectedItems[i]) {
        final item = widget.order.items[i];
        for (int q = 0; q < item.quantity; q++) {
          cubit.addItem(item.foodItem);
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Items added to cart!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    context.go(AppRouter.cart);
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
                  Text('Reorder', style: AppTextStyles.h3),
                ],
              ),
            ),

            // ── Restaurant ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(AppConstants.radiusLG),
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
                    const Icon(Icons.restaurant_outlined,
                        color: AppColors.error),
                    const SizedBox(width: 12),
                    Text(widget.order.restaurantName,
                        style: AppTextStyles.label),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Items ──
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
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
                        // ── Checkbox ──
                        Checkbox(
                          value: _selectedItems[index],
                          activeColor: AppColors.error,
                          onChanged: (val) => setState(
                                  () => _selectedItems[index] = val!),
                        ),

                        // ── Image ──
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.foodItem.imageUrl
                              .startsWith('assets')
                              ? Image.asset(
                            item.foodItem.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            item.foodItem.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.divider,
                                  child: const Icon(Icons.fastfood,
                                      color: AppColors.textHint),
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
                              Text(item.foodItem.name,
                                  style: AppTextStyles.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  '${item.quantity}x • ₹${item.totalPrice.toStringAsFixed(0)}',
                                  style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Add to Cart ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppButton(
                text: 'Add to Cart',
                color: AppColors.error,
                onPressed: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}