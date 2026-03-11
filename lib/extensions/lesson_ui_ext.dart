import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:flutter/material.dart';

extension LessonUIExt on Lesson {
  Color get accentColor => switch (status) {
    .cancelled => AppColors.accentGrey,
    .completed => AppColors.accentGreen,
    .scheduled => isNow ? AppColors.accentPink : AppColors.pastelBlue,
  };

  Color get mainColor => switch (status) {
    .cancelled => AppColors.softGrey,
    .completed => AppColors.softGreen,
    .scheduled => isNow ? AppColors.softWarmPink : AppColors.softPastelBlue,
  };
}
