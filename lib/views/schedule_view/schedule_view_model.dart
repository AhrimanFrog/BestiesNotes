import 'dart:async';

import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleViewModel extends AsyncNotifier<List<Lesson>> {
  late final ScheduleRepo scheduleRepo;

  @override
  Future<List<Lesson<Teachable>>> build() {
    scheduleRepo = ref.read(scheduleRepoProvider);
    return scheduleRepo.getLessonsForAWeek();
  }

  Map<DateTime, List<Lesson>> groupeLessons(List<Lesson> lessons) {
    final Map<DateTime, List<Lesson>> grouped = {};
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
