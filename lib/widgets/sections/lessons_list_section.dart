import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/widgets/cards/schedule_card.dart';
import 'package:besties_notes/widgets/layout/gradient_background.dart';
import 'package:besties_notes/widgets/layout/state_transition_widget.dart';
import 'package:flutter/material.dart';

class LessonsListSection extends StatelessWidget {
  final LessonsState state;

  const LessonsListSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: StateTransitionWidget(
        state: state,
        child: ListView(
          children: [
            for (final entry in state.getLessonsByDate().entries)
              ScheduleCard(date: entry.key, lessons: entry.value),
          ],
        ),
      ),
    );
  }
}
