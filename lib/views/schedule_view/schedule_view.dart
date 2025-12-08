// import 'schedule_view_model.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   final asyncLessons = viewModel.groupeLessons(lessons);

  //   return asyncLessons.when(
  //     data: (lessons) {
  //       final grouped = viewModel.groupeLessons(lessons);
  //       final sorted = grouped.keys.toList()..sort();
  //       return GradientBackground(
  //         child: ListView(
  //           children: [
  //             for (final date in sorted)
  //               ScheduleCard(date: date, lessons: grouped[date] ?? []),
  //           ],
  //         ),
  //       );
  //     },
  //     error: (err, _) => Center(child: Text('Error: $err')),
  //     loading: () => const Center(child: CircularProgressIndicator()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: ListView(
        children: [
          for (final ls in [Lesson.demoActive(), Lesson.demoNonActive()])
            ScheduleCard(date: ls.start, lessons: [ls]),
        ],
      ),
    );
  }
}
