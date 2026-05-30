import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  // ── Load Theme ──
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // ── Toggle Theme ──
  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, !isDark);
    emit(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  bool get isDark => state == ThemeMode.dark;
}