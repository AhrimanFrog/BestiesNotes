import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.onCancel,
    this.featured = false,
    this.showQuickActions = true,
  });

  /// The next upcoming or currently running lesson — pulled forward visually.
  final bool featured;
  final bool showQuickActions;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: featured ? AppColors.accent : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: featured ? AppColors.accent : Colors.transparent,
              width: featured ? 2 : 1,
            ),
            boxShadow: featured
                ? const [
                    BoxShadow(
                      color: Color(0x14762741),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusBadge(
                    label: lesson.uiLabel,
                    accentColor: lesson.accentColor,
                  ),
                  const Spacer(),
                  Text(
                    '${lesson.start.toHoursAndMinsFormat()} · ${lesson.duration.inMinutes} min',
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                lesson.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: lesson.isCancelled ? AppColors.muted : AppColors.text,
                  decoration: lesson.isCancelled
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                lesson.audienceLabel(),
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (showQuickActions &&
                  lesson.isCancellable &&
                  onCancel != null) ...[
                const SizedBox(height: 10),
                _SecondaryButton(label: 'Cancel lesson', onPressed: onCancel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.softPink,
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: const BorderSide(color: AppColors.divider),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Karla',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
