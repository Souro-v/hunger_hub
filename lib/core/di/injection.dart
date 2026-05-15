import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/auth_bloc.dart';
import '../../features/cart/cart_cubit.dart';
import '../storage/local_storage.dart';
import '../../firebase/auth/firebase_auth_service.dart';
import '../../firebase/firestore/restaurant_service.dart';
import '../../firebase/firestore/order_service.dart';
import '../../firebase/firestore/user_service.dart';
import '../../firebase/storage/storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/user_repository.dart';
final GetIt sl = GetIt.instance;
Future<void> configureDependencies() async {
  // ── Local Storage ──
  await LocalStorage.instance.init();
  // ── Shared Preferences ──
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  // ── Firebase Services ──
  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(),
  );
  sl.registerLazySingleton<RestaurantService>(
    () => RestaurantService(),
  );
  sl.registerLazySingleton<OrderService>(
    () => OrderService(),
  );
  sl.registerLazySingleton<UserService>(
    () => UserService(),
  );
  sl.registerLazySingleton<StorageService>(
    () => StorageService(),
  );
  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      authService: sl<FirebaseAuthService>(),
      userService: sl<UserService>(),
      localStorage: LocalStorage.instance,
    ),
  );
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepository(
      restaurantService: sl<RestaurantService>(),
    ),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepository(
      orderService: sl<OrderService>(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(
      userService: sl<UserService>(),
      storageService: sl<StorageService>(),
    ),
  );
  // ── BLoCs ──
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      authRepository: sl<AuthRepository>(),
    ),
  );
  // ── Cubits ──
  sl.registerFactory<CartCubit>(
        () => CartCubit(),
  );
}
