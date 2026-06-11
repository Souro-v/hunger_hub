import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/loading_widget.dart';
import '../restaurant/restaurant_bloc.dart';
import '../restaurant/restaurant_event.dart';
import '../restaurant/restaurant_state.dart';

class FoodCategoryScreen extends StatelessWidget {
  final String category;

  const FoodCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RestaurantBloc>()
        ..add(FetchRestaurantsByCategoryEvent(category: category)),
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
                    Text(category, style: AppTextStyles.h3),
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

                    if (state is RestaurantEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.restaurant_outlined,
                                size: 80, color: AppColors.border),
                            const SizedBox(height: 16),
                            Text(
                              'No restaurants found',
                              style: AppTextStyles.h3.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    final restaurants =
                    state is RestaurantsLoaded
                        ? state.restaurants
                        : [];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final rest = restaurants[index];
                        return GestureDetector(
                          onTap: () => context.go(
                            AppRouter.menuList,
                            extra: {
                              'restaurantId': rest.id,
                              'restaurantName': rest.name,
                              'restaurantImage': rest.imageUrl,
                              'restaurantCategory': rest.category,
                              'restaurantRating': rest.rating,
                              'restaurantDeliveryTime':
                              rest.deliveryTime,
                              'restaurantAddress': rest.address,
                            },
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    rest.imageUrl,
                                    width: double.infinity,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Image.asset(
                                          AppAssets.rest1,
                                          width: double.infinity,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(rest.name,
                                          style: AppTextStyles.h3
                                              .copyWith(fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Text(rest.category,
                                          style:
                                          AppTextStyles.bodySmall),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              size: 14,
                                              color: AppColors.star),
                                          const SizedBox(width: 4),
                                          Text(
                                              rest.rating
                                                  .toStringAsFixed(1),
                                              style:
                                              AppTextStyles.caption),
                                          const SizedBox(width: 8),
                                          const Icon(
                                              Icons.access_time_rounded,
                                              size: 14,
                                              color: AppColors
                                                  .textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                              '${rest.deliveryTime} min',
                                              style:
                                              AppTextStyles.caption),
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
      ),
    );
  }
}