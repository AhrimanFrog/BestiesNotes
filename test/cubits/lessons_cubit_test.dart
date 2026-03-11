import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleRepo extends Mock implements ScheduleRepo {}

// Minimal Lesson for test data
Lesson makeLesson({int id = 1, String name = 'Math'}) => Lesson(
  id: id,
  name: name,
  subjects: const [],
  start: DateTime(2025, 1, 15, 10),
  duration: const Duration(hours: 1),
);

void main() {
  late MockScheduleRepo repo;

  setUpAll(() {
    registerFallbackValue(makeLesson());
  });

  setUp(() {
    repo = MockScheduleRepo();
  });

  // ---------------------------------------------------------------------------
  // fetchLessons
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'fetchLessons emits [loading, loaded] on success',
    build: () => LessonsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
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
    build: () => LessonsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
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
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(error: 'old error'),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
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
    build: () => LessonsCubit(repo),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.fetchLessons(
      from: DateTime(2025, 3, 1),
      to: DateTime(2025, 3, 7),
    ),
    verify: (_) {
      verify(
        () => repo.getLessonsForRange(DateTime(2025, 3, 1), DateTime(2025, 3, 7)),
      ).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // Week navigation
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'goToPreviousWeek shifts dateFrom and dateTo back by 7 days',
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(
      dateFrom: DateTime(2025, 1, 20),
      dateTo: DateTime(2025, 1, 27),
    ),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToPreviousWeek(),
    verify: (_) {
      verify(
        () => repo.getLessonsForRange(DateTime(2025, 1, 13), DateTime(2025, 1, 20)),
      ).called(1);
    },
  );

  blocTest<LessonsCubit, LessonsState>(
    'goToNextWeek shifts dateFrom and dateTo forward by 7 days',
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(
      dateFrom: DateTime(2025, 1, 20),
      dateTo: DateTime(2025, 1, 27),
    ),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToNextWeek(),
    verify: (_) {
      verify(
        () => repo.getLessonsForRange(DateTime(2025, 1, 27), DateTime(2025, 2, 3)),
      ).called(1);
    },
  );

  blocTest<LessonsCubit, LessonsState>(
    'goToCurrentWeek resets to default date range',
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(
      dateFrom: DateTime(2024, 1, 1),
      dateTo: DateTime(2024, 1, 7),
    ),
    setUp: () {
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.goToCurrentWeek(),
    verify: (_) {
      verify(
        () => repo.getLessonsForRange(
          LessonsState.defaultDateFrom(),
          LessonsState.defaultDateTo(),
        ),
      ).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // createOrUpdateLesson
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'createOrUpdateLesson saves lesson and refetches',
    build: () => LessonsCubit(repo),
    setUp: () {
      when(
        () => repo.createOrUpdateLesson(any()),
      ).thenAnswer((_) async => 1);
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => [makeLesson()]);
    },
    act: (c) => c.createOrUpdateLesson(makeLesson()),
    verify: (_) {
      verify(() => repo.createOrUpdateLesson(any())).called(1);
      verify(() => repo.getLessonsForRange(any(), any())).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // cancelLesson
  // ---------------------------------------------------------------------------

  blocTest<LessonsCubit, LessonsState>(
    'cancelLesson cancels lesson and refetches',
    build: () => LessonsCubit(repo),
    setUp: () {
      when(() => repo.cancelLesson(any())).thenAnswer((_) async {});
      when(
        () => repo.getLessonsForRange(any(), any()),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.cancelLesson(1),
    verify: (_) {
      verify(() => repo.cancelLesson(1)).called(1);
    },
  );

  // ---------------------------------------------------------------------------
  // updateParticipantStatus — optimistic update & rollback
  // ---------------------------------------------------------------------------

  final participant = LessonParticipant(
    student: const Student(
      id: 10,
      name: 'Alice',
      contact: '',
      pricing: Rate(rate: 0, period: RatePeriod.monthly),
    ),
    attended: false,
    isPaid: false,
    homeworkDone: false,
  );

  final lessonWithParticipant = Lesson(
    id: 1,
    name: 'Math',
    subjects: const [],
    participants: [participant],
    start: DateTime(2025, 1, 15, 10),
    duration: const Duration(hours: 1),
  );

  blocTest<LessonsCubit, LessonsState>(
    'updateParticipantStatus applies optimistic update immediately',
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(lessons: [lessonWithParticipant]),
    setUp: () {
      when(
        () => repo.updateParticipantStatus(
          any(),
          any(),
          attended: any(named: 'attended'),
          isPaid: any(named: 'isPaid'),
          homeworkDone: any(named: 'homeworkDone'),
        ),
      ).thenAnswer((_) async {});
    },
    act: (c) => c.updateParticipantStatus(1, 10, attended: true),
    expect: () => [
      isA<LessonsState>().having(
        (s) => s.lessons.first.participants.first.attended,
        'attended',
        true,
      ),
    ],
  );

  blocTest<LessonsCubit, LessonsState>(
    'updateParticipantStatus rolls back and sets error when repo throws',
    build: () => LessonsCubit(repo),
    seed: () => LessonsState(lessons: [lessonWithParticipant]),
    setUp: () {
      when(
        () => repo.updateParticipantStatus(
          any(),
          any(),
          attended: any(named: 'attended'),
          isPaid: any(named: 'isPaid'),
          homeworkDone: any(named: 'homeworkDone'),
        ),
      ).thenThrow(Exception('save failed'));
    },
    act: (c) => c.updateParticipantStatus(1, 10, attended: true),
    expect: () => [
      // optimistic update
      isA<LessonsState>().having(
        (s) => s.lessons.first.participants.first.attended,
        'attended',
        true,
      ),
      // rollback
      isA<LessonsState>()
          .having(
            (s) => s.lessons.first.participants.first.attended,
            'attended',
            false,
          )
          .having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // LessonsState.getLessonsByDate
  // ---------------------------------------------------------------------------

  group('LessonsState.getLessonsByDate', () {
    test('groups lessons by calendar day', () {
      final l1 = makeLesson(id: 1)
          .copyWith(start: DateTime(2025, 1, 10, 9));
      final l2 = makeLesson(id: 2)
          .copyWith(start: DateTime(2025, 1, 10, 14));
      final l3 = makeLesson(id: 3)
          .copyWith(start: DateTime(2025, 1, 11, 10));
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
