import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class RecentLessonsSection extends StatelessWidget {
  final List<Lesson> lessons;
  final VoidCallback? onSeeAll;
  final ValueChanged<Lesson>? onLessonTap;

  const RecentLessonsSection({
    super.key,
    this.lessons = const [],
    this.onSeeAll,
    this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Section(
      title: l10n.recentLessons,
      actionLabel: lessons.length > 3 ? l10n.commonSeeAll : null,
      onAction: onSeeAll,
      child: lessons.isEmpty
          ? EmptyState(
              icon: Icons.event_note_outlined,
              title: l10n.noLessonsYet,
              compact: true,
            )
          : Column(
              spacing: AppSpacing.sm,
              children: [
                for (final lesson in lessons.take(3))
                  CompactLessonTile(
                    lesson: lesson,
                    onTap: onLessonTap != null
                        ? () => onLessonTap!(lesson)
                        : null,
                  ),
              ],
            ),
    );
  }
}
