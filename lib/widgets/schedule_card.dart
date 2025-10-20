import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/lesson_card.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';
import 'package:besties_notes/views/lesson_view/lesson_view.dart';

class ScheduleCard extends StatelessWidget {
  final List<Lesson> lessons = [Lesson.demoActive(), Lesson.demoNonActive()];

  ScheduleCard({super.key});

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
              spacing: 14,
              children: [
                for (final lesson in lessons)
                  LessonCard(
                    lesson: lesson,
                    onClick: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => LessonView(lesson: lesson),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
