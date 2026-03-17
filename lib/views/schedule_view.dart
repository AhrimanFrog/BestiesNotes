import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/views/modals/lesson_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        actions: [
          BlocBuilder<LessonsCubit, LessonsState>(
            builder: (ctx, state) {
              final lessonCubit = ctx.read<LessonsCubit>();
              return WeekNavigationBar(
                timeRange: DateTimeRange(
                  start: state.dateFrom,
                  end: state.dateTo,
                ),
                onRangeSelection: (range) => lessonCubit.fetchLessons(
                  from: range.start,
                  to: range.end.add(const Duration(days: 1)),
                ),
                onTapLeft: lessonCubit.goToPreviousWeek,
                onTapRight: lessonCubit.goToNextWeek,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: context.read<LessonsCubit>().goToCurrentWeek,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<LessonsCubit>()),
                  BlocProvider.value(
                    value: context.read<StudentsAndGroupsCubit>(),
                  ),
                ],
                child: LessonForm(null),
              ),
              backgroundColor: Colors.transparent,
              useSafeArea: true,
              isScrollControlled: true,
            ),
          ),
        ],
      ),
      body: GradientBackground(
        child: BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            return StateTransitionWidget(
              state: state,
              child: ListView(
                children: [
                  for (final entry in state.getLessonsByDate().entries)
                    ScheduleCard(date: entry.key, lessons: entry.value),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
