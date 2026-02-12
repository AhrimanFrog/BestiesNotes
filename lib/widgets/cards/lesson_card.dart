import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/widgets/initials_circle.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onClick;

  Color get cardMainColor {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return AppColors.softGrey;
      case LessonStatus.completed:
        return AppColors.softGreen;
      case LessonStatus.scheduled:
        return lesson.isNow ? AppColors.softWarmPink : AppColors.softPastelBlue;
    }
  }

  Color get cardAccentColor {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return AppColors.accentGrey;
      case LessonStatus.completed:
        return AppColors.accentGreen;
      case LessonStatus.scheduled:
        return lesson.isNow ? AppColors.accentPink : AppColors.pastelBlue;
    }
  }

  String get statusLabel {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return 'Cancelled';
      case LessonStatus.completed:
        return 'Completed';
      case LessonStatus.scheduled:
        return lesson.isNow ? 'In Progress' : 'Scheduled';
    }
  }

  const LessonCard({super.key, required this.lesson, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final isCancelled = lesson.isCancelled;
    final opacity = isCancelled ? 0.55 : 1.0;

    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cardMainColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: isCancelled ? 0.2 : 0.5),
                spreadRadius: isCancelled ? 2 : 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.start.toHoursAndMinsFormat(),
                    style: TextStyle(
                      fontSize: 14,
                      color: cardAccentColor,
                      fontWeight: FontWeight.bold,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    lesson.end.toHoursAndMinsFormat(),
                    style: TextStyle(
                      fontSize: 13,
                      color: cardAccentColor.withValues(alpha: 0.8),
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Avatar + details
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InitialsCircle(
                      initials: lesson.subjects.first.initials,
                      circleColor: cardAccentColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${lesson.subjects.first.initials} & ${lesson.subjects.length - 1} more",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.mainText,
                              decoration: isCancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            lesson.name,
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 13,
                              decoration: isCancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cardAccentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: cardAccentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
