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

    final queryRes = await _getLessonsForPeriod(
      start: startOfToday,
      end: startOfToday.add(Duration(days: 7)),
    );

    final Map<int, DbLessonDetails> lessonDetails = {};

    for (final row in queryRes) {
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

  Future<List> _getLessonsForPeriod({
    required DateTime start,
    required DateTime end,
  }) {
    final query =
        (select(dbLessons)).join([
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
          ])
          ..where(dbLessons.start.isBetweenValues(start, end))
          ..orderBy([OrderingTerm.asc(dbLessons.start)]);

    return query.get();
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
}
