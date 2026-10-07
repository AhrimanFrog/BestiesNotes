import 'package:besties_notes/cubits/lessons/lesson_info_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

const _rate = Rate(rate: 10, period: RatePeriod.perLesson);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _rate);
const ben = Student(id: 2, name: 'Ben', contact: '', pricing: _rate);

LessonParticipant participant(Student s, {bool attended = false}) =>
    LessonParticipant(
      student: s,
      attended: attended,
      isPaid: false,
      homeworkDone: false,
    );

Lesson makeLesson({bool isCancelled = false}) => Lesson(
  id: 5,
  name: 'Grammar',
  participants: [participant(anna), participant(ben)],
  start: DateTime(2025, 1, 6, 10),
  duration: const Duration(minutes: 60),
  isCancelled: isCancelled,
);

void main() {
  late MockDataProvider provider;

  setUpAll(() {
    registerFallbackValue(makeLesson());
    registerFallbackValue(<Teachable>[]);
  });

  setUp(() => provider = MockDataProvider());

  LessonInfoState loaded([Lesson? lesson]) =>
      LessonInfoState(lesson: lesson ?? makeLesson());

  group('load', () {
    blocTest<LessonInfoCubit, LessonInfoState>(
      'emits the lesson',
      build: () => LessonInfoCubit(provider),
      setUp: () => when(
        () => provider.getLesson(5),
      ).thenAnswer((_) async => makeLesson()),
      act: (c) => c.load(5),
      expect: () => [
        isA<LessonInfoState>().having((s) => s.isLoading, 'isLoading', true),
        isA<LessonInfoState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.lesson?.name, 'name', 'Grammar'),
      ],
    );

    blocTest<LessonInfoCubit, LessonInfoState>(
      'emits an error for a missing lesson',
      build: () => LessonInfoCubit(provider),
      setUp: () => when(() => provider.getLesson(5)).thenThrow(StateError('')),
      act: (c) => c.load(5),
      skip: 1,
      expect: () => [
        isA<LessonInfoState>()
            .having((s) => s.error, 'error', isNotNull)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });

  group('editing', () {
    test('a fresh edit is not dirty; changing a field makes it dirty', () {
      final cubit = LessonInfoCubit(provider)..emit(loaded());
      cubit.startEditing();
      expect(cubit.state.isEditing, isTrue);
      expect(cubit.state.isNew, isFalse);
      expect(cubit.state.isDirty, isFalse);

      cubit.updateDraft(topic: 'Vocabulary');
      expect(cubit.state.isDirty, isTrue);

      cubit.updateDraft(topic: 'Grammar');
      expect(cubit.state.isDirty, isFalse, reason: 'back to the original');
    });

    test('discardChanges returns to the unchanged lesson', () {
      final cubit = LessonInfoCubit(provider)..emit(loaded());
      cubit
        ..startEditing()
        ..updateDraft(topic: 'Vocabulary')
        ..discardChanges();
      expect(cubit.state.isEditing, isFalse);
      expect(cubit.state.lesson?.name, 'Grammar');
    });

    test('startNew opens a new, clean draft', () {
      final cubit = LessonInfoCubit(provider)
        ..startNew(date: DateTime(2030, 1, 2));
      expect(cubit.state.isNew, isTrue);
      expect(cubit.state.isDirty, isFalse);
      expect(cubit.state.draft?.start.day, 2);
    });

    test('save refuses an incomplete draft without touching the db', () async {
      final cubit = LessonInfoCubit(provider)..startNew();
      expect(await cubit.save(), isFalse);
      verifyNever(() => provider.createOrUpdateLesson(any()));
    });

    test(
      'save writes lesson and members, then shows the saved lesson',
      () async {
        when(
          () => provider.createOrUpdateLesson(any()),
        ).thenAnswer((_) async => 5);
        when(
          () => provider.syncLessonMembership(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => provider.getLesson(5),
        ).thenAnswer((_) async => makeLesson(isCancelled: true));

        final cubit = LessonInfoCubit(provider)
          ..emit(loaded(makeLesson(isCancelled: true)))
          ..startEditing()
          ..updateDraft(topic: 'Vocabulary');

        expect(await cubit.save(), isTrue);

        final saved =
            verify(
                  () => provider.createOrUpdateLesson(captureAny()),
                ).captured.single
                as Lesson;
        expect(saved.id, 5);
        expect(saved.name, 'Vocabulary');
        expect(saved.isCancelled, isTrue, reason: 'editing keeps cancellation');
        verify(() => provider.syncLessonMembership(5, [anna, ben])).called(1);
        expect(cubit.state.isEditing, isFalse);
      },
    );

    test('a failed save keeps the draft so nothing is lost', () async {
      when(
        () => provider.createOrUpdateLesson(any()),
      ).thenThrow(Exception('disk full'));

      final cubit = LessonInfoCubit(provider)
        ..emit(loaded())
        ..startEditing()
        ..updateDraft(topic: 'Vocabulary');

      expect(await cubit.save(), isFalse);
      expect(cubit.state.isEditing, isTrue);
      expect(cubit.state.draft?.topic, 'Vocabulary');
      expect(cubit.state.isSaving, isFalse);
      expect(cubit.state.error, isNotNull);
    });
  });

  group('participant statuses', () {
    blocTest<LessonInfoCubit, LessonInfoState>(
      'toggles one participant optimistically',
      build: () => LessonInfoCubit(provider),
      seed: loaded,
      setUp: () => when(
        () => provider.updateParticipantStatus(5, 2, attended: true),
      ).thenAnswer((_) async {}),
      act: (c) => c.updateParticipantStatus(2, attended: true),
      expect: () => [
        isA<LessonInfoState>().having(
          (s) => s.lesson!.participants.map((p) => p.attended),
          'attended',
          [false, true],
        ),
      ],
    );

    blocTest<LessonInfoCubit, LessonInfoState>(
      'reverts the toggle when saving fails',
      build: () => LessonInfoCubit(provider),
      seed: loaded,
      setUp: () => when(
        () => provider.updateParticipantStatus(5, 2, attended: true),
      ).thenThrow(Exception('db error')),
      act: (c) => c.updateParticipantStatus(2, attended: true),
      expect: () => [
        isA<LessonInfoState>(),
        isA<LessonInfoState>()
            .having(
              (s) => s.lesson!.participants.every((p) => !p.attended),
              'reverted',
              isTrue,
            )
            .having((s) => s.error, 'error', isNotNull),
      ],
    );

    blocTest<LessonInfoCubit, LessonInfoState>(
      'markAll marks everyone present in one write',
      build: () => LessonInfoCubit(provider),
      seed: loaded,
      setUp: () => when(
        () => provider.updateAllParticipantStatuses(5, attended: true),
      ).thenAnswer((_) async {}),
      act: (c) => c.markAll(attended: true),
      expect: () => [
        isA<LessonInfoState>().having(
          (s) => s.lesson!.participants.every((p) => p.attended),
          'all present',
          isTrue,
        ),
      ],
      verify: (_) => verify(
        () => provider.updateAllParticipantStatuses(5, attended: true),
      ).called(1),
    );
  });

  group('lesson actions', () {
    blocTest<LessonInfoCubit, LessonInfoState>(
      'setCancelled updates the lesson',
      build: () => LessonInfoCubit(provider),
      seed: loaded,
      setUp: () => when(
        () => provider.updateCancellation(5, true),
      ).thenAnswer((_) async {}),
      act: (c) => c.setCancelled(true),
      expect: () => [
        isA<LessonInfoState>().having(
          (s) => s.lesson?.isCancelled,
          'cancelled',
          true,
        ),
      ],
    );

    blocTest<LessonInfoCubit, LessonInfoState>(
      'delete flags the state so the screen can close',
      build: () => LessonInfoCubit(provider),
      seed: loaded,
      setUp: () =>
          when(() => provider.deleteLesson(5)).thenAnswer((_) async {}),
      act: (c) => c.delete(),
      expect: () => [
        isA<LessonInfoState>().having((s) => s.isDeleted, 'isDeleted', true),
      ],
    );
  });
}
