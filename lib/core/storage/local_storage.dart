import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorage {
  LocalStorage._();
  static LocalStorage instance = LocalStorage._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Auth ──
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() => _prefs.getString(AppConstants.tokenKey);

  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.userIdKey, userId);
  }

  String? getUserId() => _prefs.getString(AppConstants.userIdKey);

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(AppConstants.isLoggedInKey, value);
  }

  bool isLoggedIn() => _prefs.getBool(AppConstants.isLoggedInKey) ?? false;

  // ── Onboarding ──
  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(AppConstants.isFirstTimeKey, value);
  }

  bool isFirstTime() => _prefs.getBool(AppConstants.isFirstTimeKey) ?? true;

  // ── Cart ──
  Future<void> saveCart(String cartJson) async {
    await _prefs.setString(AppConstants.cartKey, cartJson);
  }

  String? getCart() => _prefs.getString(AppConstants.cartKey);

  Future<void> clearCart() async {
    await _prefs.remove(AppConstants.cartKey);
  }

  // ── Clear All ──
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}