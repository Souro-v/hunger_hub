import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../firebase/realtime/user_rtdb_service.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/star_rating_widget.dart';

class RestaurantReviewsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantReviewsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantReviewsScreen> createState() =>
      _RestaurantReviewsScreenState();
}

class _RestaurantReviewsScreenState
    extends State<RestaurantReviewsScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final userService = sl<UserRtdbService>();
      final reviews =
      await userService.getReviews(widget.restaurantId);
      final totalRating = reviews.fold(
          0.0, (sum, r) => sum + (r['rating'] ?? 0.0));
      setState(() {
        _reviews = reviews;
        _averageRating =
        reviews.isEmpty ? 0 : totalRating / reviews.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
                  Expanded(
                    child: Text(
                      '${widget.restaurantName} Reviews',
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: _isLoading
                  ? const LoadingWidget()
                  : _reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_outline,
                        size: 80, color: AppColors.border),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews yet',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to review!',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  // ── Rating Summary ──
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20),
                    padding: const EdgeInsets.all(16),
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
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 48,
                            color: AppColors.star,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            StarRatingWidget(
                              rating: _averageRating,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_reviews.length} reviews',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Reviews List ──
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(
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
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                    AppColors.divider,
                                    child: Icon(Icons.person,
                                        color: AppColors
                                            .textSecondary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          review['userName'] ??
                                              'User',
                                          style: AppTextStyles
                                              .label,
                                        ),
                                        StarRatingWidget(
                                          rating: (review['rating'] ??
                                              0.0)
                                              .toDouble(),
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review['comment'] ?? '',
                                style: AppTextStyles
                                    .bodySmall
                                    .copyWith(
                                  color:
                                  AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}