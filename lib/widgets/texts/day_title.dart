import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// "MON  28 Sep  •" with an optional "add lesson on this day" button.
class DayTitle extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onAdd;

  /// Dims the title, e.g. for a day without lessons.
  final bool muted;

  const DayTitle({
    super.key,
    required this.date,
    this.onAdd,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isToday = date.isToday;
    final color = isToday
        ? tokens.accent
        : muted
        ? tokens.textMuted
        : tokens.text;

    return SizedBox(
      height: kMinTapTarget,
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          Text(
            date.capsWeekday(),
            style: context.textTheme.titleSmall?.copyWith(color: color),
          ),
          Text(date.toDayMonthFormat(), style: context.textTheme.labelMedium),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: tokens.accentSoft,
                borderRadius: AppRadius.pillAll,
              ),
              child: Text(
                context.l10n.commonToday,
                style: context.textTheme.labelSmall?.copyWith(
                  color: tokens.tone(StatusTone.accent).fg,
                ),
              ),
            ),
          const Spacer(),
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add_rounded, size: 20),
              color: tokens.textMuted,
              tooltip: context.l10n.scheduleAddLessonOn(
                date.toLongDateFormat(),
              ),
              onPressed: onAdd,
            ),
        ],
      ),
    );
  }
}
