import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [
    DbLessons,
    DbStudents,
    DbGroups,
    GroupMemberships,
    DbLessonParticipants,
  ],
)
class DbClient extends _$DbClient implements DataProvider {
  DbClient([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'besties_notes_db');
  }

  @override
  Future<List<DbLessonDetails>> getLessonsForWeek() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    final queryRes = _lessonsQuery()
      ..where(
        dbLessons.start.isBetweenValues(
          startOfToday,
          startOfToday.add(Duration(days: 7)),
        ),
      )
      ..orderBy([OrderingTerm.asc(dbLessons.start)]);

    final Map<int, DbLessonDetails> lessonDetails = {};

    for (final row in await queryRes.get()) {
      final lesson = row.readTable(dbLessons);
      final student = row.readTableOrNull(dbStudents);
      final group = row.readTableOrNull(dbGroups);

      final details = lessonDetails.putIfAbsent(
        lesson.id,
        () => DbLessonDetails(lesson: lesson),
      );

      if (student != null) details.students[student.id] = student;
      if (group != null) details.groups[group.id] = group;
    }
    return lessonDetails.values.toList();
  }

  @override
  Future<DbLessonDetails> getLesson(int lessonId) async {
    final query = _lessonsQuery()..where(dbLessons.id.equals(lessonId));
    final rows = await query.get();
    if (rows.isEmpty) throw Exception("Lesson not Found!");
    final details = DbLessonDetails(lesson: rows.first.readTable(dbLessons));

    for (final row in rows) {
      final student = row.readTableOrNull(dbStudents);
      final group = row.readTableOrNull(dbGroups);
      if (student != null) details.students[student.id] = student;
      if (group != null) details.groups[group.id] = group;
    }

    return details;
  }

  @override
  Future<void> createOrUpdateLesson(DbLessonsCompanion lesson) {
    return into(dbLessons).insertOnConflictUpdate(lesson);
  }

  @override
  Future<void> deleteLesson(int lessonId) {
    return (delete(dbLessons)..where((s) => s.id.equals(lessonId))).go();
  }

  @override
  Future<int> createOrUpdateStudent(DbStudentsCompanion student) {
    return into(dbStudents).insertOnConflictUpdate(student);
  }

  @override
  Future<void> deleteStudent(int studentId) {
    return (delete(dbStudents)..where((s) => s.id.equals(studentId))).go();
  }

  @override
  Future<List<DbStudent>> getStudents({int offset = 0, int limit = 100}) {
    return (select(dbStudents)..limit(limit, offset: offset)).get();
  }

  @override
  Future<List<DbGroup>> getGroups({int offset = 0, int limit = 100}) {
    return (select(dbGroups)..limit(limit, offset: offset)).get();
  }

  JoinedSelectStatement _lessonsQuery() {
    return (select(dbLessons)).join([
      leftOuterJoin(
        dbLessonParticipants,
        dbLessonParticipants.lessonId.equalsExp(dbLessons.id),
      ),
      leftOuterJoin(
        dbStudents,
        dbStudents.id.equalsExp(dbLessonParticipants.studentId),
      ),
      leftOuterJoin(
        dbGroups,
        dbGroups.id.equalsExp(dbLessonParticipants.groupId),
      ),
    ]);
  }
}
