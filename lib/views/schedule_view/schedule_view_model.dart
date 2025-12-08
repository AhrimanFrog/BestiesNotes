import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';

class ScheduleViewModel {
  final ScheduleRepo scheduleRepo;

  const ScheduleViewModel({required this.scheduleRepo});

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
