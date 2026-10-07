import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

class MockPaymentProvider extends Mock implements PaymentProvider {}

const _rate = Rate(rate: 10.0, period: RatePeriod.perLesson);

Student makeStudent({int? id = 1, String name = 'Alice', Group? group}) =>
    Student(id: id, name: name, contact: '123', pricing: _rate, group: group);

Group makeGroup({int? id = 1, String name = 'Group A'}) =>
    Group(id: id, name: name, pricing: _rate);

void main() {
  late MockDataProvider provider;
  late MockPaymentProvider payments;

  setUp(() {
    provider = MockDataProvider();
    payments = MockPaymentProvider();
    when(() => payments.getDebtors()).thenAnswer((_) async => []);
  });

  StudentsAndGroupsCubit build() => StudentsAndGroupsCubit(provider, payments);

  void stubStudents(List<Student> students) => when(
    () => provider.getStudents(
      offset: any(named: 'offset'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((_) async => students);

  void stubGroups(List<Group> groups) => when(
    () => provider.getGroups(
      offset: any(named: 'offset'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((_) async => groups);

  // ---------------------------------------------------------------------------
  // fetchStudents
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents emits [loading, loaded] on success',
    build: build,
    setUp: () => stubStudents([makeStudent()]),
    act: (c) => c.fetchStudents(),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.isLoading,
        'isLoading',
        true,
      ),
      isA<StudentsAndGroupsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.students.length, 'students.length', 1),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents replaces existing students instead of appending',
    build: build,
    seed: () => StudentsAndGroupsState(students: [makeStudent(id: 1)]),
    setUp: () => stubStudents([
      makeStudent(id: 1, name: 'Alice'),
      makeStudent(id: 2, name: 'Bob'),
    ]),
    act: (c) async {
      await c.fetchStudents();
      await c.fetchStudents();
    },
    verify: (c) => expect(c.state.students.map((s) => s.id), [1, 2]),
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents records what each student owes',
    build: build,
    setUp: () {
      final alice = makeStudent(id: 1);
      stubStudents([alice, makeStudent(id: 2, name: 'Bob')]);
      when(() => payments.getDebtors()).thenAnswer(
        (_) async => [
          Debtor(
            debtor: alice,
            unpaidLessonDates: [DateTime(2025, 1, 1), DateTime(2025, 1, 8)],
          ),
        ],
      );
    },
    act: (c) => c.fetchStudents(),
    verify: (c) {
      expect(c.state.owedBy(makeStudent(id: 1)), 20);
      expect(c.state.owedBy(makeStudent(id: 2)), 0);
    },
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents emits error on failure',
    build: build,
    setUp: () => when(
      () => provider.getStudents(
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      ),
    ).thenThrow(Exception('db error')),
    act: (c) => c.fetchStudents(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // fetchGroups / refresh
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroups emits [loading, loaded] on success',
    build: build,
    setUp: () => stubGroups([makeGroup()]),
    act: (c) => c.fetchGroups(),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.isLoading,
        'isLoading',
        true,
      ),
      isA<StudentsAndGroupsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.groups.length, 'groups.length', 1),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'refresh drops a group filter whose group was deleted',
    build: build,
    seed: () => StudentsAndGroupsState(
      groups: [makeGroup(id: 1), makeGroup(id: 2)],
      filterGroupId: 2,
    ),
    setUp: () {
      stubGroups([makeGroup(id: 1)]);
      stubStudents([]);
    },
    act: (c) => c.refresh(),
    verify: (c) => expect(c.state.filterGroupId, isNull),
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'refresh keeps a filter whose group still exists',
    build: build,
    seed: () =>
        StudentsAndGroupsState(groups: [makeGroup(id: 1)], filterGroupId: 1),
    setUp: () {
      stubGroups([makeGroup(id: 1)]);
      stubStudents([]);
    },
    act: (c) => c.refresh(),
    verify: (c) => expect(c.state.filterGroupId, 1),
  );

  // ---------------------------------------------------------------------------
  // Search & filter
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'setSearchQuery updates searchQuery',
    build: build,
    act: (c) => c.setSearchQuery('ali'),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.searchQuery,
        'searchQuery',
        'ali',
      ),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'setFilterGroup sets and clears filterGroupId',
    build: build,
    act: (c) => c
      ..setFilterGroup(1)
      ..setFilterGroup(null),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.filterGroupId,
        'filterGroupId',
        1,
      ),
      isA<StudentsAndGroupsState>().having(
        (s) => s.filterGroupId,
        'filterGroupId',
        isNull,
      ),
    ],
  );

  group('StudentsAndGroupsState.filteredStudents', () {
    final group = makeGroup(id: 1);
    final alice = makeStudent(id: 1, name: 'Alice', group: group);
    final bob = makeStudent(id: 2, name: 'Bob');
    final state = StudentsAndGroupsState(
      students: [alice, bob],
      groups: [group],
    );

    test('returns all students when query and filter are empty', () {
      expect(state.filteredStudents.length, 2);
    });

    test('filters by name (case-insensitive)', () {
      final filtered = state.copyWith(searchQuery: 'ali').filteredStudents;
      expect(filtered.single.name, 'Alice');
    });

    test('filters by contact', () {
      const withContact = Student(
        id: 3,
        name: 'Carol',
        contact: 'carol@example.com',
        pricing: _rate,
      );
      final s = state.copyWith(students: [...state.students, withContact]);
      expect(s.copyWith(searchQuery: 'carol@').filteredStudents.length, 1);
    });

    test('filters by group id', () {
      final filtered = state.copyWith(filterGroupId: () => 1).filteredStudents;
      expect(filtered.single.id, 1);
    });

    test('applies both search and group filter together', () {
      final filtered = state
          .copyWith(searchQuery: 'ali', filterGroupId: () => 1)
          .filteredStudents;
      expect(filtered.single.name, 'Alice');
    });

    test('memberCount counts students in the group', () {
      expect(state.memberCount(group), 1);
    });
  });

  group('StudentsAndGroupsState.filteredGroups', () {
    final g1 = makeGroup(id: 1, name: 'Alpha');
    final g2 = makeGroup(id: 2, name: 'Beta');
    final state = StudentsAndGroupsState(groups: [g1, g2]);

    test('returns all groups when query is empty', () {
      expect(state.filteredGroups.length, 2);
    });

    test('filters by name (case-insensitive)', () {
      final filtered = state.copyWith(searchQuery: 'alph').filteredGroups;
      expect(filtered.single.name, 'Alpha');
    });
  });
}
