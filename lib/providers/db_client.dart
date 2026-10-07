import 'dart:io';

import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/db_group_ext.dart';
import 'package:besties_notes/extensions/db_lesson_details_ext.dart';
import 'package:besties_notes/extensions/db_student_ext.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/providers/settings_provider.dart';
import 'package:drift/drift.dart';
import 'package:besties_notes/data/db_models/db_models.dart';
import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db_client.g.dart';

@DriftDatabase(
  tables: [DbLessons, DbStudents, DbGroups, DbLessonParticipants, DbSettings],
)
class DbClient extends _$DbClient
    implements DataProvider, PaymentProvider, SettingsProvider {
  DbClient([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Where the app's database lives on the device.
  static Future<File> databaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'besties_notes_db.sqlite'));
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'besties_notes_db',
      native: DriftNativeOptions(
        databasePath: () async => (await databaseFile()).path,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------

  @override
  Future<Map<String, String>> loadSettings() async {
    final rows = await select(dbSettings).get();
    return {for (final row in rows) row.key: row.value};
  }

  @override
  Future<void> saveSettings(Map<String, String> values) {
    return batch((b) {
      b.insertAllOnConflictUpdate(dbSettings, [
        for (final MapEntry(:key, :value) in values.entries)
          DbSettingsCompanion.insert(key: key, value: value),
      ]);
    });
  }

  // ---------------------------------------------------------------------------
  // Maintenance
  // ---------------------------------------------------------------------------

  /// Writes a compact, consistent copy of the whole database to [target].
  Future<void> exportTo(File target) async {
    if (target.existsSync()) target.deleteSync();
    await customStatement('VACUUM INTO ?', [target.path]);
  }

  /// Deletes all students, groups and lessons. Settings are kept.
  Future<void> clearAllRecords() {
    return transaction(() async {
      await delete(dbLessonParticipants).go();
      await delete(dbLessons).go();
      await delete(dbStudents).go();
      await delete(dbGroups).go();
    });
  }

  // ---------------------------------------------------------------------------
  // Lessons
  // ---------------------------------------------------------------------------

  /// Lessons starting in the half-open range `[from, to)`.
  @override
  Future<List<Lesson>> getLessonsForRange(DateTime from, DateTime to) async {
    final queryRes = _lessonsQuery()
      ..where(_startsWithin(from, to))
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
  }) {
    return _lessonsWhereParticipant(
      dbLessonParticipants.studentId.equals(studentId),
      descending: true,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Lesson>> getLessonsForGroup(
    int groupId, {
    int offset = 0,
    int limit = 100,
  }) {
    return _lessonsWhereParticipant(
      dbLessonParticipants.groupId.equals(groupId),
      descending: true,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> createOrUpdateLesson(Lesson lesson) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = DbLessonsCompanion.insert(
      id: lesson.id != null ? Value(lesson.id!) : .absent(),
      topic: lesson.name,
      start: lesson.start,
      durationInMinutes: lesson.duration.inMinutes,
      note: Value(lesson.note),
      isCancelled: lesson.isCancelled,
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
  Future<void> updateCancellation(int lessonId, bool isCancelled) async {
    await (update(dbLessons)..where((l) => l.id.equals(lessonId))).write(
      DbLessonsCompanion(
        isCancelled: Value(isCancelled),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Participants go with it (cascade).
  @override
  Future<void> deleteLesson(int lessonId) {
    return (delete(dbLessons)..where((l) => l.id.equals(lessonId))).go();
  }

  @override
  Future<void> updateAllParticipantStatuses(
    int lessonId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) {
    return _updateStatuses(
      (p) => p.lessonId.equals(lessonId),
      attended: attended,
      isPaid: isPaid,
      homeworkDone: homeworkDone,
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
        b.insertAll(
          dbLessonParticipants,
          [
            for (final MapEntry(:key, :value) in desired.entries)
              DbLessonParticipantsCompanion.insert(
                lessonId: lessonId,
                studentId: key,
                isPaid: false,
                attended: false,
                groupId: Value(value.groupId),
                payRate: Value(value.payRate),
                period: Value(value.period),
              ),
          ],
          // Keep existing statuses and price, but refresh how the student was
          // assigned (individually vs. through a group). An upcoming lesson
          // is re-priced below.
          onConflict:
              DoUpdate<
                $DbLessonParticipantsTable,
                DbLessonParticipant
              >.withExcluded(
                (_, excluded) => DbLessonParticipantsCompanion.custom(
                  groupId: excluded.groupId,
                ),
                target: [
                  dbLessonParticipants.lessonId,
                  dbLessonParticipants.studentId,
                ],
              ),
        );
      });

      await (delete(dbLessonParticipants)..where(
            (p) =>
                p.lessonId.equals(lessonId) & p.studentId.isNotIn(desired.keys),
          ))
          .go();

      await _repriceUpcoming((p) => p.lessonId.equals(lessonId));
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
  Future<List<Student>> getStudents({int offset = 0, int? limit}) async {
    final students = select(dbStudents)
      ..orderBy([(s) => OrderingTerm.asc(s.name)]);
    if (limit != null) students.limit(limit, offset: offset);
    final query = students.join([
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
      avatarPath: Value(student.iconPath),
      payRate: student.pricing.rate,
      period: student.pricing.period,
      notes: student.note,
      groupId: Value(student.group?.id),
      createdAt: now,
      updatedAt: now,
    );
    return transaction(() async {
      // An upsert that updates doesn't set the last insert rowid reliably.
      final insertedId = await into(dbStudents).insert(
        companion,
        onConflict: DoUpdate(
          (_) => companion.copyWith(
            createdAt: const Value.absent(),
            updatedAt: Value(now),
          ),
        ),
      );
      final id = student.id ?? insertedId;
      // A new rate applies to individual lessons still to come.
      await _repriceUpcoming(
        (p) => p.studentId.equals(id) & p.groupId.isNull(),
      );
      return id;
    });
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
  Future<List<Group>> getGroups({int offset = 0, int? limit}) async {
    final query = select(dbGroups)..orderBy([(g) => OrderingTerm.asc(g.name)]);
    if (limit != null) query.limit(limit, offset: offset);
    return (await query.get()).map((g) => g.toDomain()).toList();
  }

  @override
  Future<int> createOrUpdateGroup(Group group) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = DbGroupsCompanion.insert(
      id: group.id != null ? Value(group.id!) : .absent(),
      name: group.name,
      avatarPath: Value(group.iconPath),
      payRate: group.pricing.rate,
      period: group.pricing.period,
      createdAt: now,
      updatedAt: now,
    );
    return transaction(() async {
      final insertedId = await into(dbGroups).insert(
        companion,
        onConflict: DoUpdate(
          (_) => companion.copyWith(
            createdAt: const Value.absent(),
            updatedAt: Value(now),
          ),
        ),
      );
      final id = group.id ?? insertedId;
      // A new rate applies to the group's lessons still to come.
      await _repriceUpcoming((p) => p.groupId.equals(id));
      return id;
    });
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
    return transaction(() async {
      await (update(
            dbStudents,
          )..where((s) => s.groupId.equals(groupId) & s.id.isNotIn(studentIds)))
          .write(DbStudentsCompanion(groupId: Value(null)));

      if (studentIds.isNotEmpty) {
        await (update(dbStudents)..where((s) => s.id.isIn(studentIds))).write(
          DbStudentsCompanion(groupId: Value(groupId)),
        );
      }
    });
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
      ..where(_startsWithin(from, to) & dbLessons.isCancelled.equals(false));

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
      ..where(_startsWithin(from, to) & dbLessons.isCancelled.equals(false));
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
  }) {
    return _lessonsWhereParticipant(
      dbLessonParticipants.isPaid.equals(paymentStatus),
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Lesson>> getUnpaidLessonsForStudent(int studentId) {
    return _lessonsWhereParticipant(
      dbLessonParticipants.isPaid.equals(false) &
          dbLessonParticipants.studentId.equals(studentId) &
          _isBillable(),
    );
  }

  @override
  Future<List<Lesson>> getUnpaidLessonsForGroup(int groupId) {
    return _lessonsWhereParticipant(
      dbLessonParticipants.groupId.equals(groupId) &
          dbLessonParticipants.isPaid.equals(false) &
          _isBillable(),
    );
  }

  @override
  Future<List<Participation>> getParticipations({
    DateTime? from,
    DateTime? to,
    int? studentId,
    int? groupId,
    bool unpaidOnly = false,
  }) async {
    final p = dbLessonParticipants;
    final query =
        select(p).join([
            innerJoin(dbLessons, dbLessons.id.equalsExp(p.lessonId)),
            innerJoin(dbStudents, dbStudents.id.equalsExp(p.studentId)),
          ])
          ..where(_isBillable())
          ..orderBy([OrderingTerm.asc(dbLessons.start)]);
    if (from != null) query.where(dbLessons.start.isBiggerOrEqualValue(from));
    if (to != null) query.where(dbLessons.start.isSmallerThanValue(to));
    if (studentId != null) query.where(p.studentId.equals(studentId));
    if (groupId != null) query.where(p.groupId.equals(groupId));
    if (unpaidOnly) query.where(p.isPaid.equals(false));

    final students = <int, Student>{};
    final result = <Participation>[];
    for (final row in await query.get()) {
      final participant = row.readTable(p);
      final lesson = row.readTable(dbLessons);
      result.add(
        Participation(
          lessonId: participant.lessonId,
          lessonName: lesson.topic,
          start: lesson.start,
          student: students.putIfAbsent(
            participant.studentId,
            () => row.readTable(dbStudents).toDomain(),
          ),
          groupId: participant.groupId,
          rate: Rate(rate: participant.payRate, period: participant.period),
          isPaid: participant.isPaid,
        ),
      );
    }
    return result;
  }

  @override
  Future<List<Debtor>> getDebtors() async {
    // Unpaid participations are enough: a monthly charge is owed as soon as
    // one of its lessons is unpaid.
    final unpaid = await getParticipations(unpaidOnly: true);
    final byStudent = <int, List<Participation>>{};
    for (final p in unpaid) {
      byStudent.putIfAbsent(p.student.id!, () => []).add(p);
    }
    final debtors = [
      for (final ps in byStudent.values)
        Debtor(
          debtor: ps.first.student,
          unpaidLessons: ps.length,
          amountOwed: Earnings.summarize(ps).unpaid,
        ),
    ]..sort((a, b) => b.amountOwed.compareTo(a.amountOwed));
    return debtors;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Expression<bool> _startsWithin(DateTime from, DateTime to) =>
      dbLessons.start.isBiggerOrEqualValue(from) &
      dbLessons.start.isSmallerThanValue(to);

  /// A lesson can be owed for once it has started and wasn't cancelled.
  Expression<bool> _isBillable() =>
      dbLessons.isCancelled.equals(false) &
      dbLessons.start.isSmallerThanValue(DateTime.now());

  /// Loads full lessons (with *all* their participants) for which at least one
  /// participant row matches [participantFilter]. Filtering ids first keeps
  /// other participants in the result and makes [limit] count lessons rather
  /// than joined rows.
  Future<List<Lesson>> _lessonsWhereParticipant(
    Expression<bool> participantFilter, {
    bool descending = false,
    int? limit,
    int offset = 0,
  }) async {
    final ordering = OrderingTerm(
      expression: dbLessons.start,
      mode: descending ? OrderingMode.desc : OrderingMode.asc,
    );
    final idsQuery = selectOnly(dbLessons, distinct: true)
      ..addColumns([dbLessons.id, dbLessons.start])
      ..join([
        innerJoin(
          dbLessonParticipants,
          dbLessonParticipants.lessonId.equalsExp(dbLessons.id),
          useColumns: false,
        ),
      ])
      ..where(participantFilter)
      ..orderBy([ordering]);
    if (limit != null) idsQuery.limit(limit, offset: offset);

    final ids = [
      for (final row in await idsQuery.get()) row.read(dbLessons.id)!,
    ];
    if (ids.isEmpty) return [];

    final query = _lessonsQuery()
      ..where(dbLessons.id.isIn(ids))
      ..orderBy([ordering]);
    return _gatherLessonDetailsIntoLesson(query);
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

  /// Who takes part when [subjects] are booked, by student id: the group
  /// they come through (if any) and the rate they're billed — the group's
  /// rate for group members, their own otherwise. Rates are read from the
  /// database, not from the passed-in objects, which may be stale.
  Future<Map<int, ({int? groupId, double payRate, RatePeriod period})>>
  _resolveParticipants(List<Teachable> subjects) async {
    final studentIds = {
      for (final s in subjects.whereType<Student>())
        if (s.id != null) s.id!,
    };
    final groupIds = {
      for (final g in subjects.whereType<Group>())
        if (g.id != null) g.id!,
    };

    final result = <int, ({int? groupId, double payRate, RatePeriod period})>{};
    if (studentIds.isNotEmpty) {
      final students = await (select(
        dbStudents,
      )..where((s) => s.id.isIn(studentIds))).get();
      for (final s in students) {
        result[s.id] = (groupId: null, payRate: s.payRate, period: s.period);
      }
    }
    if (groupIds.isNotEmpty) {
      final members =
          await (select(
            dbStudents,
          )..where((s) => s.groupId.isIn(groupIds))).join([
            innerJoin(dbGroups, dbGroups.id.equalsExp(dbStudents.groupId)),
          ]).get();
      for (final row in members) {
        final group = row.readTable(dbGroups);
        result[row.readTable(dbStudents).id] = (
          groupId: group.id,
          payRate: group.payRate,
          period: group.period,
        );
      }
    }
    return result;
  }

  /// Re-prices participations in lessons that haven't started yet from the
  /// current student and group rates. Started lessons keep their price.
  Future<void> _repriceUpcoming(
    Expression<bool> Function($DbLessonParticipantsTable p) filter,
  ) async {
    final upcoming = selectOnly(dbLessons)
      ..addColumns([dbLessons.id])
      ..where(dbLessons.start.isBiggerThanValue(DateTime.now()));
    final rows =
        await (select(
          dbLessonParticipants,
        )..where((p) => filter(p) & p.lessonId.isInQuery(upcoming))).join([
          innerJoin(
            dbStudents,
            dbStudents.id.equalsExp(dbLessonParticipants.studentId),
          ),
          leftOuterJoin(
            dbGroups,
            dbGroups.id.equalsExp(dbLessonParticipants.groupId),
          ),
        ]).get();
    if (rows.isEmpty) return;

    await batch((b) {
      for (final row in rows) {
        final participant = row.readTable(dbLessonParticipants);
        final student = row.readTable(dbStudents);
        final group = row.readTableOrNull(dbGroups);
        b.update(
          dbLessonParticipants,
          DbLessonParticipantsCompanion(
            payRate: Value(group?.payRate ?? student.payRate),
            period: Value(group?.period ?? student.period),
          ),
          where: (p) => p.id.equals(participant.id),
        );
      }
    });
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
