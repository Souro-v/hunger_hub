import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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

class NearbyRestaurantsScreen extends StatefulWidget {
  const NearbyRestaurantsScreen({super.key});

  @override
  State<NearbyRestaurantsScreen> createState() =>
      _NearbyRestaurantsScreenState();
}

class _NearbyRestaurantsScreenState
    extends State<NearbyRestaurantsScreen> {
  String _locationName = 'Getting location...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission =
      await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        setState(() => _locationName = 'Near you');
      }
    } catch (e) {
      setState(() => _locationName = 'Near you');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RestaurantBloc>()
        ..add(FetchRestaurantsEvent()),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nearby Restaurants',
                            style: AppTextStyles.h3),
                        Text(
                          _locationName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
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

                    if (state is RestaurantEmpty) {
                      return Center(
                        child: Text(
                          'No nearby restaurants found',
                          style: AppTextStyles.bodyMedium,
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
                            child: Row(
                              children: [
                                // ── Image ──
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    rest.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Image.asset(
                                          AppAssets.rest1,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                  ),
                                ),

                                // ── Info ──
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(rest.name,
                                            style: AppTextStyles.label,
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text(rest.category,
                                            style:
                                            AppTextStyles.caption,
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.star_rounded,
                                                size: 12,
                                                color: AppColors.star),
                                            const SizedBox(width: 2),
                                            Text(
                                                rest.rating
                                                    .toStringAsFixed(1),
                                                style: AppTextStyles
                                                    .caption),
                                            const SizedBox(width: 6),
                                            const Icon(
                                                Icons
                                                    .access_time_rounded,
                                                size: 12,
                                                color: AppColors
                                                    .textSecondary),
                                            const SizedBox(width: 2),
                                            Text(
                                                '${rest.deliveryTime} min',
                                                style: AppTextStyles
                                                    .caption),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons
                                                    .location_on_outlined,
                                                size: 12,
                                                color: AppColors.error),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                rest.address,
                                                style: AppTextStyles
                                                    .caption,
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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