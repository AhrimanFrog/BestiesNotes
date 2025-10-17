import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/widgets/initials_circle.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;

  Color get cardMainColor =>
      lesson.isNow ? AppColors.softWarmPink : AppColors.softPastelBlue;
  Color get cardAccentColor =>
      lesson.isNow ? AppColors.accentPink : AppColors.pastelBlue;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardMainColor,
        borderRadius: BorderRadius.circular(16),
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
                ),
              ),
              Text(
                lesson.start.add(lesson.duration).toHoursAndMinsFormat(),
                style: TextStyle(
                  fontSize: 13,
                  color: cardAccentColor.withValues(alpha: 0.8),
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
                  initials: lesson.subject.initials,
                  circleColor: cardAccentColor,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.subject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.mainText,
                      ),
                    ),
                    Text(
                      lesson.name,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
