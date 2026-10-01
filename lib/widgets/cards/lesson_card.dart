import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  /// The next upcoming or currently running lesson — pulled forward visually.
  final bool featured;
  final bool showQuickActions;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.onCancel,
    this.featured = false,
    this.showQuickActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tone = lesson.statusTone;
    final isCancelled = lesson.isCancelled;

    return AppCard(
      onTap: onTap,
      raised: featured,
      color: featured ? tokens.accentSoft : null,
      stripeColor: tokens.tone(tone).fg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Row(
            children: [
              StatusBadge(label: lesson.uiLabel, tone: tone),
              const Spacer(),
              Text(
                '${lesson.start.toHoursAndMinsFormat()} · ${lesson.duration.inMinutes} min',
                style: context.textTheme.labelMedium,
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            lesson.name,
            style: context.textTheme.titleMedium?.copyWith(
              color: isCancelled ? tokens.textMuted : null,
              decoration: isCancelled ? TextDecoration.lineThrough : null,
            ),
          ),
          Text(
            lesson.audienceLabel(),
            style: context.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (showQuickActions && lesson.isCancellable && onCancel != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                ),
                child: const Text('Cancel lesson'),
              ),
            ),
        ],
      ),
    );
  }
}
