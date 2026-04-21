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
    LessonStatus status = LessonStatus.scheduled,
  }) => Lesson(
    id: id,
    name: name,
    subjects: const [],
    start: start ?? DateTime(2025, 1, 15, 10, 0),
    duration: const Duration(hours: 1),
    status: status,
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
      expect(() => db.getLesson(9999), throwsException);
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
      final id = await db.createOrUpdateLesson(
        makeLesson(status: LessonStatus.scheduled),
      );
      await db.updateLessonStatus(id, LessonStatus.completed);
      final lesson = await db.getLesson(id);
      expect(lesson.status, LessonStatus.completed);
    });

    test('changes status to cancelled', () async {
      final id = await db.createOrUpdateLesson(makeLesson());
      await db.updateLessonStatus(id, LessonStatus.cancelled);
      final lesson = await db.getLesson(id);
      expect(lesson.status, LessonStatus.cancelled);
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
}
