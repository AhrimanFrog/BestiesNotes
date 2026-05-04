import 'package:besties_notes/common/app_text_styles.dart';
import 'package:flutter/material.dart';

class DayTitle extends StatelessWidget {
  final String weekDay;
  final String date;

  const DayTitle({super.key, required this.weekDay, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weekDay, style: AppTextStyles.headline),
        const SizedBox(height: 4),
        Text(date, style: AppTextStyles.caption),
      ],
    );
  }
}
