import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:flutter/material.dart';

class LessonRow extends StatelessWidget {
  final Lesson lesson;

  const LessonRow({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time column
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              lesson.start.toHoursAndMinsFormat(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              lesson.start.add(lesson.duration).toHoursAndMinsFormat(),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Event card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lesson.isNow ? activeLessonBg : nonActiveLessonBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Initials circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      lesson.students.first.initials,
                      style: TextStyle(
                        color: lesson.isNow
                            ? activeLessonFg
                            : nonActiveLessonFg,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Name and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.students.join(", "),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        lesson.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
