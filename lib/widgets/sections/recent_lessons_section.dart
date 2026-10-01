import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class RecentLessonsSection extends StatelessWidget {
  final List<Lesson> lessons;
  final VoidCallback? onSeeAll;

  const RecentLessonsSection({
    super.key,
    this.lessons = const [],
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Recent lessons',
      actionLabel: lessons.length > 3 ? 'See all' : null,
      onAction: onSeeAll,
      child: lessons.isEmpty
          ? const EmptyState(
              icon: Icons.event_note_outlined,
              title: 'No lessons yet',
              compact: true,
            )
          : Column(
              spacing: AppSpacing.sm,
              children: [
                for (final lesson in lessons.take(3))
                  CompactLessonTile(lesson: lesson),
              ],
            ),
    );
  }
}
