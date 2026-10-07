import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

class MockPaymentProvider extends Mock implements PaymentProvider {}

const _rate = Rate(rate: 25, period: RatePeriod.perLesson);
const alice = Student(id: 1, name: 'Alice', contact: '123', pricing: _rate);

Lesson makeLesson({int id = 1, DateTime? start}) => Lesson(
  id: id,
  name: 'Math',
  start: start ?? DateTime(2025, 1, 15, 10),
  duration: const Duration(hours: 1),
);

void main() {
  late MockDataProvider provider;
  late MockPaymentProvider payments;

  setUpAll(() => registerFallbackValue(alice));

  setUp(() {
    provider = MockDataProvider();
    payments = MockPaymentProvider();
  });

  StudentDetailsCubit build() => StudentDetailsCubit(provider, payments);

  void stubLoad({Student student = alice, List<Lesson> unpaid = const []}) {
    when(() => provider.getStudent(any())).thenAnswer((_) async => student);
    when(
      () => provider.getLessonsForStudent(
        any(),
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => [makeLesson()]);
    when(
      () => payments.getUnpaidLessonsForStudent(any()),
    ).thenAnswer((_) async => unpaid);
    when(
      () => payments.getPaymentStatForPeriod(
        from: any(named: 'from'),
        to: any(named: 'to'),
        studentId: any(named: 'studentId'),
      ),
    ).thenAnswer((_) async => (paidLessons: 2, totalLessons: 3));
  }

  group('load', () {
    blocTest<StudentDetailsCubit, StudentDetailsState>(
      'loads student, lessons and balance',
      build: build,
      setUp: () => stubLoad(unpaid: [makeLesson(id: 1), makeLesson(id: 2)]),
      act: (c) => c.load(1),
      skip: 1,
      expect: () => [
        isA<StudentDetailsState>()
            .having((s) => s.student, 'student', alice)
            .having((s) => s.lessons.length, 'lessons', 1)
            .having((s) => s.amountOwed, 'amountOwed', 50)
            .having((s) => s.paidThisMonth, 'paidThisMonth', 2)
            .having((s) => s.totalThisMonth, 'totalThisMonth', 3)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<StudentDetailsCubit, StudentDetailsState>(
      'emits an error when the student is missing',
      build: build,
      setUp: () {
        stubLoad();
        when(() => provider.getStudent(any())).thenThrow(StateError('none'));
      },
      act: (c) => c.load(1),
      skip: 1,
      expect: () => [
        isA<StudentDetailsState>()
            .having((s) => s.error, 'error', isNotNull)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });

  group('editing', () {
    test('editing tracks unsaved changes against the original', () {
      final cubit = build()..emit(const StudentDetailsState(student: alice));
      cubit.startEditing();
      expect(cubit.state.isDirty, isFalse);
      expect(cubit.state.draft?.rateInput, '25');

      cubit.updateDraft((d) => d.copyWith(contact: '456'));
      expect(cubit.state.isDirty, isTrue);

      cubit.discardChanges();
      expect(cubit.state.isEditing, isFalse);
      expect(cubit.state.student, alice);
    });

    test('save refuses an incomplete draft', () async {
      final cubit = build()..startNew();
      cubit.updateDraft((d) => d.copyWith(name: 'Bob', rateInput: 'abc'));
      expect(await cubit.save(), isFalse);
      verifyNever(() => provider.createOrUpdateStudent(any()));
    });

    test('save creates the student and loads it', () async {
      stubLoad(student: alice.copyWith(id: 7));
      when(
        () => provider.createOrUpdateStudent(any()),
      ).thenAnswer((_) async => 7);

      final cubit = build()..startNew();
      cubit.updateDraft((d) => d.copyWith(name: ' Bob ', rateInput: '12,5'));
      expect(await cubit.save(), isTrue);

      final saved =
          verify(
                () => provider.createOrUpdateStudent(captureAny()),
              ).captured.single
              as Student;
      expect(saved.id, isNull);
      expect(saved.name, 'Bob');
      expect(saved.pricing.rate, 12.5);
      expect(cubit.state.isEditing, isFalse);
      expect(cubit.state.student?.id, 7);
    });

    test('changing the group is saved with the student', () async {
      stubLoad();
      when(
        () => provider.createOrUpdateStudent(any()),
      ).thenAnswer((_) async => 1);
      const club = Group(id: 4, name: 'Club', pricing: _rate);

      final cubit = build()
        ..emit(const StudentDetailsState(student: alice))
        ..startEditing()
        ..updateDraft((d) => d.copyWith(group: () => club));
      await cubit.save();

      final saved =
          verify(
                () => provider.createOrUpdateStudent(captureAny()),
              ).captured.single
              as Student;
      expect(saved.group?.id, 4);
    });
  });

  blocTest<StudentDetailsCubit, StudentDetailsState>(
    'delete flags the state so the screen can close',
    build: build,
    seed: () => const StudentDetailsState(student: alice),
    setUp: () => when(() => provider.deleteStudent(1)).thenAnswer((_) async {}),
    act: (c) => c.delete(),
    expect: () => [
      isA<StudentDetailsState>().having((s) => s.isDeleted, 'isDeleted', true),
    ],
  );
}
