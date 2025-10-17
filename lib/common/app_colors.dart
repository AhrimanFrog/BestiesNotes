import 'dart:math';
import 'package:flutter/material.dart';

class AppColors {
  static const accentPink = Color(0xFFF291A3);
  static const softPink = Color.fromARGB(255, 228, 193, 199);
  static const softWarmPink = Color(0xFFFBE7E9);
  static const softPastelBlue = Color(0xFFE8F0FA);
  static const pastelBlue = Color(0xFF85A8D0);
  static const secondaryText = Color(0xFF9C9C9C);
  static const mainText = Color(0xFF2E2E2E);
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1);
}
