import 'dart:math';
import 'package:flutter/material.dart';

const activeLessonBg = Color(0xFFE8D4E8);
const activeLessonFg = Color(0xFFB388B3);
const nonActiveLessonBg = Color(0xFFD4E4F7);
const nonActiveLessonFg = Color(0xFF6B9BD1);

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1);
}
