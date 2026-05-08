import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // ── Vertical Space ──
  static const SizedBox xs = SizedBox(height: 4);
  static const SizedBox sm = SizedBox(height: 8);
  static const SizedBox md = SizedBox(height: 16);
  static const SizedBox lg = SizedBox(height: 24);
  static const SizedBox xl = SizedBox(height: 32);
  static const SizedBox xxl = SizedBox(height: 48);

  // ── Horizontal Space ──
  static const SizedBox hXs = SizedBox(width: 4);
  static const SizedBox hSm = SizedBox(width: 8);
  static const SizedBox hMd = SizedBox(width: 16);
  static const SizedBox hLg = SizedBox(width: 24);
  static const SizedBox hXl = SizedBox(width: 32);

  // ── Padding ──
  static const EdgeInsets paddingXS = EdgeInsets.all(4);
  static const EdgeInsets paddingSM = EdgeInsets.all(8);
  static const EdgeInsets paddingMD = EdgeInsets.all(16);
  static const EdgeInsets paddingLG = EdgeInsets.all(24);

  static const EdgeInsets paddingHorizontalMD =
  EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingHorizontalLG =
  EdgeInsets.symmetric(horizontal: 24);

  static const EdgeInsets paddingVerticalMD =
  EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets paddingVerticalLG =
  EdgeInsets.symmetric(vertical: 24);

  // ── Screen Padding ──
  static const EdgeInsets screenPadding =
  EdgeInsets.symmetric(horizontal: 20, vertical: 16);
}