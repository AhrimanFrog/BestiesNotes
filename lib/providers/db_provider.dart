import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'db_provider.g.dart';

@DriftDatabase(
  tables: [
    DbLessons, DbStudents, DbGroups, GroupMemberships, DbLessonParticipants
  ],
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
      final student = row.readTableOrNull(_db.dbStudents);

      final details = lessonDetails.putIfAbsent(
        lesson.id,
        () => DbLessonDetails(lesson: lesson),
      );

      if (student != null) details.students[student.id] = student;
    }
    return lessonDetails.values.toList();
  }

  Future<List<TypedResult>> _getLessonsWithNotesForWeek() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfTheWeek = startOfToday.add(Duration(days: 7));

    final query = (_db.select(_db.dbLessons)).join([
      
    ])..where(_db.dbLessons.start.isBetweenValues(startOfToday, endOfTheWeek));

    return query.get();
  }

  void addLesson(DbLesson lesson) {
    _db.dbLessons.insert();
  }
}

final dbProviderRiverpod = Provider((ref) => DbProvider(db: AppDatabase()));
