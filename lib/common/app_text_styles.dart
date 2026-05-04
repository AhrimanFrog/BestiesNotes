import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const headline = TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.mainText);
  static const title    = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainText);
  static const body     = TextStyle(fontSize: 14, color: AppColors.mainText);
  static const bodyBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.mainText);
  static const caption  = TextStyle(fontSize: 12, color: AppColors.secondaryText);
  static const micro    = TextStyle(fontSize: 9,  color: AppColors.secondaryText);
}
