extension StringExtension on String {
  // ── Capitalize ──
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // ── Title Case ──
  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // ── Validate Email ──
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$'); // ← fixed regex
    return emailRegex.hasMatch(this);
  }

  // ── Validate Phone ──
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,13}$');
    return phoneRegex.hasMatch(this);
  }

  // ── Is Empty or Null ──
  bool get isNullOrEmpty => isEmpty;

  // ── Currency Format ──
  String get toCurrency => this; // ← removed unnecessary interpolation
}