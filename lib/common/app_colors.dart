import 'dart:math';
import 'package:flutter/material.dart';

class AppColors {
  static final accentPink = Color(0xFFF291A3);
  static final softPink = Color.fromARGB(255, 228, 193, 199);
  static final softWarmPink = Color(0xFFFBE7E9);
  static final softPastelBlue = Color(0xFFE8F0FA);
  static final pastelBlue = Color(0xFF85A8D0);
  static final secondaryText = Color(0xFF9C9C9C);
  static final mainText = Color(0xFF2E2E2E);
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1);
}
