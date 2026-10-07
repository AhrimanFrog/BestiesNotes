import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/schedule_section.dart';
import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:besties_notes/widgets/layout/state_transition_widget.dart';
import 'package:flutter/material.dart';

class LessonsListSection extends StatelessWidget {
  final LessonsState state;
  final ValueChanged<Lesson> onLessonTap;

  /// Shown when there are no lessons; defaults to a generic message.
  final Widget? empty;

  const LessonsListSection({
    super.key,
    required this.state,
    required this.onLessonTap,
    this.empty,
  });

  @override
  Widget build(BuildContext context) {
    return StateTransitionWidget(
      state: state,
      empty:
          empty ??
          EmptyState(
            icon: Icons.event_note_outlined,
            title: context.l10n.noLessonsYet,
          ),
      child: ListView(
        // Leave room so the last card isn't hidden behind the FAB.
        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 96),
        children: [
          for (final entry in state.getLessonsByDate().entries)
            ScheduleSection(
              date: entry.key,
              lessons: entry.value,
              onLessonTap: onLessonTap,
            ),
        ],
      ),
    );
  }
}
