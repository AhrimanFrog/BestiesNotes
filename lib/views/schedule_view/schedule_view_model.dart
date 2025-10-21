import 'dart:async';

import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleViewModel extends AsyncNotifier<List<Lesson>> {
  @override
  FutureOr<List<Lesson<Teachable>>> build() {
    return [
      Lesson.demoActive(),
      Lesson.demoNonActive(),
      Lesson.demoNonActive(),
    ];
  }

  Map<DateTime, List<Lesson>> groupedLessons() {
    final Map<DateTime, List<Lesson>> grouped = {};
    var lessons = state.value ?? [];

    for (final lesson in lessons) {
      final date = DateTime(
        lesson.start.year,
        lesson.start.month,
        lesson.start.day,
      );
      grouped.putIfAbsent(date, () => []).add(lesson);
    }
    return grouped;
  }
}

final scheduleViewModelProvider = AsyncNotifierProvider(ScheduleViewModel.new);
