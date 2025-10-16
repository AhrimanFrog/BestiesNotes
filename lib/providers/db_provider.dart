import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db_provider.g.dart';

@DriftDatabase(tables: [Lessons, Students, StudentsLessons, RoadmapNodes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'besties_notes_db');
  }
}

class DbProvider extends DataProvider {
  late final AppDatabase _db;

  DbProvider({required AppDatabase db}) : _db = db;

  AppDatabase get database => _db;

  Future<List<Lesson>> getLessonsForTheWeek() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfTheWeek = startOfToday.add(Duration(days: 7));
    return (_db.select(_db.lessons)
      ..where((lesson) => lesson.start.isBetweenValues(startOfToday, endOfTheWeek)))
      .get();
  }
}
