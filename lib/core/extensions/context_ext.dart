import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // ── Screen Size ──
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // ── Theme ──
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // ── Navigation ──
  void pop() => Navigator.of(this).pop();
  void popUntilFirst() =>
      Navigator.of(this).popUntil((route) => route.isFirst);

  // ── SnackBar ──
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ── Keyboard ──
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── Dark Mode ──
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}