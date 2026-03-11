import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/db_group_ext.dart';
import 'package:besties_notes/extensions/db_lesson_details_ext.dart';
import 'package:besties_notes/extensions/db_student_ext.dart';
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
  int get schemaVersion => 3;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'besties_notes_db');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.addColumn(
          dbLessonParticipants,
          dbLessonParticipants.homeworkDone,
        );

        await customStatement(
          'UPDATE db_lesson_participants SET homework_done = 0',
        );
      }
    },
  );

  @override
  Future<List<Lesson>> getLessonsForRange(DateTime from, DateTime to) async {
    final queryRes = _lessonsQuery()
      ..where(dbLessons.start.isBetweenValues(from, to))
      ..orderBy([OrderingTerm.asc(dbLessons.start)]);

    return await _gatherLessonDetailsIntoLesson(queryRes);
  }

  @override
  Future<Lesson> getLesson(int lessonId) async {
    final query = _lessonsQuery()..where(dbLessons.id.equals(lessonId));
    final details = await _gatherLessonDetailsIntoLesson(query);
    if (details.isEmpty) throw Exception("Lesson not Found!");
    return details.first;
  }

  @override
  Future<List<Lesson>> getLessonsForStudent(int studentID) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.studentId.equals(studentID))
      ..orderBy([.desc(dbLessons.start)]);
    return await _gatherLessonDetailsIntoLesson(query);
  }

  Future<List<Lesson>> _gatherLessonDetailsIntoLesson(
    JoinedSelectStatement query,
  ) async {
    final Map<int, DbLessonDetails> lessonDetails = {};

    for (final row in await query.get()) {
      final lesson = row.readTable(dbLessons);
      final student = row.readTableOrNull(dbStudents);
      final group = row.readTableOrNull(dbGroups);
      final participant = row.readTableOrNull(dbLessonParticipants);

      final details = lessonDetails.putIfAbsent(
        lesson.id,
        () => DbLessonDetails(lesson: lesson),
      );

      if (student != null) details.students[student.id] = student;
      if (group != null) details.groups[group.id] = group;
      if (participant != null) {
        details.participantStatus[participant.studentId] = participant;
      }
    }
    return lessonDetails.values.map((d) => d.toDomain()).toList();
  }

  @override
  Future<int> createOrUpdateLesson(Lesson lesson) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = DbLessonsCompanion.insert(
      id: lesson.id != null ? Value(lesson.id!) : .absent(),
      topic: lesson.name,
      start: lesson.start,
      durationInMinutes: lesson.duration.inMinutes,
      status: lesson.status,
      createdAt: now,
      updatedAt: now,
    );
    return into(dbLessons).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion.copyWith(
          createdAt: const Value.absent(),
          updatedAt: Value(now),
        ),
      ),
    );
  }

  @override
  Future<int> createOrUpdateStudent(Student student) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = DbStudentsCompanion.insert(
      id: student.id != null ? Value(student.id!) : .absent(),
      name: student.name,
      contact: student.contact,
      payRate: student.pricing.rate,
      period: student.pricing.period,
      notes: student.note,
      createdAt: now,
      updatedAt: now,
    );
    return into(dbStudents).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion.copyWith(
          createdAt: const Value.absent(),
          updatedAt: Value(now),
        ),
      ),
    );
  }

  @override
  Future<void> deleteStudent(int studentId) {
    return (delete(dbStudents)..where((s) => s.id.equals(studentId))).go();
  }

  @override
  Future<Student> getStudent(int studentId) async {
    final query = (select(dbStudents)..where((s) => s.id.equals(studentId)))
        .join([
          leftOuterJoin(
            groupMemberships,
            groupMemberships.studentId.equalsExp(dbStudents.id),
          ),
          leftOuterJoin(
            dbGroups,
            dbGroups.id.equalsExp(groupMemberships.groupId),
          ),
        ]);
    final result = await query.getSingle();
    return result
        .readTable(dbStudents)
        .toDomain()
        .copyWith(group: result.readTableOrNull(dbGroups)?.toDomain());
  }

  @override
  Future<List<Student>> getStudents({int offset = 0, int limit = 100}) async {
    final query = (select(dbStudents)..limit(limit, offset: offset)).join([
      leftOuterJoin(
        groupMemberships,
        groupMemberships.studentId.equalsExp(dbStudents.id),
      ),
      leftOuterJoin(dbGroups, dbGroups.id.equalsExp(groupMemberships.groupId)),
    ]);

    final Map<int, Student> seen = {};
    for (final row in await query.get()) {
      final dbStudent = row.readTable(dbStudents);
      if (!seen.containsKey(dbStudent.id)) {
        final dbGroup = row.readTableOrNull(dbGroups);
        seen[dbStudent.id] = dbStudent.toDomain(group: dbGroup?.toDomain());
      }
    }
    return seen.values.toList();
  }

  @override
  Future<List<Group>> getGroups({int offset = 0, int limit = 100}) async {
    return (await (select(
      dbGroups,
    )..limit(limit, offset: offset)).get()).map((g) => g.toDomain()).toList();
  }

  @override
  Future<int> createOrUpdateGroup(Group group) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return into(dbGroups).insertOnConflictUpdate(
      DbGroupsCompanion.insert(
        id: group.id != null ? Value(group.id!) : .absent(),
        name: group.name,
        payRate: group.pricing.rate,
        period: group.pricing.period,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> deleteGroup(int groupId) {
    return (delete(dbGroups)..where((g) => g.id.equals(groupId))).go();
  }

  @override
  Future<List<Student>> getGroupMembers(int groupId) async {
    final query = select(groupMemberships).join([
      innerJoin(
        dbStudents,
        dbStudents.id.equalsExp(groupMemberships.studentId),
      ),
    ])..where(groupMemberships.groupId.equals(groupId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(dbStudents).toDomain()).toList();
  }

  @override
  Future<void> syncGroupMemberships(int groupId, Iterable<int> studentIds) {
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
            desiredStudents[member.id!] = subject.id;
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
                homeworkDone: Value(false),
                groupId: Value(desiredStudents[studentId]),
              ),
          ]);
        });
      }
    });
  }

  @override
  Future<void> updateLessonStatus(int lessonId, LessonStatus status) async {
    await (update(dbLessons)..where((l) => l.id.equals(lessonId))).write(
      DbLessonsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    await (update(dbLessonParticipants)..where(
          (p) => p.lessonId.equals(lessonId) & p.studentId.equals(studentId),
        ))
        .write(
          DbLessonParticipantsCompanion(
            attended: attended != null ? Value(attended) : const Value.absent(),
            isPaid: isPaid != null ? Value(isPaid) : const Value.absent(),
            homeworkDone: homeworkDone != null
                ? Value(homeworkDone)
                : const Value.absent(),
          ),
        );
  }

  @override
  Future<({int paidLessons, int totalLessons})> getPaymentStatForPeriod({
    required DateTime from,
    required DateTime to,
    required int studentID,
  }) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.studentId.equals(studentID))
      ..where(dbLessons.start.isBetweenValues(from, to));
    final result = await query.get();

    if (result.isEmpty) throw Exception('No such student!');

    final int paid = result.fold(
      0,
      (count, row) => row.readTableOrNull(dbLessonParticipants)?.isPaid == true
          ? count + 1
          : count,
    );

    return (paidLessons: paid, totalLessons: result.length);
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
