import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DbClient db;

  setUp(() {
    db = DbClient(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Student makeStudent({int? id, String name = 'Alice'}) => Student(
    id: id,
    name: name,
    contact: '123-456',
    pricing: const Rate(rate: 10.0, period: RatePeriod.monthly),
  );

  Group makeGroup({int? id, String name = 'Group A'}) => Group(
    id: id,
    name: name,
    pricing: const Rate(rate: 50.0, period: RatePeriod.monthly),
  );

  Lesson makeLesson({
    int? id,
    String name = 'Math',
    DateTime? start,
    bool isCancelled = false,
  }) => Lesson(
    id: id,
    name: name,
    participants: const [],
    start: start ?? DateTime(2025, 1, 15, 10, 0),
    duration: const Duration(hours: 1),
    isCancelled: isCancelled,
  );

  // ---------------------------------------------------------------------------
  // Student CRUD
  // ---------------------------------------------------------------------------

  group('createOrUpdateStudent', () {
    test('creates a new student and returns a positive id', () async {
      final id = await db.createOrUpdateStudent(makeStudent());
      expect(id, greaterThan(0));
    });

    test('update preserves id and changes name', () async {
      final id = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      await db.createOrUpdateStudent(
        makeStudent(id: id, name: 'Alice Updated'),
      );
      final student = await db.getStudent(id);
      expect(student.name, 'Alice Updated');
      expect(student.id, id);
    });

    test('two distinct students get different ids', () async {
      final id1 = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      final id2 = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      expect(id1, isNot(equals(id2)));
    });
  });

  group('getStudent', () {
    test('returns the correct student', () async {
      final id = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      final student = await db.getStudent(id);
      expect(student.id, id);
      expect(student.name, 'Bob');
    });
  });

  group('getStudents', () {
    test('returns all created students', () async {
      await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      final students = await db.getStudents();
      expect(students.length, 2);
    });

    test('respects limit', () async {
      for (int i = 0; i < 5; i++) {
        await db.createOrUpdateStudent(makeStudent(name: 'Student $i'));
      }
      final page = await db.getStudents(limit: 3);
      expect(page.length, 3);
    });

    test('respects offset', () async {
      for (int i = 0; i < 5; i++) {
        await db.createOrUpdateStudent(makeStudent(name: 'Student $i'));
      }
      final page = await db.getStudents(offset: 4, limit: 100);
      expect(page.length, 1);
    });

    test('returns empty list when no students', () async {
      final students = await db.getStudents();
      expect(students, isEmpty);
    });
  });

  group('deleteStudent', () {
    test('removes the student', () async {
      final id = await db.createOrUpdateStudent(makeStudent());
      await db.deleteStudent(id);
      final students = await db.getStudents();
      expect(students.where((s) => s.id == id), isEmpty);
    });

    test('does not affect other students', () async {
      final id1 = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      final id2 = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      await db.deleteStudent(id1);
      final students = await db.getStudents();
      expect(students.length, 1);
      expect(students.first.id, id2);
    });
  });

  // ---------------------------------------------------------------------------
  // Group CRUD
  // ---------------------------------------------------------------------------

  group('createOrUpdateGroup', () {
    test('creates a new group and returns a positive id', () async {
      final id = await db.createOrUpdateGroup(makeGroup());
      expect(id, greaterThan(0));
    });

    test('update preserves id and changes name', () async {
      final id = await db.createOrUpdateGroup(makeGroup(name: 'Group A'));
      await db.createOrUpdateGroup(makeGroup(id: id, name: 'Group A Updated'));
      final groups = await db.getGroups();
      expect(groups.length, 1);
      expect(groups.first.name, 'Group A Updated');
    });
  });

  group('getGroups', () {
    test('returns all created groups', () async {
      await db.createOrUpdateGroup(makeGroup(name: 'A'));
      await db.createOrUpdateGroup(makeGroup(name: 'B'));
      final groups = await db.getGroups();
      expect(groups.length, 2);
    });

    test('returns empty list when no groups', () async {
      expect(await db.getGroups(), isEmpty);
    });
  });

  group('deleteGroup', () {
    test('removes the group', () async {
      final id = await db.createOrUpdateGroup(makeGroup());
      await db.deleteGroup(id);
      expect(await db.getGroups(), isEmpty);
    });

    test('does not affect other groups', () async {
      final id1 = await db.createOrUpdateGroup(makeGroup(name: 'A'));
      final id2 = await db.createOrUpdateGroup(makeGroup(name: 'B'));
      await db.deleteGroup(id1);
      final groups = await db.getGroups();
      expect(groups.length, 1);
      expect(groups.first.id, id2);
    });
  });

  // ---------------------------------------------------------------------------
  // Group memberships
  // ---------------------------------------------------------------------------

  group('syncGroupMemberships / getGroupMembers', () {
    test('adds students to a group', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      await db.syncGroupMemberships(groupId, [s1, s2]);
      final members = await db.getGroupMembers(groupId);
      expect(members.map((s) => s.id), containsAll([s1, s2]));
    });

    test('removes students no longer in the list', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      await db.syncGroupMemberships(groupId, [s1, s2]);
      await db.syncGroupMemberships(groupId, [s1]);
      final members = await db.getGroupMembers(groupId);
      expect(members.length, 1);
      expect(members.first.id, s1);
    });

    test('clears all members when passed an empty list', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final s1 = await db.createOrUpdateStudent(makeStudent());
      await db.syncGroupMemberships(groupId, [s1]);
      await db.syncGroupMemberships(groupId, []);
      expect(await db.getGroupMembers(groupId), isEmpty);
    });

    test('does not affect memberships of another group', () async {
      final g1 = await db.createOrUpdateGroup(makeGroup(name: 'G1'));
      final g2 = await db.createOrUpdateGroup(makeGroup(name: 'G2'));
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'Alice'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'Bob'));
      await db.syncGroupMemberships(g1, [s1]);
      await db.syncGroupMemberships(g2, [s2]);
      final members1 = await db.getGroupMembers(g1);
      expect(members1.length, 1);
      expect(members1.first.id, s1);
    });
  });

  // ---------------------------------------------------------------------------
  // Lesson CRUD
  // ---------------------------------------------------------------------------

  group('createOrUpdateLesson', () {
    test('creates a new lesson and returns a positive id', () async {
      final id = await db.createOrUpdateLesson(makeLesson());
      expect(id, greaterThan(0));
    });

    test('update preserves id and changes name', () async {
      final id = await db.createOrUpdateLesson(makeLesson(name: 'Math'));
      await db.createOrUpdateLesson(makeLesson(id: id, name: 'Physics'));
      final lesson = await db.getLesson(id);
      expect(lesson.name, 'Physics');
      expect(lesson.id, id);
    });
  });

  group('getLesson', () {
    test('returns the correct lesson', () async {
      final id = await db.createOrUpdateLesson(makeLesson(name: 'Chemistry'));
      final lesson = await db.getLesson(id);
      expect(lesson.id, id);
      expect(lesson.name, 'Chemistry');
    });

    test('throws when lesson does not exist', () async {
      expect(() => db.getLesson(9999), throwsStateError);
    });
  });

  group('getLessonsForRange', () {
    test('returns only lessons within the range', () async {
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 10)));
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 20)));
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 2, 5)));
      final lessons = await db.getLessonsForRange(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      expect(lessons.length, 2);
    });

    test('returns empty list when no lessons fall in range', () async {
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 3, 1)));
      final lessons = await db.getLessonsForRange(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      expect(lessons, isEmpty);
    });

    test('returns lessons ordered ascending by start', () async {
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 20)));
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 5)));
      final lessons = await db.getLessonsForRange(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 31),
      );
      expect(lessons[0].start.day, 5);
      expect(lessons[1].start.day, 20);
    });
  });

  group('updateLessonStatus', () {
    test('changes status to completed', () async {
      final id = await db.createOrUpdateLesson(makeLesson());
      final lesson = await db.getLesson(id);
      expect(lesson.isCompleted, true);
    });

    test('changes status to cancelled', () async {
      final id = await db.createOrUpdateLesson(makeLesson());
      await db.updateCancellation(id, true);
      final lesson = await db.getLesson(id);
      expect(lesson.isCancelled, true);
    });
  });

  // ---------------------------------------------------------------------------
  // Lesson participants
  // ---------------------------------------------------------------------------

  group('syncLessonMembership', () {
    test('adds a student participant', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeStudent(id: studentId)]);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.length, 1);
      expect(lesson.participants.first.student.id, studentId);
    });

    test('removes participants no longer in the list', () async {
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [
        makeStudent(id: s1),
        makeStudent(id: s2),
      ]);
      await db.syncLessonMembership(lessonId, [makeStudent(id: s1)]);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.length, 1);
      expect(lesson.participants.first.student.id, s1);
    });

    test('clears all participants when passed an empty list', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeStudent(id: studentId)]);
      await db.syncLessonMembership(lessonId, []);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants, isEmpty);
    });

    test('expands group members into individual participants', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      await db.syncGroupMemberships(groupId, [s1, s2]);
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeGroup(id: groupId)]);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.length, 2);
    });

    test(
      'participants default to not attended, not paid, homework not done',
      () async {
        final studentId = await db.createOrUpdateStudent(makeStudent());
        final lessonId = await db.createOrUpdateLesson(makeLesson());
        await db.syncLessonMembership(lessonId, [makeStudent(id: studentId)]);
        final lesson = await db.getLesson(lessonId);
        final p = lesson.participants.first;
        expect(p.attended, isFalse);
        expect(p.isPaid, isFalse);
        expect(p.homeworkDone, isFalse);
      },
    );
  });

  group('getLessonsForStudent', () {
    test('returns lessons where the student participates', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final l1 = await db.createOrUpdateLesson(makeLesson(name: 'L1'));
      final l2 = await db.createOrUpdateLesson(makeLesson(name: 'L2'));
      final student = makeStudent(id: studentId);
      await db.syncLessonMembership(l1, [student]);
      await db.syncLessonMembership(l2, [student]);
      final lessons = await db.getLessonsForStudent(studentId);
      expect(lessons.length, 2);
    });

    test('returns empty list for a student with no lessons', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      expect(await db.getLessonsForStudent(studentId), isEmpty);
    });

    test('does not return lessons for other students', () async {
      final s1 = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final s2 = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeStudent(id: s1)]);
      expect(await db.getLessonsForStudent(s2), isEmpty);
    });
  });

  group('updateParticipantStatus', () {
    late int studentId;
    late int lessonId;

    setUp(() async {
      studentId = await db.createOrUpdateStudent(makeStudent());
      lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeStudent(id: studentId)]);
    });

    test('sets attended to true', () async {
      await db.updateParticipantStatus(lessonId, studentId, attended: true);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.first.attended, isTrue);
    });

    test('sets isPaid to true', () async {
      await db.updateParticipantStatus(lessonId, studentId, isPaid: true);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.first.isPaid, isTrue);
    });

    test('sets homeworkDone to true', () async {
      await db.updateParticipantStatus(lessonId, studentId, homeworkDone: true);
      final lesson = await db.getLesson(lessonId);
      expect(lesson.participants.first.homeworkDone, isTrue);
    });

    test('updating one field does not reset others', () async {
      await db.updateParticipantStatus(lessonId, studentId, attended: true);
      await db.updateParticipantStatus(lessonId, studentId, isPaid: true);
      final lesson = await db.getLesson(lessonId);
      final p = lesson.participants.first;
      expect(p.attended, isTrue);
      expect(p.isPaid, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Payment stats
  // ---------------------------------------------------------------------------

  group('getPaymentStatForPeriod', () {
    test('counts paid and total lessons correctly', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final l1 = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 5)),
      );
      final l2 = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 10)),
      );
      final l3 = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 15)),
      );
      final student = makeStudent(id: studentId);
      await db.syncLessonMembership(l1, [student]);
      await db.syncLessonMembership(l2, [student]);
      await db.syncLessonMembership(l3, [student]);
      await db.updateParticipantStatus(l1, studentId, isPaid: true);
      await db.updateParticipantStatus(l2, studentId, isPaid: true);

      final stats = await db.getPaymentStatForPeriod(
        from: DateTime(2025, 1, 1),
        to: DateTime(2025, 1, 31),
        studentId: studentId,
      );
      expect(stats.paidLessons, 2);
      expect(stats.totalLessons, 3);
    });

    test('returns zero paid lessons when none are paid', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final l1 = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 5)),
      );
      await db.syncLessonMembership(l1, [makeStudent(id: studentId)]);

      final stats = await db.getPaymentStatForPeriod(
        from: DateTime(2025, 1, 1),
        to: DateTime(2025, 1, 31),
        studentId: studentId,
      );
      expect(stats.paidLessons, 0);
      expect(stats.totalLessons, 1);
    });

    test('no lessons in the period returns zeroes', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final stats = await db.getPaymentStatForPeriod(
        from: DateTime(2025, 1, 1),
        to: DateTime(2025, 1, 31),
        studentId: studentId,
      );
      expect(stats.paidLessons, 0);
      expect(stats.totalLessons, 0);
    });

    test('only counts lessons within the period', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final inRange = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 15)),
      );
      final outOfRange = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 3, 1)),
      );
      final student = makeStudent(id: studentId);
      await db.syncLessonMembership(inRange, [student]);
      await db.syncLessonMembership(outOfRange, [student]);
      await db.updateParticipantStatus(outOfRange, studentId, isPaid: true);

      final stats = await db.getPaymentStatForPeriod(
        from: DateTime(2025, 1, 1),
        to: DateTime(2025, 1, 31),
        studentId: studentId,
      );
      expect(stats.totalLessons, 1);
      expect(stats.paidLessons, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // Migrations
  // ---------------------------------------------------------------------------

  test('a dev database from another schema is wiped and recreated', () async {
    await db.close();
    // A dev build from before the schema reset: v8, with a since-removed
    // `status` column.
    db = DbClient(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE db_lessons (id INTEGER PRIMARY KEY, '
            'status TEXT NOT NULL)',
          );
          raw.execute("INSERT INTO db_lessons VALUES (1, 'scheduled')");
          raw.userVersion = 8;
        },
      ),
    );

    expect(
      await db.getLessonsForRange(DateTime(2000), DateTime(2100)),
      isEmpty,
    );
    final id = await db.createOrUpdateLesson(makeLesson());
    expect((await db.getLesson(id)).name, 'Math');
  });

  // ---------------------------------------------------------------------------
  // Regressions
  // ---------------------------------------------------------------------------

  group('regressions', () {
    test('student avatar path is persisted', () async {
      final id = await db.createOrUpdateStudent(
        Student(
          name: 'Alice',
          contact: '',
          pricing: const Rate(rate: 10, period: RatePeriod.perLesson),
          iconPath: '/avatars/a.png',
        ),
      );
      expect((await db.getStudent(id)).iconPath, '/avatars/a.png');
    });

    test('group avatar path is persisted and update keeps createdAt', () async {
      final id = await db.createOrUpdateGroup(
        const Group(
          name: 'G',
          pricing: Rate(rate: 10, period: RatePeriod.monthly),
          iconPath: '/avatars/g.png',
        ),
      );
      final createdAt = (await db.select(db.dbGroups).getSingle()).createdAt;
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await db.createOrUpdateGroup(makeGroup(id: id, name: 'Renamed'));

      final row = await db.select(db.dbGroups).getSingle();
      expect(row.createdAt, createdAt);
      expect(row.name, 'Renamed');
      expect((await db.getGroup(id)).iconPath, isNull);
    });

    test('updating a student keeps their group', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final id = await db.createOrUpdateStudent(makeStudent());
      await db.syncGroupMemberships(groupId, [id]);
      final student = await db.getStudent(id);

      await db.createOrUpdateStudent(student.copyWith(name: 'Alice B'));
      expect((await db.getStudent(id)).group?.id, groupId);
    });

    test('lessons for a student keep the other participants', () async {
      final a = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final b = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [
        makeStudent(id: a),
        makeStudent(id: b),
      ]);

      final lessons = await db.getLessonsForStudent(a);
      expect(lessons.single.participants.length, 2);
    });

    test('limit counts lessons, not participant rows', () async {
      final a = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final b = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      final groupId = await db.createOrUpdateGroup(makeGroup());
      await db.syncGroupMemberships(groupId, [a, b]);
      for (var day = 1; day <= 3; day++) {
        final id = await db.createOrUpdateLesson(
          makeLesson(start: DateTime(2025, 1, day)),
        );
        await db.syncLessonMembership(id, [makeGroup(id: groupId)]);
      }

      final lessons = await db.getLessonsForGroup(groupId, limit: 2);
      expect(lessons.map((l) => l.start.day), [3, 2]);
    });

    test('getLessonsForRange excludes the end boundary', () async {
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 6)));
      await db.createOrUpdateLesson(makeLesson(start: DateTime(2025, 1, 13)));

      final week = await db.getLessonsForRange(
        DateTime(2025, 1, 6),
        DateTime(2025, 1, 13),
      );
      expect(week.map((l) => l.start.day), [6]);
    });

    test(
      'unpaid lessons and debtors skip cancelled and future lessons',
      () async {
        final id = await db.createOrUpdateStudent(makeStudent());
        final student = makeStudent(id: id);
        final past = await db.createOrUpdateLesson(
          makeLesson(start: DateTime(2025, 1, 5)),
        );
        final cancelled = await db.createOrUpdateLesson(
          makeLesson(start: DateTime(2025, 1, 6), isCancelled: true),
        );
        final future = await db.createOrUpdateLesson(
          makeLesson(start: DateTime.now().add(const Duration(days: 3))),
        );
        for (final l in [past, cancelled, future]) {
          await db.syncLessonMembership(l, [student]);
        }

        final unpaid = await db.getUnpaidLessonsForStudent(id);
        expect(unpaid.map((l) => l.id), [past]);

        final debtors = await db.getDebtors();
        expect(debtors.single.unpaidLessons, 1);
      },
    );

    test(
      'deleting a student cascades to their lesson participations',
      () async {
        final a = await db.createOrUpdateStudent(makeStudent(name: 'A'));
        final b = await db.createOrUpdateStudent(makeStudent(name: 'B'));
        final lessonId = await db.createOrUpdateLesson(makeLesson());
        await db.syncLessonMembership(lessonId, [
          makeStudent(id: a),
          makeStudent(id: b),
        ]);

        await db.deleteStudent(a);
        final lesson = await db.getLesson(lessonId);
        expect(lesson.participants.map((p) => p.student.id), [b]);
      },
    );

    test('deleteLesson removes the lesson and its participants', () async {
      final id = await db.createOrUpdateStudent(makeStudent());
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.syncLessonMembership(lessonId, [makeStudent(id: id)]);

      await db.deleteLesson(lessonId);
      expect(() => db.getLesson(lessonId), throwsStateError);
      expect(await db.select(db.dbLessonParticipants).get(), isEmpty);
    });

    test('updateAllParticipantStatuses touches only that lesson', () async {
      final a = await db.createOrUpdateStudent(makeStudent(name: 'A'));
      final b = await db.createOrUpdateStudent(makeStudent(name: 'B'));
      final l1 = await db.createOrUpdateLesson(makeLesson());
      final l2 = await db.createOrUpdateLesson(makeLesson());
      for (final l in [l1, l2]) {
        await db.syncLessonMembership(l, [
          makeStudent(id: a),
          makeStudent(id: b),
        ]);
      }

      await db.updateAllParticipantStatuses(l1, isPaid: true);

      final first = await db.getLesson(l1);
      final second = await db.getLesson(l2);
      expect(first.participants.every((p) => p.isPaid), isTrue);
      expect(first.participants.every((p) => !p.attended), isTrue);
      expect(second.participants.every((p) => !p.isPaid), isTrue);
    });

    test('deleting a group detaches its members', () async {
      final groupId = await db.createOrUpdateGroup(makeGroup());
      final id = await db.createOrUpdateStudent(makeStudent());
      await db.syncGroupMemberships(groupId, [id]);

      await db.deleteGroup(groupId);
      expect((await db.getStudent(id)).group, isNull);
    });

    test(
      're-syncing through a group updates groupId but keeps statuses',
      () async {
        final groupId = await db.createOrUpdateGroup(makeGroup());
        final id = await db.createOrUpdateStudent(makeStudent());
        await db.syncGroupMemberships(groupId, [id]);
        final lessonId = await db.createOrUpdateLesson(makeLesson());

        await db.syncLessonMembership(lessonId, [makeStudent(id: id)]);
        await db.updateParticipantStatus(lessonId, id, attended: true);
        await db.syncLessonMembership(lessonId, [makeGroup(id: groupId)]);

        final p = (await db.getLesson(lessonId)).participants.single;
        expect(p.group?.id, groupId);
        expect(p.attended, isTrue);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------------------

  group('notes', () {
    test('saving inserts, then updates the same note', () async {
      final id = await db.saveNote(const Note(title: 'Ideas', body: 'games'));
      expect(await db.saveNote(Note(id: id, title: 'Ideas!', body: '')), id);
      final notes = await db.getNotes();
      expect(notes.single.title, 'Ideas!');
      expect(notes.single.updatedAt, isNotNull);
    });

    test('linked notes carry the names to show', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      await db.saveNote(Note(title: 'S', studentId: studentId));
      await db.saveNote(Note(title: 'L', lessonId: lessonId));

      final byStudent = (await db.getNotes(studentId: studentId)).single;
      expect(byStudent.studentName, 'Alice');
      final byLesson = (await db.getNotes(lessonId: lessonId)).single;
      expect(
        (byLesson.lessonName, byLesson.lessonStart),
        ('Math', DateTime(2025, 1, 15, 10)),
      );
    });

    test('deleting the student or lesson keeps the note, unlinked', () async {
      final studentId = await db.createOrUpdateStudent(makeStudent());
      final lessonId = await db.createOrUpdateLesson(makeLesson());
      final id = await db.saveNote(
        Note(title: 'Both', studentId: studentId, lessonId: lessonId),
      );

      await db.deleteStudent(studentId);
      await db.deleteLesson(lessonId);
      final note = await db.getNote(id);
      expect((note.studentId, note.lessonId), (null, null));
    });

    test('pinning does not count as an edit', () async {
      final older = await db.saveNote(const Note(title: 'older'));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await db.saveNote(const Note(title: 'newer'));

      await db.setNotePinned(older, true);
      final notes = await db.getNotes();
      expect(notes.map((n) => n.title), ['newer', 'older']);
      expect(notes.last.isPinned, isTrue);
    });

    test('deleteNote and clearAllRecords remove notes', () async {
      final a = await db.saveNote(const Note(title: 'a'));
      await db.saveNote(const Note(title: 'b'));
      await db.deleteNote(a);
      expect((await db.getNotes()).map((n) => n.title), ['b']);
      await db.clearAllRecords();
      expect(await db.getNotes(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Earnings data
  // ---------------------------------------------------------------------------

  group('earnings data', () {
    const own = Rate(rate: 10, period: RatePeriod.perLesson);
    const groupRate = Rate(rate: 7, period: RatePeriod.perLesson);
    final past = DateTime(2025, 1, 6, 10);
    final upcoming = DateTime.now().add(const Duration(days: 3));

    Future<Map<int, double>> storedRates() async => {
      for (final p in await db.select(db.dbLessonParticipants).get())
        p.lessonId: p.payRate,
    };

    /// A student with [own] rate in a group with [groupRate].
    Future<({int student, int group})> seed() async {
      final groupId = await db.createOrUpdateGroup(
        const Group(name: 'Club', pricing: groupRate),
      );
      final studentId = await db.createOrUpdateStudent(
        const Student(name: 'Anna', contact: '', pricing: own),
      );
      await db.syncGroupMemberships(groupId, [studentId]);
      return (student: studentId, group: groupId);
    }

    Future<int> book(DateTime start, Teachable subject) async {
      final id = await db.createOrUpdateLesson(makeLesson(start: start));
      await db.syncLessonMembership(id, [subject]);
      return id;
    }

    test(
      'students pay their own rate alone and the group rate in it',
      () async {
        final ids = await seed();
        final alone = await book(past, makeStudent(id: ids.student));
        final together = await book(
          past.add(const Duration(days: 1)),
          makeGroup(id: ids.group),
        );

        final rates = {
          for (final p in await db.getParticipations()) p.lessonId: p.rate,
        };
        expect(rates[alone], own);
        expect(rates[together], groupRate);
      },
    );

    test('a rate change re-prices upcoming lessons, not past ones', () async {
      final ids = await seed();
      final done = await book(past, makeStudent(id: ids.student));
      final next = await book(upcoming, makeStudent(id: ids.student));
      final groupNext = await book(
        upcoming.add(const Duration(hours: 2)),
        makeGroup(id: ids.group),
      );

      await db.createOrUpdateStudent(
        const Student(
          name: 'Anna',
          contact: '',
          pricing: Rate(rate: 12, period: RatePeriod.perLesson),
        ).copyWith(id: ids.student),
      );

      expect(await storedRates(), {done: 10, next: 12, groupNext: 7});
    });

    test('a group rate change re-prices its upcoming lessons', () async {
      final ids = await seed();
      final done = await book(past, makeGroup(id: ids.group));
      final next = await book(upcoming, makeGroup(id: ids.group));

      await db.createOrUpdateGroup(
        const Group(
          name: 'Club',
          pricing: Rate(rate: 9, period: RatePeriod.perLesson),
        ).copyWith(id: ids.group),
      );

      expect(await storedRates(), {done: 7, next: 9});
    });

    test('re-saving a past lesson keeps its price', () async {
      final ids = await seed();
      final done = await book(past, makeStudent(id: ids.student));
      await db.createOrUpdateStudent(
        const Student(
          name: 'Anna',
          contact: '',
          pricing: Rate(rate: 12, period: RatePeriod.perLesson),
        ).copyWith(id: ids.student),
      );

      await db.syncLessonMembership(done, [makeStudent(id: ids.student)]);
      expect(await storedRates(), {done: 10});
    });

    test('participations are billable, in range and filterable', () async {
      final ids = await seed();
      final jan = await book(past, makeStudent(id: ids.student));
      final feb = await book(DateTime(2025, 2, 3), makeGroup(id: ids.group));
      final cancelled = await db.createOrUpdateLesson(
        makeLesson(start: DateTime(2025, 1, 8), isCancelled: true),
      );
      await db.syncLessonMembership(cancelled, [makeStudent(id: ids.student)]);
      await book(upcoming, makeStudent(id: ids.student));
      await db.updateParticipantStatus(jan, ids.student, isPaid: true);

      Future<List<int>> lessons({
        DateTime? from,
        DateTime? to,
        int? groupId,
        bool unpaidOnly = false,
      }) async => [
        for (final p in await db.getParticipations(
          from: from,
          to: to,
          groupId: groupId,
          unpaidOnly: unpaidOnly,
        ))
          p.lessonId,
      ];

      expect(await lessons(), [jan, feb], reason: 'oldest first');
      expect(
        await lessons(from: DateTime(2025, 1), to: DateTime(2025, 2, 3)),
        [jan],
        reason: 'the end is excluded',
      );
      expect(await lessons(groupId: ids.group), [feb]);
      expect(await lessons(unpaidOnly: true), [feb]);
    });

    test('debtors owe their charges, most owed first', () async {
      final ids = await seed();
      final ben = await db.createOrUpdateStudent(
        const Student(
          name: 'Ben',
          contact: '',
          pricing: Rate(rate: 100, period: RatePeriod.monthly),
        ),
      );
      await book(past, makeStudent(id: ids.student));
      await book(past.add(const Duration(days: 1)), makeGroup(id: ids.group));
      for (final day in [6, 13, 20]) {
        await book(DateTime(2025, 1, day, 15), makeStudent(id: ben));
      }

      final debtors = await db.getDebtors();
      expect(debtors.map((d) => d.debtor.name), ['Ben', 'Anna']);
      // One January fee for three lessons.
      expect(debtors.first.amountOwed, 100);
      expect(debtors.first.unpaidLessons, 3);
      // Own rate alone plus the group's rate.
      expect(debtors.last.amountOwed, 17);
    });
  });
}
