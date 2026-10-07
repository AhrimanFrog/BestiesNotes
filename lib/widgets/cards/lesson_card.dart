import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/avatar_stack.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

/// A lesson in the schedule: time on the left, then topic, who's coming and,
/// once it has started, attendance and payment at a glance.
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  /// The lesson happening now or up next — pulled forward visually.
  final bool featured;

  /// Color the stripe by the (first) student/group instead of by status.
  final bool colorBySubject;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.featured = false,
    this.colorBySubject = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tone = lesson.statusTone;
    final cancelled = lesson.isCancelled;
    final subjects = lesson.subjects;

    final stripe = colorBySubject && subjects.isNotEmpty
        ? tokens.subjectColor(subjects.first.colorSeed).fg
        : tokens.tone(tone).fg;

    // Featured stands out by elevation and its "Up next" badge; a tinted
    // background would swallow the badge.
    return AppCard(
      onTap: onTap,
      raised: featured,
      stripeColor: stripe,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          _TimeColumn(lesson: lesson),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: Text(
                        lesson.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: cancelled ? tokens.textMuted : null,
                          decoration: cancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    ?_badge(context.l10n),
                  ],
                ),
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    if (subjects.isNotEmpty) AvatarStack(subjects: subjects),
                    Expanded(
                      child: Text(
                        lesson.audienceLabel(context.l10n),
                        style: context.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (_showsTracking)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: _Tracking(lesson: lesson),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// "Scheduled" is the default and would only add noise.
  Widget? _badge(AppLocalizations l10n) {
    if (featured && !lesson.isNow) {
      return StatusBadge(label: l10n.lessonUpNext, tone: StatusTone.accent);
    }
    if (lesson.statusTone == StatusTone.scheduled) return null;
    return StatusBadge(
      label: lesson.statusLabel(l10n),
      tone: lesson.statusTone,
    );
  }

  bool get _showsTracking =>
      !lesson.isCancelled &&
      lesson.participants.isNotEmpty &&
      (lesson.isNow || lesson.isCompleted);
}

class _TimeColumn extends StatelessWidget {
  final Lesson lesson;

  const _TimeColumn({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              lesson.start.formatTime(context),
              style: context.textTheme.titleSmall,
            ),
          ),
          Text(
            context.l10n.durationMinutes(lesson.duration.inMinutes),
            style: context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

/// "2/3 present" and, if anyone hasn't paid, "1 unpaid".
class _Tracking extends StatelessWidget {
  final Lesson lesson;

  const _Tracking({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final participants = lesson.participants;
    final present = participants.where((p) => p.attended).length;
    final unpaid = participants.where((p) => !p.isPaid).length;
    final muted = context.tokens.textMuted;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(Icons.how_to_reg_outlined, size: 16, color: muted),
            Text(
              context.l10n.lessonPresentCount(present, participants.length),
              style: context.textTheme.labelMedium,
            ),
          ],
        ),
        if (unpaid > 0)
          StatusBadge(
            label: context.l10n.lessonUnpaidCount(unpaid),
            tone: StatusTone.warning,
            icon: Icons.payments_outlined,
          ),
      ],
    );
  }
}
