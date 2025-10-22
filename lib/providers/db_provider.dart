import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'db_provider.g.dart';

@DriftDatabase(
  tables: [DbLessons, DbStudents, DbStudentsLessons, DbLessonNotes],
)
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

  @override
  Future<Map<DbLesson, List<DbLessonNote>>> getLessonsForWeek() async {
    final queryRes = await _getLessonsWithNotesForWeek();

    final Map<DbLesson, List<DbLessonNote>> lessonsForWeek = {};

    for (final row in queryRes) {
      final lesson = row.readTable(_db.dbLessons);
      final note = row.readTableOrNull(_db.dbLessonNotes);

      final notes = lessonsForWeek.putIfAbsent(lesson, () => <DbLessonNote>[]);
      if (note != null) {
        notes.add(note);
      }
    }

    return lessonsForWeek;
  }

  Future<List<TypedResult>> _getLessonsWithNotesForWeek() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfTheWeek = startOfToday.add(Duration(days: 7));

    final query = (_db.select(_db.dbLessons)).join([
      leftOuterJoin(
        _db.dbLessonNotes,
        _db.dbLessonNotes.lessonId.equalsExp(_db.dbLessons.id),
      ),
    ])..where(_db.dbLessons.start.isBetweenValues(startOfToday, endOfTheWeek));

    return query.get();
  }

  void addLesson(DbLesson lesson) {
    _db.dbLessons.insert();
  }
}

final dbProviderRiverpod = Provider((ref) => DbProvider(db: AppDatabase()));
