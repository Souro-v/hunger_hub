abstract class RestaurantEvent {}

// ── Fetch All Restaurants ──
class FetchRestaurantsEvent extends RestaurantEvent {}

// ── Fetch Restaurant By Id ──
class FetchRestaurantByIdEvent extends RestaurantEvent {
  final String id;
  FetchRestaurantByIdEvent({required this.id});
}

// ── Fetch By Category ──
class FetchRestaurantsByCategoryEvent extends RestaurantEvent {
  final String category;
  FetchRestaurantsByCategoryEvent({required this.category});
}

// ── Search ──
class SearchRestaurantsEvent extends RestaurantEvent {
  final String query;
  SearchRestaurantsEvent({required this.query});
}

// ── Fetch Categories ──
class FetchCategoriesEvent extends RestaurantEvent {}

// ── Fetch Food Items ──
class FetchFoodItemsEvent extends RestaurantEvent {
  final String restaurantId;
  FetchFoodItemsEvent({required this.restaurantId});
}