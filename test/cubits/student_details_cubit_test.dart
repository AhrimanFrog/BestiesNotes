import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

Student makeStudent({int id = 1}) =>
    Student(id: id, name: 'Alice', contact: '123', pricing: _rate);

Lesson makeLesson({int id = 1}) => Lesson(
  id: id,
  name: 'Math',
  participants: const [],
  start: DateTime(2025, 1, 15, 10),
  duration: const Duration(hours: 1),
);

void main() {
  late MockDataProvider provider;

  setUp(() {
    provider = MockDataProvider();
  });

  // ---------------------------------------------------------------------------
  // loadStudent
  // ---------------------------------------------------------------------------

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadStudent emits [loading, loaded] on success',
    build: () => StudentDetailsCubit(provider),
    setUp: () {
      when(
        () => provider.getStudent(any()),
      ).thenAnswer((_) async => makeStudent());
      when(
        () => provider.getLessonsForStudent(any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.load(1),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>()
          .having((s) => s.student.id, 'student.id', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'loadStudent emits error state on failure',
    build: () => StudentDetailsCubit(provider),
    setUp: () {
      when(() => provider.getStudent(any())).thenThrow(Exception('not found'));
      when(
        () => provider.getLessonsForStudent(any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.load(99),
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
    build: () => StudentDetailsCubit(provider),
    setUp: () {
      when(
        () => provider.getStudent(any()),
      ).thenAnswer((_) async => makeStudent());
      when(
        () => provider.getLessonsForStudent(any()),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) => c.load(1),
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
    build: () => StudentDetailsCubit(provider),
    setUp: () {
      when(
        () => provider.getStudent(any()),
      ).thenAnswer((_) async => makeStudent());
      when(
        () => provider.getLessonsForStudent(any()),
      ).thenThrow(Exception('db error'));
    },
    act: (c) => c.load(1),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
