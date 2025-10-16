import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/lesson_card.dart';
import 'package:besties_notes/widgets/day_title.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DayTitle(weekDay: "MON", date: "29 sep"),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                LessonCard(lesson: Lesson.demoActive()),
                SizedBox(height: 14),
                LessonCard(lesson: Lesson.demoNonActive()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
