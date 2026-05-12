import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  int _currentNavIndex = 0;

  final List<Map<String, String>> _foodCategories = [
    {'image': AppAssets.foodCat1, 'label': 'Tandoori'},
    {'image': AppAssets.foodCat2, 'label': 'Grill'},
    {'image': AppAssets.foodCat3, 'label': 'Chicken'},
    {'image': AppAssets.foodCat4, 'label': 'Mutt'},
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      'image': AppAssets.menu1,
      'name': 'Gunpowder chicken wings',
      'desc': 'Chicken wings, green, spring onions, fresh mint, garlic',
      'rating': 4.5,
    },
    {
      'image': AppAssets.menu2,
      'name': 'Lamb and halloumi kebabs',
      'desc': 'Halloumi, lamb mince, lemon, rosemary, red onion',
      'rating': 4.5,
    },
    {
      'image': AppAssets.menu3,
      'name': 'Pepper houmous and turkey burgers',
      'desc': 'Turkey breast mince, new potatoes, rolls, lemon, peppers',
      'rating': 4.5,
    },
    {
      'image': AppAssets.menu4,
      'name': 'Smash burgers.',
      'desc': 'Ground beef chuck, roll, black pepper',
      'rating': 4.5,
    },
    {
      'image': AppAssets.menu5,
      'name': 'Teriyaki wings',
      'desc': 'Chicken wings, soy sauce, toasted sesame seeds, garlic, baking powder',
      'rating': 4.5,
    },
    {
      'image': AppAssets.menu6,
      'name': 'Salmon skewers',
      'desc': '2 x 500g packs frozen boneless salmon fillets, defrosted, skin removed, cut into 3cm chunks',
      'rating': 4.5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner ──
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.asset(
                      AppAssets.rest8,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ── Breadcrumb ──
                  Positioned(
                    top: 12,
                    left: 16,
                    child: Row(
                      children: [
                        _breadcrumb('Home'),
                        _breadcrumbArrow(),
                        _breadcrumb('location'),
                        _breadcrumbArrow(),
                        _breadcrumb('food'),
                        _breadcrumbArrow(),
                        _breadcrumb('about us'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Restaurant Info ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('House of BBQ', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      'Chinese  Africian Deshi food',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 10),

                    // ── Rating ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.star,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 12, color: AppColors.textWhite),
                              const SizedBox(width: 4),
                              Text(
                                '4.5',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '127+ ratings',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Divider ──
                    const Divider(),
                    const SizedBox(height: 6),

                    // ── Time & Location ──
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text('20-25 min . 3 km',
                            style: AppTextStyles.bodySmall),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          color: AppColors.border,
                        ),
                        const SizedBox(width: 8),
                        Text('Peelamedu',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Foods Header ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Foods', style: AppTextStyles.h3),
                        Text(
                          'See all',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Food Categories ──
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _foodCategories.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    _foodCategories[index]['image']!,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _foodCategories[index]['label']!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Recommended ──
                    Text('Recommended For You', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ── Menu Items ──
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Info ──
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: AppTextStyles.label,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['desc'],
                                style: AppTextStyles.caption,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.star,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        size: 10,
                                        color: AppColors.textWhite),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['rating'].toString(),
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // ── Image + ADD ──
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item['image'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () => context.go(AppRouter.cart),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'ADD',
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 0) context.go(AppRouter.home);
          if (index == 1) context.go(AppRouter.restaurant);
          if (index == 2) context.go(AppRouter.orderStatus);
          if (index == 3) context.go(AppRouter.profile);
        },
      ),
    );
  }

  Widget _breadcrumb(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _breadcrumbArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.chevron_right, size: 12, color: AppColors.textWhite),
    );
  }
}