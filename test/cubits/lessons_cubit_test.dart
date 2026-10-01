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

  // ---------------------------------------------------------------------------
  // Calendar navigation
  // ---------------------------------------------------------------------------

  group('navigation', () {
    setUp(() {
      when(
        () => provider.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    });

    // Wednesday 22 Jan 2025.
    LessonsState onWednesday({CalendarView view = CalendarView.week}) =>
        LessonsState(anchor: DateTime(2025, 1, 22), view: view);

    void expectFetched(DateTime from, DateTime to) =>
        verify(() => provider.getLessonsForRange(from, to)).called(1);

    blocTest<LessonsCubit, LessonsState>(
      'fetchLessons loads the anchor week, Monday to Monday',
      build: () => LessonsCubit(provider),
      seed: onWednesday,
      act: (c) => c.fetchLessons(),
      verify: (_) =>
          expectFetched(DateTime(2025, 1, 20), DateTime(2025, 1, 27)),
    );

    blocTest<LessonsCubit, LessonsState>(
      'a Sunday week start shifts the range',
      build: () => LessonsCubit(provider, weekStart: DateTime.sunday),
      act: (c) => c.jumpTo(DateTime(2025, 1, 22)),
      verify: (_) =>
          expectFetched(DateTime(2025, 1, 19), DateTime(2025, 1, 26)),
    );

    blocTest<LessonsCubit, LessonsState>(
      'goToPrevious / goToNext step a week in week view',
      build: () => LessonsCubit(provider),
      seed: onWednesday,
      act: (c) async {
        await c.goToPrevious();
        await c.goToNext();
        await c.goToNext();
      },
      verify: (c) {
        expectFetched(DateTime(2025, 1, 13), DateTime(2025, 1, 20));
        expectFetched(DateTime(2025, 1, 27), DateTime(2025, 2, 3));
        expect(c.state.anchor, DateTime(2025, 1, 29));
      },
    );

    blocTest<LessonsCubit, LessonsState>(
      'month view loads the six-week grid around the month',
      build: () => LessonsCubit(provider),
      seed: onWednesday,
      act: (c) => c.setView(CalendarView.month),
      // January 2025 starts on a Wednesday: the grid starts Mon 30 Dec.
      verify: (_) =>
          expectFetched(DateTime(2024, 12, 30), DateTime(2025, 2, 10)),
    );

    blocTest<LessonsCubit, LessonsState>(
      'goToNext in month view lands on the 1st of the next month',
      build: () => LessonsCubit(provider),
      seed: () =>
          LessonsState(anchor: DateTime(2025, 1, 31), view: CalendarView.month),
      act: (c) => c.goToNext(),
      verify: (c) => expect(c.state.anchor, DateTime(2025, 2, 1)),
    );

    blocTest<LessonsCubit, LessonsState>(
      'selecting a day of the same month does not refetch',
      build: () => LessonsCubit(provider),
      seed: () => onWednesday(view: CalendarView.month),
      act: (c) => c.selectDay(DateTime(2025, 1, 9)),
      expect: () => [
        isA<LessonsState>().having(
          (s) => s.anchor,
          'anchor',
          DateTime(2025, 1, 9),
        ),
      ],
      verify: (_) =>
          verifyNever(() => provider.getLessonsForRange(any(), any())),
    );

    blocTest<LessonsCubit, LessonsState>(
      'selecting a trailing day of the next month moves the grid',
      build: () => LessonsCubit(provider),
      seed: () => onWednesday(view: CalendarView.month),
      act: (c) => c.selectDay(DateTime(2025, 2, 3)),
      verify: (c) {
        expect(c.state.anchor, DateTime(2025, 2, 3));
        expectFetched(DateTime(2025, 1, 27), DateTime(2025, 3, 10));
      },
    );

    blocTest<LessonsCubit, LessonsState>(
      'goToToday anchors on today',
      build: () => LessonsCubit(provider),
      seed: onWednesday,
      act: (c) => c.goToToday(),
      verify: (c) {
        final now = DateTime.now();
        expect(c.state.anchor, DateTime(now.year, now.month, now.day));
        expect(c.state.showsToday, isTrue);
      },
    );
  });

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
      await c.goToNext();
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
