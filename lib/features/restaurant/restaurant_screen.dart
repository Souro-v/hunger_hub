import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _currentNavIndex = 1;
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _restaurants = [
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

  List<Map<String, dynamic>> get _filteredRestaurants {
    if (_searchController.text.isEmpty) return _restaurants;
    return _restaurants.where((r) {
      return r['name']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  borderRadius:
                  BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final rest = _filteredRestaurants[index];
                  return GestureDetector(
                    onTap: () => context.go(AppRouter.restaurant),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                        BorderRadius.circular(AppConstants.radiusLG),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Image ──
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              rest['image'],
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // ── Info ──
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rest['name'],
                                    style: AppTextStyles.h3
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(rest['category'],
                                    style: AppTextStyles.bodySmall),
                                const SizedBox(height: 8),

                                // ── Rating Row ──
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
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
                                              color: AppColors.textWhite),
                                          const SizedBox(width: 2),
                                          Text(
                                            rest['rating'].toString(),
                                            style: AppTextStyles.caption
                                                .copyWith(
                                              color: AppColors.textWhite,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.access_time_rounded,
                                        size: 14,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(rest['time'],
                                        style: AppTextStyles.caption),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.delivery_dining,
                                        size: 14,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(rest['delivery'],
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
    );
  }
}