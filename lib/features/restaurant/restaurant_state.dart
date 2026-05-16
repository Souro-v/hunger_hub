import '../../data/models/category_model.dart';
import '../../data/models/food_item_model.dart';
import '../../data/models/restaurant_model.dart';

abstract class RestaurantState {}

// ── Initial ──
class RestaurantInitial extends RestaurantState {}

// ── Loading ──
class RestaurantLoading extends RestaurantState {}

// ── Restaurants Loaded ──
class RestaurantsLoaded extends RestaurantState {
  final List<RestaurantModel> restaurants;
  RestaurantsLoaded({required this.restaurants});
}

// ── Restaurant Detail Loaded ──
class RestaurantDetailLoaded extends RestaurantState {
  final RestaurantModel restaurant;
  RestaurantDetailLoaded({required this.restaurant});
}

// ── Categories Loaded ──
class CategoriesLoaded extends RestaurantState {
  final List<CategoryModel> categories;
  CategoriesLoaded({required this.categories});
}

// ── Food Items Loaded ──
class FoodItemsLoaded extends RestaurantState {
  final List<FoodItemModel> foodItems;
  FoodItemsLoaded({required this.foodItems});
}

// ── Search Results ──
class RestaurantSearchResults extends RestaurantState {
  final List<RestaurantModel> results;
  RestaurantSearchResults({required this.results});
}

// ── Error ──
class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError({required this.message});
}

// ── Empty ──
class RestaurantEmpty extends RestaurantState {}