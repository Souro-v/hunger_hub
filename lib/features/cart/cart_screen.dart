import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/cart_model.dart';
import '../../shared/widgets/app_button.dart';
import 'cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<CartCubit, CartModel>(
            builder: (context, cart) {
              return Column(
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.close,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 16),
                        Text('Your order', style: AppTextStyles.h2),
                      ],
                    ),
                  ),

                  // ── Cart Items ──
                  Expanded(
                    child: cart.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: AppColors.border,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                context.go(AppRouter.restaurant),
                            child: Text(
                              'Add items',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return _CartItemTile(
                          item: item,
                          onAdd: () => context
                              .read<CartCubit>()
                              .addItem(item.foodItem),
                          onRemove: () => context
                              .read<CartCubit>()
                              .removeItem(item.foodItem),
                          onDelete: () => context
                              .read<CartCubit>()
                              .deleteItem(item.foodItem),
                        );
                      },
                    ),
                  ),

                  // ── Bottom Section ──
                  if (!cart.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // ── Promo Code ──
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.divider,
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusMD),
                                  ),
                                  child: TextField(
                                    controller: _promoController,
                                    decoration: InputDecoration(
                                      hintText: 'Add Promo code',
                                      hintStyle:
                                      AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<CartCubit>().applyPromo(
                                        _promoController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusMD),
                                    ),
                                  ),
                                  child: Text('Apply',
                                      style: AppTextStyles.button),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Price Breakdown ──
                          _PriceRow(
                            label: 'Total',
                            amount: cart.subtotal,
                            isLight: true,
                          ),
                         const _PriceRow(
                            label: 'Delivery fees',
                            amount: 40,
                            isLight: true,
                          ),
                          _PriceRow(
                            label: 'Promo',
                            amount: cart.discount,
                            isLight: true,
                            isDiscount: true,
                          ),
                          const Divider(),
                          _PriceRow(
                            label: 'Total',
                            amount: cart.total + 40,
                            isLight: false,
                          ),
                          const SizedBox(height: 12),

                          // ── Add More Items ──
                          GestureDetector(
                            onTap: () => context.go(AppRouter.menuList),
                            child: Text(
                              'Add more items',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── Continue to Payment ──
                          AppButton(
                            text: 'CONTINUE TO PAYMENT',
                            color: AppColors.secondary,
                            onPressed: () =>
                                context.go(AppRouter.checkout),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Cart Item Tile ──
class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const _CartItemTile({
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.foodItem.name, style: AppTextStyles.label),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('₹ ', style: TextStyle(fontSize: 13)),
                    Text(
                      item.foodItem.price.toStringAsFixed(0),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // ── Rating ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.star,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 10, color: AppColors.textWhite),
                          const SizedBox(width: 4),
                          Text(
                            item.foodItem.rating.toString(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ── Quantity ──
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.remove, size: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.label,
                      ),
                    ),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add, size: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Image ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.foodItem.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 90,
                    height: 90,
                    color: AppColors.divider,
                    child: const Icon(Icons.fastfood,
                        color: AppColors.textHint),
                  ),
                ),
              ),

              // ── Delete ──
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 12, color: AppColors.textWhite),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Price Row ──
class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isLight;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.amount,
    required this.isLight,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isLight
                ? AppTextStyles.bodySmall
                : AppTextStyles.label,
          ),
          Row(
            children: [
              Text(
                isDiscount ? '- ' : '',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
              const Text('₹ ', style: TextStyle(fontSize: 13)),
              Text(
                amount.toStringAsFixed(0),
                style: isLight
                    ? AppTextStyles.bodySmall
                    : AppTextStyles.label,
              ),
            ],
          ),
        ],
      ),
    );
  }
}