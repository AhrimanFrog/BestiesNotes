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
        leading: IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => context.read<LessonsCubit>().goToCurrentWeek(),
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: _WeekNavigationBar(),
        ),
      ),
      body: GradientBackground(
        child: BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            return ListView(
              children: [
                for (final entry in state.getLessonsByDate().entries)
                  ScheduleCard(date: entry.key, lessons: entry.value),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WeekNavigationBar extends StatelessWidget {
  const _WeekNavigationBar();

  String _formatDate(DateTime date) => '${date.day}.${date.month}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        final cubit = context.read<LessonsCubit>();
        final from = state.dateFrom;
        // dateTo is exclusive (midnight after the last day), display dateTo - 1 day
        final to = state.dateTo.subtract(const Duration(days: 1));
        final label = '${_formatDate(from)} – ${_formatDate(to)}';

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: AppColors.accentPink,
              onPressed: cubit.goToPreviousWeek,
            ),
            GestureDetector(
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(start: from, end: to),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.accentPink,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: AppColors.mainText,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (range != null) {
                  cubit.fetchLessons(
                    from: range.start,
                    to: range.end.add(const Duration(days: 1)),
                  );
                }
              },
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainText,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: AppColors.accentPink,
              onPressed: cubit.goToNextWeek,
            ),
          ],
        );
      },
    );
  }
}
