import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:besties_notes/data/db_models/db_lesson_details.dart';
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
  Future<List<DbLessonDetails>> getLessonsForWeek() async {
    final queryRes = await _getLessonsWithNotesForWeek();

    final Map<int, DbLessonDetails> lessonDetails = {};

    for (final row in queryRes) {
      final lesson = row.readTable(_db.dbLessons);
      final note = row.readTableOrNull(_db.dbLessonNotes);
      final student = row.readTableOrNull(_db.dbStudents);

      final details = lessonDetails.putIfAbsent(
        lesson.id,
        () => DbLessonDetails(lesson: lesson),
      );

      if (note != null) details.notes[note.id] = note;
      if (student != null) details.students[student.id] = student;
    }
    return lessonDetails.values.toList();
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
      leftOuterJoin(
        _db.dbStudentsLessons,
        _db.dbStudentsLessons.lessonId.equalsExp(_db.dbLessons.id),
      ),
      leftOuterJoin(
        _db.dbStudents,
        _db.dbStudents.id.equalsExp(_db.dbStudentsLessons.studentId),
      ),
    ])..where(_db.dbLessons.start.isBetweenValues(startOfToday, endOfTheWeek));

    return query.get();
  }

  void addLesson(DbLesson lesson) {
    _db.dbLessons.insert();
  }
}

final dbProviderRiverpod = Provider((ref) => DbProvider(db: AppDatabase()));
