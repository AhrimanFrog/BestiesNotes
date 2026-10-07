import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

class CompactLessonTile extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;

  const CompactLessonTile({super.key, required this.lesson, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tone = lesson.statusTone;
    final isCancelled = lesson.isCancelled;

    return AppCard(
      onTap: onTap,
      stripeColor: context.tokens.tone(tone).fg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  lesson.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isCancelled ? context.tokens.textMuted : null,
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '${lesson.start.toMediumDateFormat()} · ${lesson.start.formatTime(context)}',
                  style: context.textTheme.labelMedium,
                ),
              ],
            ),
          ),
          StatusBadge(label: lesson.statusLabel(context.l10n), tone: tone),
        ],
      ),
    );
  }
}
