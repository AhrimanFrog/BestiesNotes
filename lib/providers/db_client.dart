import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
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
  Future<int> createOrUpdateLesson(DbLessonsCompanion lesson) {
    return into(dbLessons).insertOnConflictUpdate(lesson);
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

  @override
  Future<int> createOrUpdateGroup(DbGroupsCompanion group) {
    return into(dbGroups).insertOnConflictUpdate(group);
  }

  @override
  Future<void> deleteGroup(int groupId) {
    return (delete(dbGroups)..where((g) => g.id.equals(groupId))).go();
  }

  @override
  Future<List<DbStudent>> getGroupMembers(int groupId) async {
    final query = select(groupMemberships).join([
      innerJoin(
        dbStudents,
        dbStudents.id.equalsExp(groupMemberships.studentId),
      ),
    ])..where(groupMemberships.groupId.equals(groupId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(dbStudents)).toList();
  }

  @override
  Future<void> syncGroupMemberships(int groupId, List<int> studentIds) {
    return transaction(() async {
      await (delete(
        groupMemberships,
      )..where((m) => m.groupId.equals(groupId))).go();

      for (final studentId in studentIds) {
        await into(groupMemberships).insert(
          GroupMembershipsCompanion.insert(
            groupId: groupId,
            studentId: studentId,
          ),
        );
      }
    });
  }

  Future<void> _removeLessonParticipants(
    int lessonId,
    Set<int> toRemove,
  ) async {
    await (delete(dbLessonParticipants)..where(
          (p) => p.lessonId.equals(lessonId) & p.studentId.isIn(toRemove),
        ))
        .go();
  }

  @override
  Future<void> syncLessonMembership(int lessonId, List<Teachable> subjects) {
    return transaction(() async {
      // Expand groups into individual students, tracking group origin
      final Map<int, int?> desiredStudents = {}; // studentId -> groupId?
      for (final subject in subjects) {
        if (subject is Student && subject.id != null) {
          desiredStudents[subject.id!] = null;
        } else if (subject is Group && subject.id != null) {
          final members = await getGroupMembers(subject.id!);
          for (final member in members) {
            desiredStudents[member.id] = subject.id;
          }
        }
      }

      final existing =
          await (select(dbLessonParticipants)
                ..where((p) => p.lessonId.equals(lessonId)))
              .map((p) => p.studentId)
              .get();
      final existingIds = existing.toSet();
      final desiredIds = desiredStudents.keys.toSet();

      final toRemove = existingIds.difference(desiredIds);
      if (toRemove.isNotEmpty) {
        await _removeLessonParticipants(lessonId, toRemove);
      }

      final toAdd = desiredIds.difference(existingIds);
      if (toAdd.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(dbLessonParticipants, [
            for (final studentId in toAdd)
              DbLessonParticipantsCompanion.insert(
                lessonId: lessonId,
                studentId: studentId,
                isPaid: false,
                attended: false,
                groupId: Value(desiredStudents[studentId]),
              ),
          ]);
        });
      }
    });
  }

  @override
  Future<void> updateLessonStatus(int lessonId, LessonStatus status) async {
    (update(dbLessons)..where((l) => l.id.equals(lessonId))).write(
      DbLessonsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
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
