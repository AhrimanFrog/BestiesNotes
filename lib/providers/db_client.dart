import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/db_group_ext.dart';
import 'package:besties_notes/extensions/db_lesson_details_ext.dart';
import 'package:besties_notes/extensions/db_student_ext.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db_client.g.dart';

@DriftDatabase(tables: [DbLessons, DbStudents, DbGroups, DbLessonParticipants])
class DbClient extends _$DbClient implements DataProvider, PaymentProvider {
  DbClient([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'besties_notes_db');
  }

  // ---------------------------------------------------------------------------
  // Lessons
  // ---------------------------------------------------------------------------

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
    return details.single;
  }

  @override
  Future<List<Lesson>> getLessonsForStudent(
    int studentId, {
    int offset = 0,
    int limit = 100,
  }) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.studentId.equals(studentId))
      ..limit(limit, offset: offset)
      ..orderBy([.desc(dbLessons.start)]);
    return await _gatherLessonDetailsIntoLesson(query);
  }

  @override
  Future<List<Lesson>> getLessonsForGroup(
    int groupId, {
    int offset = 0,
    int limit = 100,
  }) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.groupId.equals(groupId))
      ..limit(limit, offset: offset)
      ..orderBy([OrderingTerm.desc(dbLessons.start)]);
    return await _gatherLessonDetailsIntoLesson(query);
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
  Future<void> updateLessonStatus(int lessonId, LessonStatus status) async {
    await (update(dbLessons)..where((l) => l.id.equals(lessonId))).write(
      DbLessonsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> syncLessonMembership(int lessonId, List<Teachable> subjects) {
    return transaction(() async {
      final desired = await _resolveParticipants(subjects);

      if (desired.isEmpty) {
        await (delete(
          dbLessonParticipants,
        )..where((p) => p.lessonId.equals(lessonId))).go();
        return;
      }

      await batch((b) {
        b.insertAll(dbLessonParticipants, [
          for (final MapEntry(:key, :value) in desired.entries)
            DbLessonParticipantsCompanion.insert(
              lessonId: lessonId,
              studentId: key,
              isPaid: false,
              attended: false,
              groupId: Value(value),
            ),
        ], mode: InsertMode.insertOrIgnore);
      });

      await (delete(dbLessonParticipants)..where(
            (p) =>
                p.lessonId.equals(lessonId) & p.studentId.isNotIn(desired.keys),
          ))
          .go();
    });
  }

  @override
  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    await _updateStatuses(
      (p) => p.lessonId.equals(lessonId) & p.studentId.equals(studentId),
      attended: attended,
      isPaid: isPaid,
      homeworkDone: homeworkDone,
    );
  }

  @override
  Future<void> updateGroupStatuses(
    int lessonId,
    int groupId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    await _updateStatuses(
      (p) => p.lessonId.equals(lessonId) & p.groupId.equals(groupId),
      attended: attended,
      isPaid: isPaid,
      homeworkDone: homeworkDone,
    );
  }

  // ---------------------------------------------------------------------------
  // Students
  // ---------------------------------------------------------------------------

  @override
  Future<Student> getStudent(int studentId) async {
    final query = (select(dbStudents)..where((s) => s.id.equals(studentId)))
        .join([
          leftOuterJoin(dbGroups, dbGroups.id.equalsExp(dbStudents.groupId)),
        ]);
    final result = await query.getSingle();
    final group = result.readTableOrNull(dbGroups)?.toDomain();
    return result.readTable(dbStudents).toDomain(group: group);
  }

  @override
  Future<List<Student>> getStudents({int offset = 0, int limit = 100}) async {
    final query = (select(dbStudents)..limit(limit, offset: offset)).join([
      leftOuterJoin(dbGroups, dbGroups.id.equalsExp(dbStudents.groupId)),
    ]);

    return (await query.get())
        .map(
          (r) => r
              .readTable(dbStudents)
              .toDomain(group: r.readTableOrNull(dbGroups)?.toDomain()),
        )
        .toList();
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

  // ---------------------------------------------------------------------------
  // Groups
  // ---------------------------------------------------------------------------

  @override
  Future<Group> getGroup(int groupId) async {
    final query = select(dbGroups)..where((g) => g.id.equals(groupId));
    return (await query.getSingle()).toDomain();
  }

  @override
  Future<List<Group>> getGroups({int offset = 0, int limit = 100}) async {
    final query = select(dbGroups)..limit(limit, offset: offset);
    return (await query.get()).map((g) => g.toDomain()).toList();
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
    final query = select(dbStudents)..where((s) => s.groupId.equals(groupId));
    return (await query.get()).map((dbs) => dbs.toDomain()).toList();
  }

  @override
  Future<void> syncGroupMemberships(
    int groupId,
    Iterable<int> studentIds,
  ) async {
    await (update(dbStudents)
          ..where((s) => s.groupId.equals(groupId) & s.id.isNotIn(studentIds)))
        .write(DbStudentsCompanion(groupId: Value(null)));

    if (studentIds.isNotEmpty) {
      await (update(dbStudents)..where((s) => s.id.isIn(studentIds))).write(
        DbStudentsCompanion(groupId: Value(groupId)),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Payments
  // ---------------------------------------------------------------------------

  @override
  Future<({int paidLessons, int totalLessons})> getPaymentStatForPeriod({
    required DateTime from,
    required DateTime to,
    required int studentId,
  }) async {
    final total = countAll();
    final paid = dbLessonParticipants.isPaid.count(
      filter: dbLessonParticipants.isPaid.equals(true),
    );

    final query = selectOnly(dbLessons)
      ..addColumns([total, paid])
      ..join([
        innerJoin(
          dbLessonParticipants,
          dbLessonParticipants.lessonId.equalsExp(dbLessons.id),
        ),
      ])
      ..where(dbLessonParticipants.studentId.equals(studentId))
      ..where(dbLessons.start.isBetweenValues(from, to));

    final row = await query.getSingleOrNull();
    return (
      totalLessons: row?.read(total) ?? 0,
      paidLessons: row?.read(paid) ?? 0,
    );
  }

  @override
  Future<({int paidLessons, int totalLessons})> getPaymentStatForGroup({
    required int groupId,
    required DateTime from,
    required DateTime to,
  }) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.groupId.equals(groupId))
      ..where(dbLessons.start.isBetweenValues(from, to));
    final rows = await query.get();

    if (rows.isEmpty) return (paidLessons: 0, totalLessons: 0);

    // A lesson is "paid" when every group participant in it has paid.
    // Accumulate per-lesson: AND together each participant's isPaid flag.
    final Map<int, bool> allPaid = {};
    for (final row in rows) {
      final lessonId = row.readTable(dbLessons).id;
      final participant = row.readTableOrNull(dbLessonParticipants);
      if (participant != null) {
        allPaid.update(
          lessonId,
          (prev) => prev && participant.isPaid,
          ifAbsent: () => participant.isPaid,
        );
      }
    }

    return (
      paidLessons: allPaid.values.where((v) => v).length,
      totalLessons: allPaid.length,
    );
  }

  @override
  Future<List<Lesson>> getLessonsWithPaymentStatus(
    bool paymentStatus, {
    int limit = 100,
    int offset = 0,
  }) async {
    final query = _lessonsQuery()
      ..where(dbLessonParticipants.isPaid.equals(paymentStatus))
      ..orderBy([OrderingTerm.asc(dbLessons.start)])
      ..limit(limit, offset: offset);
    return await _gatherLessonDetailsIntoLesson(query);
  }

  @override
  Future<List<Lesson>> getUnpaidLessonsForStudent(int studentId) async {
    final query = _lessonsQuery()
      ..where(
        dbLessonParticipants.isPaid.equals(false) &
            dbLessonParticipants.studentId.equals(studentId),
      )
      ..orderBy([OrderingTerm.asc(dbLessons.start)]);
    return await _gatherLessonDetailsIntoLesson(query);
  }

  @override
  Future<List<Lesson>> getUnpaidLessonsForGroup(int groupId) async {
    final query = _lessonsQuery()
      ..where(
        dbLessonParticipants.groupId.equals(groupId) &
            dbLessonParticipants.isPaid.equals(false),
      )
      ..orderBy([OrderingTerm.asc(dbLessons.start)]);
    return await _gatherLessonDetailsIntoLesson(query);
  }

  @override
  Future<List<Debtor>> getDebtors() async {
    final query = select(dbLessonParticipants).join([
      innerJoin(
        dbStudents,
        dbStudents.id.equalsExp(dbLessonParticipants.studentId),
      ),
    ])..where(dbLessonParticipants.isPaid.equals(false));

    Map<int, Student> studs = {};
    Map<int, int> unpaidCount = {};

    for (final row in await query.get()) {
      final stud = row.readTable(dbStudents);
      studs.putIfAbsent(stud.id, () => stud.toDomain());
      unpaidCount[stud.id] = (unpaidCount[stud.id] ?? 0) + 1;
    }

    return unpaidCount.entries
        .map((e) => Debtor(debtor: studs[e.key]!, unpaidLessons: e.value))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

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

  Future<Map<int, int?>> _resolveParticipants(List<Teachable> subjects) async {
    final Map<int, int?> desiredStudents = {};
    for (final s in subjects.whereType<Student>()) {
      if (s.id != null) desiredStudents[s.id!] = null;
    }

    final groupIds = subjects
        .whereType<Group>()
        .where((g) => g.id != null)
        .map((g) => g.id!)
        .toSet();

    if (groupIds.isEmpty) return desiredStudents;

    final members = await (select(
      dbStudents,
    )..where((s) => s.groupId.isIn(groupIds))).get();
    for (final member in members) {
      desiredStudents[member.id] = member.groupId;
    }

    return desiredStudents;
  }

  Future<void> _updateStatuses(
    Expression<bool> Function($DbLessonParticipantsTable tbl) whereClause, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    await (update(dbLessonParticipants)..where(whereClause)).write(
      DbLessonParticipantsCompanion(
        attended: attended != null ? Value(attended) : const Value.absent(),
        isPaid: isPaid != null ? Value(isPaid) : const Value.absent(),
        homeworkDone: homeworkDone != null
            ? Value(homeworkDone)
            : const Value.absent(),
      ),
    );
  }
}
