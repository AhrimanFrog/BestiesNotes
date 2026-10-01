import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/views/modals/lesson_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  void _createLesson(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<LessonsCubit>()),
          BlocProvider.value(value: context.read<StudentsAndGroupsCubit>()),
        ],
        child: LessonForm(null),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: BlocBuilder<LessonsCubit, LessonsState>(
            builder: (ctx, state) {
              final lessonCubit = ctx.read<LessonsCubit>();
              return WeekNavigationBar(
                timeRange: DateTimeRange(
                  start: state.dateFrom,
                  end: state.dateTo,
                ),
                onRangeSelection: (range) =>
                    lessonCubit.fetchLessons(from: range.start, to: range.end),
                onTapLeft: lessonCubit.goToPreviousWeek,
                onTapRight: lessonCubit.goToNextWeek,
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (_, state) => LessonsListSection(
          state: state,
          empty: EmptyState(
            icon: Icons.event_available_outlined,
            title: 'A free week',
            message: 'No lessons planned for these dates.',
            actionLabel: 'Plan a lesson',
            onAction: () => _createLesson(context),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createLesson(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Lesson'),
      ),
    );
  }
}
