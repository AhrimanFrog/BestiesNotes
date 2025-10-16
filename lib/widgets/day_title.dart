import 'package:flutter/material.dart';
import 'package:besties_notes/common/app_colors.dart';

class DayTitle extends StatelessWidget {
  final String weekDay;
  final String date;

  const DayTitle({
    super.key,
    required this.weekDay,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weekDay,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.mainText,
          ),
        ),
        SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
        ),
      ],
    );
  }
}