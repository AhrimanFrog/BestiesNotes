import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';

/// One day: a header and that day's lesson cards. A day without lessons
/// collapses to its header.
class ScheduleSection extends StatelessWidget {
  final DateTime date;
  final List<Lesson> lessons;
  final ValueChanged<Lesson> onLessonTap;

  /// Shows an "add lesson on this day" button when set.
  final VoidCallback? onAdd;

  final int? featuredLessonId;
  final bool colorBySubject;

  const ScheduleSection({
    super.key,
    required this.date,
    required this.lessons,
    required this.onLessonTap,
    this.onAdd,
    this.featuredLessonId,
    this.colorBySubject = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          DayTitle(date: date, onAdd: onAdd, muted: lessons.isEmpty),
          for (final lesson in lessons)
            LessonCard(
              lesson: lesson,
              featured: lesson.id != null && lesson.id == featuredLessonId,
              colorBySubject: colorBySubject,
              onTap: () => onLessonTap(lesson),
            ),
          if (lessons.isNotEmpty) const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
