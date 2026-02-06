import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/views/modals/lesson_form.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCard extends StatelessWidget {
  final List<Lesson> lessons;
  final DateTime date;

  const ScheduleCard({super.key, required this.date, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DayTitle(
            weekDay: date.capsWeekday(),
            date: "${date.day}.${date.month}",
          ),
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
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<LessonsCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<StudentsAndGroupsCubit>(),
                            ),
                          ],
                          child: LessonForm(lesson),
                        ),
                        backgroundColor: Colors.transparent,
                        useSafeArea: true,
                        isScrollControlled: true,
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
