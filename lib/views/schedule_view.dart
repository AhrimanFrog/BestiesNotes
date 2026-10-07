import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  /// Lesson screens can change anything shown here, so refresh on return.
  static Future<void> _thenRefresh(
    BuildContext context,
    Future<void> route,
  ) async {
    await route;
    if (context.mounted) await context.read<LessonsCubit>().refresh();
  }

  static void _open(BuildContext context, Lesson lesson) =>
      _thenRefresh(context, context.openLesson(lesson.id!));

  static void _create(BuildContext context, DateTime day) =>
      _thenRefresh(context, context.createLesson(date: day));

  Future<void> _pickDate(BuildContext context, LessonsState state) async {
    final cubit = context.read<LessonsCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.anchor,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: context.l10n.scheduleGoToDate,
    );
    if (picked != null) await cubit.jumpTo(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        final cubit = context.read<LessonsCubit>();
        final isWeek = state.view == CalendarView.week;
        final l10n = context.l10n;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.scheduleTitle),
            actions: [
              if (!state.showsToday)
                TextButton(
                  onPressed: cubit.goToToday,
                  child: Text(l10n.commonToday),
                ),
              SegmentedButton<CalendarView>(
                segments: [
                  ButtonSegment(
                    value: CalendarView.week,
                    icon: const Icon(Icons.view_agenda_outlined),
                    tooltip: l10n.scheduleWeek,
                  ),
                  ButtonSegment(
                    value: CalendarView.month,
                    icon: const Icon(Icons.calendar_month_outlined),
                    tooltip: l10n.scheduleMonth,
                  ),
                ],
                selected: {state.view},
                showSelectedIcon: false,
                onSelectionChanged: (views) => cubit.setView(views.single),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Column(
                children: [
                  PeriodNavigator(
                    label: state.periodLabel,
                    previousTooltip: isWeek
                        ? l10n.schedulePreviousWeek
                        : l10n.schedulePreviousMonth,
                    nextTooltip: isWeek
                        ? l10n.scheduleNextWeek
                        : l10n.scheduleNextMonth,
                    onPrevious: cubit.goToPrevious,
                    onNext: cubit.goToNext,
                    onLabelTap: () => _pickDate(context, state),
                  ),
                  // Reserve the space so content doesn't jump while loading.
                  SizedBox(
                    height: 2,
                    child: state.isLoading
                        ? const LinearProgressIndicator(minHeight: 2)
                        : null,
                  ),
                ],
              ),
            ),
          ),
          body: GestureDetector(
            // Swipe sideways to change week/month.
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity < -300) cubit.goToNext();
              if (velocity > 300) cubit.goToPrevious();
            },
            child: StateTransitionWidget(
              state: state,
              isEmpty: false,
              loadingOverlay: false,
              onRetry: cubit.fetchLessons,
              child: isWeek
                  ? _WeekView(state: state)
                  : _MonthView(state: state),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            // Both tabs' FABs live on in the shell; default hero tags clash.
            heroTag: null,
            onPressed: () => _create(context, state.defaultNewLessonDay),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.scheduleNewLesson),
          ),
        );
      },
    );
  }
}

class _WeekView extends StatelessWidget {
  final LessonsState state;

  const _WeekView({required this.state});

  @override
  Widget build(BuildContext context) {
    final featuredId = state.featuredLesson?.id;

    return ListView(
      // Leave room so the last card isn't hidden behind the FAB.
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 96),
      children: [
        if (state.lessons.isEmpty && !state.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: EmptyState(
              icon: Icons.event_available_outlined,
              title: context.l10n.scheduleFreeWeekTitle,
              message: context.l10n.scheduleFreeWeekMessage,
              compact: true,
            ),
          ),
        for (final day in state.days)
          ScheduleSection(
            date: day,
            lessons: state.lessonsOn(day),
            featuredLessonId: featuredId,
            onLessonTap: (lesson) => SchedulePage._open(context, lesson),
            onAdd: () => SchedulePage._create(context, day),
          ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  final LessonsState state;

  const _MonthView({required this.state});

  @override
  Widget build(BuildContext context) {
    final selected = state.anchor;
    final lessons = state.lessonsOn(selected);

    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 96),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: MonthGrid(
            selected: selected,
            weekStart: state.weekStart,
            lessonsByDay: state.getLessonsByDate(),
            onDaySelected: context.read<LessonsCubit>().selectDay,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(),
        ),
        ScheduleSection(
          date: selected,
          lessons: lessons,
          featuredLessonId: state.featuredLesson?.id,
          onLessonTap: (lesson) => SchedulePage._open(context, lesson),
          onAdd: () => SchedulePage._create(context, selected),
        ),
        if (lessons.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Text(
              context.l10n.scheduleNothingPlanned,
              style: context.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
