import 'package:besties_notes/data/calendar_period.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A six-week month grid. Each day shows a dot per lesson (colored by
/// status); tapping selects it.
class MonthGrid extends StatelessWidget {
  /// Any day of the month to show; also the selected day.
  final DateTime selected;
  final int weekStart;
  final Map<DateTime, List<Lesson>> lessonsByDay;
  final ValueChanged<DateTime> onDaySelected;

  const MonthGrid({
    super.key,
    required this.selected,
    required this.weekStart,
    required this.lessonsByDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final (:from, :to) = CalendarPeriod.range(
      CalendarView.month,
      selected,
      weekStart,
    );
    final weekdays = [for (var i = 0; i < 7; i++) from.addDays(i)];

    return Column(
      children: [
        Row(
          children: [
            for (final day in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('EEEEE').format(day),
                    style: context.textTheme.labelMedium,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (var week = 0; week < 6; week++)
          Row(
            children: [
              for (var d = 0; d < 7; d++)
                Expanded(
                  child: _DayCell(
                    day: from.addDays(week * 7 + d),
                    inMonth: from.addDays(week * 7 + d).month == selected.month,
                    isSelected: from.addDays(week * 7 + d).isSameDay(selected),
                    lessons:
                        lessonsByDay[from.addDays(week * 7 + d)] ?? const [],
                    onTap: onDaySelected,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool inMonth;
  final bool isSelected;
  final List<Lesson> lessons;
  final ValueChanged<DateTime> onTap;

  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.isSelected,
    required this.lessons,
    required this.onTap,
  });

  static const _maxDots = 3;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isToday = day.isToday;

    final numberColor = isSelected
        ? tokens.onAccent
        : isToday
        ? tokens.accent
        : inMonth
        ? tokens.text
        : tokens.textSubtle;

    final count = lessons.length;
    final semantics = [
      day.toLongDateFormat(),
      if (isToday) 'today',
      count == 0 ? 'no lessons' : (count == 1 ? '1 lesson' : '$count lessons'),
    ].join(', ');

    return Semantics(
      button: true,
      selected: isSelected,
      label: semantics,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onTap(day),
        borderRadius: AppRadius.mdAll,
        child: SizedBox(
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 3,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? tokens.accent : null,
                  border: isToday && !isSelected
                      ? Border.all(color: tokens.accent, width: 1.5)
                      : null,
                ),
                child: Text(
                  '${day.day}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: numberColor,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : null,
                  ),
                ),
              ),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    for (final lesson in lessons.take(_maxDots))
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tokens
                              .tone(lesson.statusTone)
                              .fg
                              .withValues(alpha: inMonth ? 1 : 0.4),
                        ),
                      ),
                    if (count > _maxDots)
                      Icon(Icons.add, size: 6, color: tokens.textMuted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
