import 'package:besties_notes/common/app_colors.dart';
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
        title: Text("Schedule", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
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
        builder: (_, state) => LessonsListSection(state: state),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<LessonsCubit>()),
              BlocProvider.value(value: context.read<StudentsAndGroupsCubit>()),
            ],
            child: LessonForm(null),
          ),
          backgroundColor: AppColors.accent,
          useSafeArea: true,
          isScrollControlled: true,
        ),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
