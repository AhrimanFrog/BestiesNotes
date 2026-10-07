import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

class MockPaymentProvider extends Mock implements PaymentProvider {}

const _rate = Rate(rate: 100, period: RatePeriod.monthly);
const club = Group(id: 1, name: 'Club', pricing: _rate);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _rate);
const ben = Student(id: 2, name: 'Ben', contact: '', pricing: _rate);

Lesson makeLesson(DateTime start) =>
    Lesson(name: 'Talk', start: start, duration: const Duration(hours: 1));

void main() {
  late MockDataProvider provider;
  late MockPaymentProvider payments;

  setUpAll(() => registerFallbackValue(club));

  setUp(() {
    provider = MockDataProvider();
    payments = MockPaymentProvider();
  });

  GroupDetailsCubit build() => GroupDetailsCubit(provider, payments);

  void stubLoad({List<Student> members = const [anna]}) {
    when(() => provider.getGroup(any())).thenAnswer((_) async => club);
    when(
      () => provider.getLessonsForGroup(
        any(),
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => []);
    when(
      () => provider.getGroupMembers(any()),
    ).thenAnswer((_) async => members);
    final dates = [
      DateTime(2025, 1, 6),
      DateTime(2025, 1, 13),
      DateTime(2025, 2, 3),
    ];
    when(
      () => payments.getUnpaidLessonsForGroup(any()),
    ).thenAnswer((_) async => [for (final d in dates) makeLesson(d)]);
    when(
      () => payments.getParticipations(
        groupId: any(named: 'groupId'),
        unpaidOnly: any(named: 'unpaidOnly'),
      ),
    ).thenAnswer(
      (_) async => [
        for (final member in members)
          for (final (i, d) in dates.indexed)
            Participation(
              lessonId: i + 1,
              start: d,
              student: member,
              groupId: club.id,
              rate: _rate,
              isPaid: false,
            ),
      ],
    );
  }

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'load attaches members and computes the monthly balance',
    build: build,
    setUp: () => stubLoad(members: [anna, ben]),
    act: (c) => c.load(1),
    skip: 1,
    expect: () => [
      isA<GroupDetailsState>()
          .having((s) => s.group?.students.length, 'members', 2)
          // Monthly group rate, per member: January and February, twice.
          .having((s) => s.amountOwed, 'amountOwed', 400)
          .having((s) => s.isLoading, 'isLoading', false),
    ],
  );

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'load emits an error when the group is missing',
    build: build,
    setUp: () {
      stubLoad();
      when(() => provider.getGroup(any())).thenThrow(StateError('none'));
    },
    act: (c) => c.load(1),
    skip: 1,
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  group('editing', () {
    test('member order does not count as a change', () {
      final cubit = build()
        ..emit(GroupDetailsState(group: club.copyWith(students: {anna, ben})))
        ..startEditing()
        ..updateDraft((d) => d.copyWith(members: [ben, anna]));
      expect(cubit.state.isDirty, isFalse);

      cubit.updateDraft((d) => d.copyWith(members: [anna]));
      expect(cubit.state.isDirty, isTrue);
    });

    test('a group needs at least one member', () async {
      final cubit = build()
        ..startNew()
        ..updateDraft((d) => d.copyWith(name: 'New', rateInput: '50'));
      expect(await cubit.save(), isFalse);
      verifyNever(() => provider.createOrUpdateGroup(any()));
    });

    test('save writes the group and syncs its members', () async {
      stubLoad(members: [anna, ben]);
      when(
        () => provider.createOrUpdateGroup(any()),
      ).thenAnswer((_) async => 1);
      when(
        () => provider.syncGroupMemberships(any(), any()),
      ).thenAnswer((_) async {});

      final cubit = build()
        ..emit(GroupDetailsState(group: club.copyWith(students: {anna})))
        ..startEditing()
        ..updateDraft((d) => d.copyWith(members: [anna, ben]));

      expect(await cubit.save(), isTrue);
      verify(() => provider.syncGroupMemberships(1, [1, 2])).called(1);
      expect(cubit.state.isEditing, isFalse);
      expect(cubit.state.group?.students.length, 2);
    });
  });

  blocTest<GroupDetailsCubit, GroupDetailsState>(
    'delete flags the state so the screen can close',
    build: build,
    seed: () => const GroupDetailsState(group: club),
    setUp: () => when(() => provider.deleteGroup(1)).thenAnswer((_) async {}),
    act: (c) => c.delete(),
    expect: () => [
      isA<GroupDetailsState>().having((s) => s.isDeleted, 'isDeleted', true),
    ],
  );
}
