import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/widgets/loading_widget.dart';
import '../restaurant/restaurant_bloc.dart';
import '../restaurant/restaurant_event.dart';
import '../restaurant/restaurant_state.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _currentNavIndex = 1;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RestaurantBloc>()..add(FetchRestaurantsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Title ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.h2,
                    children: [
                      TextSpan(
                        text: 'Famous Restaurant ',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      const TextSpan(text: 'For You'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Search Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            if (query.isEmpty) {
                              context
                                  .read<RestaurantBloc>()
                                  .add(FetchRestaurantsEvent());
                            } else {
                              context.read<RestaurantBloc>().add(
                                    SearchRestaurantsEvent(query: query),
                                  );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Search restaurants...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textHint,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.mic_outlined,
                          color: AppColors.textSecondary),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Popular Hotels Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular hotels', style: AppTextStyles.h3),
                    Text(
                      'See all',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Restaurant List ──
              Expanded(
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    if (state is RestaurantLoading) {
                      return const LoadingWidget();
                    }

                    if (state is RestaurantError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<RestaurantBloc>()
                                  .add(FetchRestaurantsEvent()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is RestaurantEmpty) {
                      return Center(
                        child: Text(
                          'No restaurants found',
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }

                    // ── Static fallback ──
                    final restaurants = state is RestaurantsLoaded
                        ? state.restaurants
                        : state is RestaurantSearchResults
                            ? state.results
                            : null;

                    if (restaurants != null && restaurants.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final rest = restaurants[index];
                          return GestureDetector(
                            onTap: () => context.go(AppRouter.menuList),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusLG),
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
                                      errorBuilder: (_, __, ___) => Image.asset(
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
                                            style: AppTextStyles.bodySmall),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.star,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star,
                                                      size: 10,
                                                      color:
                                                          AppColors.textWhite),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    rest.rating
                                                        .toStringAsFixed(1),
                                                    style: AppTextStyles.caption
                                                        .copyWith(
                                                      color:
                                                          AppColors.textWhite,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                                Icons.access_time_rounded,
                                                size: 14,
                                                color: AppColors.textSecondary),
                                            const SizedBox(width: 4),
                                            Text('${rest.deliveryTime} min',
                                                style: AppTextStyles.caption),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.delivery_dining,
                                                size: 14,
                                                color: AppColors.textSecondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              rest.deliveryFee == 0
                                                  ? 'Free delivery'
                                                  : '৳${rest.deliveryFee.toStringAsFixed(0)}',
                                              style: AppTextStyles.caption,
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
                    }

                    // ── Static fallback ──
                    return _buildStaticList(context);
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
            if (index == 2) context.go(AppRouter.orderStatus);
            if (index == 3) context.go(AppRouter.profile);
          },
        ),
      ),
    );
  }

  // ── Static Fallback List ──
  Widget _buildStaticList(BuildContext context) {
    final staticRestaurants = [
      {
        'image': AppAssets.rest1,
        'name': 'Arabian Restaurant',
        'category': 'Chinese',
        'rating': 4.0,
        'time': '45 min',
        'delivery': 'Free delivery',
      },
      {
        'image': AppAssets.rest2,
        'name': 'Golden Restaurant',
        'category': 'Indian',
        'rating': 3.5,
        'time': '25 min',
        'delivery': 'Free delivery',
      },
      {
        'image': AppAssets.rest3,
        'name': 'Italian Restaurants',
        'category': 'Chinese  Italian',
        'rating': 4.2,
        'time': '32 min',
        'delivery': 'Free delivery',
      },
      {
        'image': AppAssets.rest4,
        'name': 'Huking Hub',
        'category': 'Chinese  Italian  Indian',
        'rating': 4.2,
        'time': '32 min',
        'delivery': 'Free delivery',
      },
      {
        'image': AppAssets.rest5,
        'name': 'Star Grills',
        'category': 'Chinese  Italyan  Indian',
        'rating': 4.6,
        'time': '54 min',
        'delivery': 'Free delivery',
      },
      {
        'image': AppAssets.rest6,
        'name': 'House of BBQ',
        'category': 'Chinese  Africian Deshi food',
        'rating': 4.6,
        'time': '54 min',
        'delivery': 'Free delivery',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: staticRestaurants.length,
      itemBuilder: (context, index) {
        final rest = staticRestaurants[index];
        return GestureDetector(
          onTap: () => context.go(AppRouter.menuList),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    rest['image'] as String,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rest['name'] as String,
                          style: AppTextStyles.h3.copyWith(fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(rest['category'] as String,
                          style: AppTextStyles.bodySmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.star,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 10, color: AppColors.textWhite),
                                const SizedBox(width: 2),
                                Text(
                                  rest['rating'].toString(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time_rounded,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(rest['time'] as String,
                              style: AppTextStyles.caption),
                          const SizedBox(width: 8),
                          const Icon(Icons.delivery_dining,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(rest['delivery'] as String,
                              style: AppTextStyles.caption),
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
  }
}
