import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/local_storage.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Local Storage ──
  await LocalStorage.instance.init();

  // ── Shared Preferences ──
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ── TODO: Firebase Services ──
  // firebase/auth, firestore, storage বানানোর পর add করবো

  // ── TODO: Repositories ──
  // data/repositories বানানোর পর add করবো

  // ── TODO: BLoCs / Cubits ──
  // features/ বানানোর পর add করবো
}

