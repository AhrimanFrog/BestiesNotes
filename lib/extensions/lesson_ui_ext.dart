import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:flutter/material.dart';

extension LessonUIExt on Lesson {
  Color get accentColor {
    if (isCancelled) return AppColors.accentGrey;
    if (isCompleted) return AppColors.accentGreen;
    return isNow ? AppColors.accentPink : AppColors.pastelBlue;
  }

  Color get mainColor {
    if (isCancelled) return AppColors.softGrey;
    if (isCompleted) return AppColors.softGreen;
    return isNow ? AppColors.softWarmPink : AppColors.softPastelBlue;
  }

  String get uiLabel {
    if (isCancelled) return 'Cancelled';
    if (isCompleted) return 'Completed';
    return isNow ? 'In Progress' : 'Scheduled';
  }
}
