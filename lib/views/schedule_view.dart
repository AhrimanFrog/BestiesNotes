import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  /// Lesson screens can change anything shown here, so refresh on return.
  Future<void> _thenRefresh(BuildContext context, Future<void> route) async {
    await route;
    if (context.mounted) await context.read<LessonsCubit>().refresh();
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
          onLessonTap: (lesson) =>
              _thenRefresh(context, context.openLesson(lesson.id!)),
          empty: EmptyState(
            icon: Icons.event_available_outlined,
            title: 'A free week',
            message: 'No lessons planned for these dates.',
            actionLabel: 'Plan a lesson',
            onAction: () => _thenRefresh(context, context.createLesson()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _thenRefresh(context, context.createLesson()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Lesson'),
      ),
    );
  }
}
