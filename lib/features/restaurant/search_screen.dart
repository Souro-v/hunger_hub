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
import 'restaurant_bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RestaurantBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ── Search Bar ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F8),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Expanded(
                              child:
                                  BlocBuilder<RestaurantBloc, RestaurantState>(
                                builder: (context, state) {
                                  return TextField(
                                    controller: _searchController,
                                    focusNode: _focusNode,
                                    onChanged: (query) {
                                      if (query.isEmpty) {
                                        context.read<RestaurantBloc>().add(
                                              FetchRestaurantsEvent(),
                                            );
                                      } else {
                                        context.read<RestaurantBloc>().add(
                                              SearchRestaurantsEvent(
                                                  query: query),
                                            );
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search dishes, restaurants...',
                                      hintStyle:
                                          AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textHint,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // ── Clear ──
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  context
                                      .read<RestaurantBloc>()
                                      .add(FetchRestaurantsEvent());
                                  setState(() {});
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.textSecondary,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Results ──
              Expanded(
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    // ── Initial ──
                    if (state is RestaurantInitial) {
                      return _buildRecentSearches();
                    }

                    // ── Loading ──
                    if (state is RestaurantLoading) {
                      return const LoadingWidget();
                    }

                    // ── Empty ──
                    if (state is RestaurantEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 80,
                              color: AppColors.border,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching something else',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }

                    // ── Error ──
                    if (state is RestaurantError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }

                    // ── Results ──
                    final restaurants = state is RestaurantsLoaded
                        ? state.restaurants
                        : state is RestaurantSearchResults
                            ? state.results
                            : [];

                    if (restaurants.isEmpty) {
                      return _buildRecentSearches();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final rest = restaurants[index];
                        return GestureDetector(
                          onTap: () => context.go(AppRouter.menuList),
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusMD),
                                  child: Image.network(
                                    rest.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      AppAssets.rest1,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
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
                                      Text(
                                        rest.name,
                                        style: AppTextStyles.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        rest.category,
                                        style: AppTextStyles.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              size: 14, color: AppColors.star),
                                          const SizedBox(width: 4),
                                          Text(
                                            rest.rating.toStringAsFixed(1),
                                            style: AppTextStyles.caption,
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.access_time_rounded,
                                              size: 14,
                                              color: AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${rest.deliveryTime} min',
                                            style: AppTextStyles.caption,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // ── Arrow ──
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColors.textSecondary,
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

  // ── Recent Searches ──
  Widget _buildRecentSearches() {
    final suggestions = [
      'BBQ',
      'Burger',
      'Pizza',
      'Biryani',
      'Chinese',
      'Indian',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Searches', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = suggestion;
                  context.read<RestaurantBloc>().add(
                        SearchRestaurantsEvent(query: suggestion),
                      );
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusCircle),
                  ),
                  child: Text(
                    suggestion,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
