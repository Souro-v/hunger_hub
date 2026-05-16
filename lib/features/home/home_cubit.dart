import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/exceptions.dart';
import '../../core/storage/local_storage.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../data/repositories/user_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RestaurantRepository _restaurantRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;

  HomeCubit({
    required RestaurantRepository restaurantRepository,
    required UserRepository userRepository,
    required LocalStorage localStorage,
  })  : _restaurantRepository = restaurantRepository,
        _userRepository = userRepository,
        _localStorage = localStorage,
        super(HomeInitial());

  // ── Load Home Data ──
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      // ── Get User ──
      final userId = _localStorage.getUserId();
      String userName = 'User';
      String deliveryAddress = 'Select address';

      if (userId != null) {
        try {
          final user = await _userRepository.getUser(userId);
          userName = user.name;
          if (user.addresses.isNotEmpty) {
            deliveryAddress =
                user.addresses.first['area'] ?? 'Select address';
          }
        } catch (_) {}
      }

      // ── Get Restaurants ──
      final restaurants =
      await _restaurantRepository.getAllRestaurants();

      // ── Get Categories ──
      final categories = await _restaurantRepository.getCategories();

      emit(HomeLoaded(
        featuredRestaurants: restaurants,
        categories: categories,
        userName: userName,
        deliveryAddress: deliveryAddress,
      ));
    } on ServerException catch (e) {
      emit(HomeError(message: e.message));
    } catch (e) {
      emit(HomeError(message: 'Something went wrong'));
    }
  }
}