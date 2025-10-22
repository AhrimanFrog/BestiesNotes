// import 'schedule_view_model.dart';
import 'package:besties_notes/views/schedule_view/schedule_view_model.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLessons = ref.watch(scheduleViewModelProvider);
    final viewModel = ref.watch(scheduleViewModelProvider.notifier);

    return asyncLessons.when(
      data: (lessons) {
        final grouped = viewModel.groupeLessons(lessons);
        final sorted = grouped.keys.toList()..sort();
        return GradientBackground(
          child: ListView(
            children: [
              for (final date in sorted)
                ScheduleCard(date: date, lessons: grouped[date] ?? []),
            ],
          ),
        );
      },
      error: (err, _) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
