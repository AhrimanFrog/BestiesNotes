import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';

/// One day of the schedule: a header and that day's lesson cards.
class ScheduleSection extends StatelessWidget {
  final List<Lesson> lessons;
  final DateTime date;
  final ValueChanged<Lesson> onLessonTap;

  const ScheduleSection({
    super.key,
    required this.date,
    required this.lessons,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          DayTitle(
            weekDay: date.capsWeekday(),
            date: date.toDateFormat(),
            lessonsNumber: lessons.length,
            isToday: date.dateOnly == DateTime.now().dateOnly,
          ),
          for (final lesson in lessons)
            LessonCard(lesson: lesson, onTap: () => onLessonTap(lesson)),
        ],
      ),
    );
  }
}
