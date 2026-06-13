import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/food_item_model.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/food_item_detail_sheet.dart';
import '../../shared/widgets/loading_widget.dart';
import '../cart/cart_cubit.dart';
import '../restaurant/restaurant_bloc.dart';
import '../restaurant/restaurant_event.dart';
import '../restaurant/restaurant_state.dart';

class PopularItemsScreen extends StatefulWidget {
  const PopularItemsScreen({super.key});

  @override
  State<PopularItemsScreen> createState() => _PopularItemsScreenState();
}

class _PopularItemsScreenState extends State<PopularItemsScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RestaurantBloc>()..add(FetchRestaurantsEvent()),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Popular Items', style: AppTextStyles.h3),
                        Text(
                          'Most ordered items',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    if (state is RestaurantLoading) {
                      return const LoadingWidget();
                    }

                    // ── Static popular items ──
                    final popularItems = [
                      {
                        'image': AppAssets.menu1,
                        'name': 'Gunpowder chicken wings',
                        'desc':
                            'Chicken wings, green, spring onions, fresh mint, garlic',
                        'rating': 4.8,
                        'price': 225.0,
                        'restaurant': 'House of BBQ',
                        'orders': '1.2k+',
                        'ingredients': [
                          'chicken',
                          'spring onions',
                          'mint',
                          'garlic'
                        ],
                      },
                      {
                        'image': AppAssets.menu2,
                        'name': 'Lamb and halloumi kebabs',
                        'desc':
                            'Halloumi, lamb mince, lemon, rosemary, red onion',
                        'rating': 4.7,
                        'price': 324.0,
                        'restaurant': 'Star Grills',
                        'orders': '980+',
                        'ingredients': [
                          'halloumi',
                          'lamb',
                          'lemon',
                          'rosemary'
                        ],
                      },
                      {
                        'image': AppAssets.menu4,
                        'name': 'Smash burgers',
                        'desc': 'Ground beef chuck, roll, black pepper',
                        'rating': 4.9,
                        'price': 99.0,
                        'restaurant': 'Huking Hub',
                        'orders': '2.1k+',
                        'ingredients': ['beef', 'roll', 'black pepper'],
                      },
                      {
                        'image': AppAssets.menu5,
                        'name': 'Teriyaki wings',
                        'desc':
                            'Chicken wings, soy sauce, toasted sesame seeds',
                        'rating': 4.6,
                        'price': 179.0,
                        'restaurant': 'Arabian Restaurant',
                        'orders': '756+',
                        'ingredients': ['chicken', 'soy sauce', 'sesame'],
                      },
                      {
                        'image': AppAssets.menu3,
                        'name': 'Turkey burgers',
                        'desc':
                            'Turkey breast mince, new potatoes, rolls, lemon',
                        'rating': 4.5,
                        'price': 199.0,
                        'restaurant': 'Golden Restaurant',
                        'orders': '634+',
                        'ingredients': ['turkey', 'potatoes', 'lemon'],
                      },
                      {
                        'image': AppAssets.menu6,
                        'name': 'Salmon skewers',
                        'desc': 'Fresh salmon fillets, herbs, lemon',
                        'rating': 4.7,
                        'price': 299.0,
                        'restaurant': 'Italian Restaurants',
                        'orders': '512+',
                        'ingredients': ['salmon', 'herbs', 'lemon'],
                      },
                    ];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: popularItems.length,
                      itemBuilder: (context, index) {
                        final item = popularItems[index];
                        return GestureDetector(
                          onTap: () {
                            final foodItem = FoodItemModel(
                              id: item['name'] as String,
                              restaurantId: 'rest_006',
                              name: item['name'] as String,
                              description: item['desc'] as String,
                              imageUrl: item['image'] as String,
                              price: item['price'] as double,
                              rating: item['rating'] as double,
                              category: 'Popular',
                              isAvailable: true,
                              isPopular: true,
                              ingredients: List<String>.from(
                                  item['ingredients'] as List),
                            );
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => FoodItemDetailSheet(
                                foodItem: foodItem,
                                onAddToCart: () {
                                  context.read<CartCubit>().addItem(foodItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${foodItem.name} added!'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                            child: Row(
                              children: [
                                // ── Image ──
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        item['image'] as String,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.error,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '🔥 Popular',
                                          style: AppTextStyles.caption.copyWith(
                                            color: Colors.white,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // ── Info ──
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name'] as String,
                                          style: AppTextStyles.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(item['restaurant'] as String,
                                          style: AppTextStyles.caption.copyWith(
                                              color: AppColors.error)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              size: 12, color: AppColors.star),
                                          const SizedBox(width: 2),
                                          Text(
                                              (item['rating'] as double)
                                                  .toString(),
                                              style: AppTextStyles.caption),
                                          const SizedBox(width: 8),
                                          const Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 12,
                                              color: AppColors.textSecondary),
                                          const SizedBox(width: 2),
                                          Text(item['orders'] as String,
                                              style: AppTextStyles.caption),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹${(item['price'] as double).toStringAsFixed(0)}',
                                            style: AppTextStyles.label.copyWith(
                                                color: AppColors.error),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              final foodItem = FoodItemModel(
                                                id: item['name'] as String,
                                                restaurantId: 'rest_006',
                                                name: item['name'] as String,
                                                description:
                                                    item['desc'] as String,
                                                imageUrl:
                                                    item['image'] as String,
                                                price: item['price'] as double,
                                                rating:
                                                    item['rating'] as double,
                                                category: 'Popular',
                                                isAvailable: true,
                                                isPopular: true,
                                              );
                                              context
                                                  .read<CartCubit>()
                                                  .addItem(foodItem);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${foodItem.name} added!'),
                                                  backgroundColor:
                                                      AppColors.success,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.error,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'ADD',
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() => _currentNavIndex = index);
            if (index == 0) context.go(AppRouter.home);
            if (index == 1) context.go(AppRouter.search);
            if (index == 2) context.go(AppRouter.orderStatus);
            if (index == 3) context.go(AppRouter.profile);
          },
        ),
      ),
    );
  }
}
