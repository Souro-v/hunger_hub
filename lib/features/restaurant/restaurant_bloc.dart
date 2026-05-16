import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/exceptions.dart';
import '../../data/repositories/restaurant_repository.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository _restaurantRepository;

  RestaurantBloc({required RestaurantRepository restaurantRepository})
      : _restaurantRepository = restaurantRepository,
        super(RestaurantInitial()) {
    on<FetchRestaurantsEvent>(_onFetchRestaurants);
    on<FetchRestaurantByIdEvent>(_onFetchRestaurantById);
    on<FetchRestaurantsByCategoryEvent>(_onFetchByCategory);
    on<SearchRestaurantsEvent>(_onSearchRestaurants);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchFoodItemsEvent>(_onFetchFoodItems);
  }

  // ── Fetch All Restaurants ──
  Future<void> _onFetchRestaurants(
      FetchRestaurantsEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final restaurants =
      await _restaurantRepository.getAllRestaurants();
      if (restaurants.isEmpty) {
        emit(RestaurantEmpty());
      } else {
        emit(RestaurantsLoaded(restaurants: restaurants));
      }
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }

  // ── Fetch Restaurant By Id ──
  Future<void> _onFetchRestaurantById(
      FetchRestaurantByIdEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final restaurant =
      await _restaurantRepository.getRestaurantById(event.id);
      emit(RestaurantDetailLoaded(restaurant: restaurant));
    } on DataNotFoundException {
      emit(RestaurantError(message: 'Restaurant not found'));
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }

  // ── Fetch By Category ──
  Future<void> _onFetchByCategory(
      FetchRestaurantsByCategoryEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await _restaurantRepository
          .getRestaurantsByCategory(event.category);
      if (restaurants.isEmpty) {
        emit(RestaurantEmpty());
      } else {
        emit(RestaurantsLoaded(restaurants: restaurants));
      }
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }

  // ── Search ──
  Future<void> _onSearchRestaurants(
      SearchRestaurantsEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final results =
      await _restaurantRepository.searchRestaurants(event.query);
      if (results.isEmpty) {
        emit(RestaurantEmpty());
      } else {
        emit(RestaurantSearchResults(results: results));
      }
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }

  // ── Fetch Categories ──
  Future<void> _onFetchCategories(
      FetchCategoriesEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final categories = await _restaurantRepository.getCategories();
      if (categories.isEmpty) {
        emit(RestaurantEmpty());
      } else {
        emit(CategoriesLoaded(categories: categories));
      }
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }

  // ── Fetch Food Items ──
  Future<void> _onFetchFoodItems(
      FetchFoodItemsEvent event,
      Emitter<RestaurantState> emit,
      ) async {
    emit(RestaurantLoading());
    try {
      final foodItems = await _restaurantRepository
          .getFoodItemsByRestaurant(event.restaurantId);
      if (foodItems.isEmpty) {
        emit(RestaurantEmpty());
      } else {
        emit(FoodItemsLoaded(foodItems: foodItems));
      }
    } on ServerException catch (e) {
      emit(RestaurantError(message: e.message));
    } catch (e) {
      emit(RestaurantError(message: 'Something went wrong'));
    }
  }
}