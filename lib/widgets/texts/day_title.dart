import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DayTitle extends StatelessWidget {
  final String weekDay;
  final String date;
  final int lessonsNumber;
  final bool isToday;

  const DayTitle({
    super.key,
    required this.weekDay,
    required this.date,
    required this.lessonsNumber,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = isToday ? tokens.accent : tokens.text;

    return Row(
      spacing: AppSpacing.sm,
      children: [
        Text(
          weekDay,
          style: context.textTheme.titleSmall?.copyWith(color: color),
        ),
        Text(date, style: context.textTheme.labelMedium),
        if (isToday) const _TodayDot(),
        const Spacer(),
        Text(
          lessonsNumber == 1 ? '1 lesson' : '$lessonsNumber lessons',
          style: context.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _TodayDot extends StatelessWidget {
  const _TodayDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: context.tokens.accent,
        shape: BoxShape.circle,
      ),
    );
  }
}
