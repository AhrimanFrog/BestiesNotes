import 'package:besties_notes/providers/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/db_provider.dart';

class ScheduleRepo<T extends DataProvider> {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  Future<List<Lesson<Student>>> getLessonsForAWeek() async {
    final dbLessons = await dataProvider.getLessonsForWeek();
    return dbLessons.map((details) {
      final students = details.students.values.map(
        (s) => Student(
          name: s.name,
          pricing: Rate(rate: s.pricing, period: s.period),
        ),
      );
      return Lesson(
        name: details.lesson.name,
        subjects: students.toList(),
        start: details.lesson.start,
        duration: Duration(minutes: details.lesson.durationInMinutes),
        notes: details.notes.values.map((n) => n.content).toList(),
      );
    }).toList();
  }
}

final scheduleRepoProvider = Provider((ref) {
  return ScheduleRepo(dataProvider: ref.read(dbProviderRiverpod));
});
