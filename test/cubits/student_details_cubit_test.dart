import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleRepo extends Mock implements ScheduleRepo {}

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

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
  // loadStudent
  // ---------------------------------------------------------------------------

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadStudent emits [loading, loaded] on success',
    build: () => StudentDetailsCubit(repo),
    setUp: () {
      when(() => repo.getStudent(any())).thenAnswer((_) async => makeStudent());
    },
    act: (c) => c.loadStudent(1),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>()
          .having((s) => s.student.id, 'student.id', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadStudent emits error state on failure',
    build: () => StudentDetailsCubit(repo),
    setUp: () {
      when(() => repo.getStudent(any())).thenThrow(Exception('not found'));
    },
    act: (c) => c.loadStudent(99),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // loadLessons
  // ---------------------------------------------------------------------------

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadLessons emits [loading, loaded] on success',
    build: () => StudentDetailsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForStudent(any()),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) => c.loadLessons(1),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.lessons.length, 'lessons.length', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadLessons emits error state on failure',
    build: () => StudentDetailsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForStudent(any()),
      ).thenThrow(Exception('db error'));
    },
    act: (c) => c.loadLessons(1),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
