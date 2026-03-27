import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleRepo extends Mock implements ScheduleRepo {}

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

Group makeGroup({int id = 1, Set<Student>? students}) => Group(
  id: id,
  name: 'Math Group',
  pricing: _rate,
  students: students ?? const {},
);

Student makeStudent({int id = 1}) =>
    Student(id: id, name: 'Alice', contact: '123', pricing: _rate);

Lesson makeLesson({int id = 1}) => Lesson(
  id: id,
  name: 'Math',
  subjects: const [],
  start: DateTime(2025, 1, 15, 10),
  duration: const Duration(hours: 1),
);

void main() {
  late MockScheduleRepo repo;

  setUp(() {
    repo = MockScheduleRepo();
  });

  // ---------------------------------------------------------------------------
  // loadGroup
  // ---------------------------------------------------------------------------

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'loadGroup emits [loading, loaded] on success',
    build: () => GroupDetailsCubit(repo),
    setUp: () {
      when(() => repo.getGroup(any())).thenAnswer((_) async => makeGroup());
      when(
        () => repo.getGroupMembers(any()),
      ).thenAnswer((_) async => {makeStudent()});
    },
    act: (c) => c.loadGroup(1),
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<GroupDetailsState>()
          .having((s) => s.group.id, 'group.id', 1)
          .having((s) => s.group.students.length, 'group.students.length', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'loadGroup emits error state on failure',
    build: () => GroupDetailsCubit(repo),
    setUp: () {
      when(() => repo.getGroup(any())).thenThrow(Exception('not found'));
    },
    act: (c) => c.loadGroup(99),
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<GroupDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // loadLessons
  // ---------------------------------------------------------------------------

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'loadLessons emits [loading, loaded] on success',
    build: () => GroupDetailsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForGroup(any()),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) => c.loadLessons(1),
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<GroupDetailsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.lessons.length, 'lessons.length', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'loadLessons emits error state on failure',
    build: () => GroupDetailsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForGroup(any()),
      ).thenThrow(Exception('db error'));
    },
    act: (c) => c.loadLessons(1),
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<GroupDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
