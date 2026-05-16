import '../../data/models/category_model.dart';
import '../../data/models/restaurant_model.dart';

abstract class HomeState {}

// ── Initial ──
class HomeInitial extends HomeState {}

// ── Loading ──
class HomeLoading extends HomeState {}

// ── Loaded ──
class HomeLoaded extends HomeState {
  final List<RestaurantModel> featuredRestaurants;
  final List<CategoryModel> categories;
  final String userName;
  final String deliveryAddress;

  HomeLoaded({
    required this.featuredRestaurants,
    required this.categories,
    required this.userName,
    required this.deliveryAddress,
  });
}

// ── Error ──
class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}