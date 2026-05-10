import '../../core/error/exceptions.dart';
import '../../firebase/firestore/restaurant_service.dart';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../models/restaurant_model.dart';

class RestaurantRepository {
  final RestaurantService _restaurantService;

  RestaurantRepository({required RestaurantService restaurantService})
      : _restaurantService = restaurantService;

  // ── Get All Restaurants ──
  Future<List<RestaurantModel>> getAllRestaurants() async {
    try {
      final data = await _restaurantService.getAllRestaurants();
      return data.map((map) => RestaurantModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurant By Id ──
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final data = await _restaurantService.getRestaurantById(id);
      return RestaurantModel.fromMap(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurants By Category ──
  Future<List<RestaurantModel>> getRestaurantsByCategory(
      String category) async {
    try {
      final data =
      await _restaurantService.getRestaurantsByCategory(category);
      return data.map((map) => RestaurantModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Food Items By Restaurant ──
  Future<List<FoodItemModel>> getFoodItemsByRestaurant(
      String restaurantId) async {
    try {
      final data =
      await _restaurantService.getFoodItemsByRestaurant(restaurantId);
      return data.map((map) => FoodItemModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Categories ──
  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _restaurantService.getCategories();
      return data.map((map) => CategoryModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Search Restaurants ──
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    try {
      final data = await _restaurantService.searchRestaurants(query);
      return data.map((map) => RestaurantModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}