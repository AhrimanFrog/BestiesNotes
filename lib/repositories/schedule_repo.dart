import 'package:besties_notes/providers/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/db_provider.dart';

class ScheduleRepo<T extends DataProvider> {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  Future<List<Lesson<Student>>> getLessonsForAWeek() async {
    final dbLessons = await dataProvider.getLessonsForWeek();
    final List<Lesson<Student>> lessonsForWeek = [];
    dbLessons.forEach((key, value) {
      final notes = value.map((n) => n.content).toList();
      final lesson = Lesson(
        name: key.name,
        subject: Student.demo(),
        start: key.start,
        duration: Duration(minutes: key.durationInMinutes),
        notes: notes
        );
        lessonsForWeek.add(lesson);
    });
    return lessonsForWeek;
  }
}

final scheduleRepoProvider = Provider((ref) {
  return ScheduleRepo(dataProvider: ref.read(dbProviderRiverpod));
});
