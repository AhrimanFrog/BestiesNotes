import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

// Minimal Lesson for test data
Lesson makeLesson({int id = 1, String name = 'Math'}) => Lesson(
  id: id,
  name: name,
  participants: const [],
  start: DateTime(2025, 1, 15, 10),
  duration: const Duration(hours: 1),
);

void main() {
  late MockDataProvider provider;

  setUpAll(() {
    registerFallbackValue(makeLesson());
    registerFallbackValue(true);
    registerFallbackValue(<Teachable>[]);
  });

  setUp(() {
    provider = MockDataProvider();
  });

  // ---------------------------------------------------------------------------
  // fetchLessons
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'fetchLessons emits [loading, loaded] on success',
    build: () => LessonsCubit(provider),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) => c.fetchLessons(),
    expect: () => [
      isA<LessonsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<LessonsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.lessons.length, 'lessons.length', 1)
          .having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<LessonsCubit, LessonsState>(
    'fetchLessons emits [loading, error] on failure',
    build: () => LessonsCubit(provider),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenThrow(Exception('network error'));
    },
    act: (c) => c.fetchLessons(),
    expect: () => [
      isA<LessonsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<LessonsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );

  blocTest<LessonsCubit, LessonsState>(
    'fetchLessons clears previous error on success',
    build: () => LessonsCubit(provider),
    seed: () => LessonsState(error: 'old error'),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.fetchLessons(),
    expect: () => [
      isA<LessonsState>().having((s) => s.error, 'error', isNull),
      isA<LessonsState>().having((s) => s.error, 'error', isNull),
    ],
  );

  blocTest<LessonsCubit, LessonsState>(
    'fetchLessons uses custom date range when provided',
    build: () => LessonsCubit(provider),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) =>
        c.fetchLessons(from: DateTime(2025, 3, 1), to: DateTime(2025, 3, 7)),
    verify: (_) {
      verify(
        () => provider.getLessonsForRange(
          DateTime(2025, 3, 1),
          DateTime(2025, 3, 7),
        ),
      ).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // Week navigation
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'goToPreviousWeek shifts dateFrom and dateTo back by 7 days',
    build: () => LessonsCubit(provider),
    seed: () => LessonsState(
      dateFrom: DateTime(2025, 1, 20),
      dateTo: DateTime(2025, 1, 27),
    ),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToPreviousWeek(),
    verify: (_) {
      verify(
        () => provider.getLessonsForRange(
          DateTime(2025, 1, 13),
          DateTime(2025, 1, 20),
        ),
      ).called(1);
    },
  );

  blocTest<LessonsCubit, LessonsState>(
    'goToNextWeek shifts dateFrom and dateTo forward by 7 days',
    build: () => LessonsCubit(provider),
    seed: () => LessonsState(
      dateFrom: DateTime(2025, 1, 20),
      dateTo: DateTime(2025, 1, 27),
    ),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToNextWeek(),
    verify: (_) {
      verify(
        () => provider.getLessonsForRange(
          DateTime(2025, 1, 27),
          DateTime(2025, 2, 3),
        ),
      ).called(1);
    },
  );

  blocTest<LessonsCubit, LessonsState>(
    'goToCurrentWeek resets to default date range',
    build: () => LessonsCubit(provider),
    seed: () => LessonsState(
      dateFrom: DateTime(2024, 1, 1),
      dateTo: DateTime(2024, 1, 7),
    ),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToCurrentWeek(),
    verify: (_) {
      verify(
        () => provider.getLessonsForRange(
          LessonsState.defaultDateFrom(),
          LessonsState.defaultDateTo(),
        ),
      ).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // refresh
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'refresh re-runs the range query for the currently shown week',
    build: () => LessonsCubit(provider),
    setUp: () {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) async {
      await c.fetchLessons();
      await c.goToNextWeek();
      await c.refresh();
    },
    verify: (c) {
      final calls = verify(
        () => provider.getLessonsForRange(captureAny(), any()),
      ).captured;
      expect(calls, hasLength(3));
      // The refresh used the week navigated to, not the original one.
      expect(calls.last, calls[1]);
      expect(c.state.dateFrom, calls.last);
    },
  );

  blocTest<LessonsCubit, LessonsState>(
    'refresh re-runs a per-student query',
    build: () => LessonsCubit(provider),
    setUp: () {
      when(
        () => provider.getLessonsForStudent(
          any(),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) async {
      await c.fetchLessonsByStudentId(7);
      await c.refresh();
    },
    verify: (_) => verify(
      () => provider.getLessonsForStudent(
        7,
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      ),
    ).called(2),
  );

  blocTest<LessonsCubit, LessonsState>(
    'refresh before any query does nothing',
    build: () => LessonsCubit(provider),
    act: (c) => c.refresh(),
    expect: () => [],
  );

  // ---------------------------------------------------------------------------
  // LessonsState.getLessonsByDate
  // ---------------------------------------------------------------------------

  group('LessonsState.getLessonsByDate', () {
    test('groups lessons by calendar day', () {
      final l1 = makeLesson(id: 1).copyWith(start: DateTime(2025, 1, 10, 9));
      final l2 = makeLesson(id: 2).copyWith(start: DateTime(2025, 1, 10, 14));
      final l3 = makeLesson(id: 3).copyWith(start: DateTime(2025, 1, 11, 10));
      final state = LessonsState(lessons: [l1, l2, l3]);
      final map = state.getLessonsByDate();
      expect(map[DateTime(2025, 1, 10)]?.length, 2);
      expect(map[DateTime(2025, 1, 11)]?.length, 1);
    });

    test('returns empty map when no lessons', () {
      expect(LessonsState().getLessonsByDate(), isEmpty);
    });
  });
}
