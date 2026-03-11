import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleRepo extends Mock implements ScheduleRepo {}

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

Student makeStudent({int? id = 1, String name = 'Alice', Group? group}) =>
    Student(id: id, name: name, contact: '123', pricing: _rate, group: group);

Group makeGroup({int? id = 1, String name = 'Group A'}) =>
    Group(id: id, name: name, pricing: _rate);

void main() {
  late MockScheduleRepo repo;

  setUpAll(() {
    registerFallbackValue(makeStudent());
    registerFallbackValue(makeGroup());
  });

  setUp(() {
    repo = MockScheduleRepo();
  });

  // ---------------------------------------------------------------------------
  // fetchStudents
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents emits [loading, loaded] on success',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getStudents(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenAnswer((_) async => [makeStudent()]);
    },
    act: (c) => c.fetchStudents(),
    expect: () => [
      isA<StudentsAndGroupsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentsAndGroupsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.students.length, 'students.length', 1),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents appends to existing students',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(students: [makeStudent(id: 1, name: 'Alice')]),
    setUp: () {
      when(
        () => repo.getStudents(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenAnswer((_) async => [makeStudent(id: 2, name: 'Bob')]);
    },
    act: (c) => c.fetchStudents(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>().having((s) => s.students.length, 'students.length', 2),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents sets noMoreStudents when repo returns empty list',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getStudents(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.fetchStudents(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>()
          .having((s) => s.noMoreStudents, 'noMoreStudents', true),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents does nothing when noMoreStudents is true',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => const StudentsAndGroupsState(noMoreStudents: true),
    act: (c) => c.fetchStudents(),
    expect: () => [],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchStudents emits error on failure',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getStudents(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenThrow(Exception('db error'));
    },
    act: (c) => c.fetchStudents(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // fetchGroups
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroups emits [loading, loaded] on success',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getGroups(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenAnswer((_) async => [makeGroup()]);
    },
    act: (c) => c.fetchGroups(),
    expect: () => [
      isA<StudentsAndGroupsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<StudentsAndGroupsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.groups.length, 'groups.length', 1),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroups sets noMoreGroups when repo returns empty list',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getGroups(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenAnswer((_) async => []);
    },
    act: (c) => c.fetchGroups(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>()
          .having((s) => s.noMoreGroups, 'noMoreGroups', true),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroups does nothing when noMoreGroups is true',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => const StudentsAndGroupsState(noMoreGroups: true),
    act: (c) => c.fetchGroups(),
    expect: () => [],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroups emits error on failure',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getGroups(offset: any(named: 'offset'), limit: any(named: 'limit')),
      ).thenThrow(Exception('db error'));
    },
    act: (c) => c.fetchGroups(),
    expect: () => [
      anything,
      isA<StudentsAndGroupsState>().having((s) => s.error, 'error', isNotNull),
    ],
  );

  // ---------------------------------------------------------------------------
  // createOrUpdateStudent
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateStudent adds new student to state',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.createOrUpdateStudent(any()),
      ).thenAnswer((_) async => 42);
    },
    act: (c) => c.createOrUpdateStudent(makeStudent(id: null)),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.students.length, 'students.length', 1)
          .having((s) => s.students.first.id, 'students.first.id', 42),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateStudent updates existing student in state',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(students: [makeStudent(id: 1, name: 'Alice')]),
    setUp: () {
      when(
        () => repo.createOrUpdateStudent(any()),
      ).thenAnswer((_) async => 1);
    },
    act: (c) => c.createOrUpdateStudent(makeStudent(id: 1, name: 'Alice Updated')),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.students.length, 'students.length', 1)
          .having((s) => s.students.first.name, 'name', 'Alice Updated'),
    ],
  );

  // ---------------------------------------------------------------------------
  // deleteStudent
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'deleteStudent removes student from state',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(students: [makeStudent(id: 1), makeStudent(id: 2, name: 'Bob')]),
    setUp: () {
      when(() => repo.deleteStudent(any())).thenAnswer((_) async {});
    },
    act: (c) => c.deleteStudent(1),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.students.length, 'students.length', 1)
          .having((s) => s.students.first.id, 'id', 2),
    ],
  );

  // ---------------------------------------------------------------------------
  // createOrUpdateGroup
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateGroup adds new group to state',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(() => repo.createOrUpdateGroup(any())).thenAnswer((_) async => 5);
      when(
        () => repo.syncGroupMemberships(any(), any()),
      ).thenAnswer((_) async {});
    },
    act: (c) => c.createOrUpdateGroup(makeGroup(id: null)),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.groups.length, 'groups.length', 1)
          .having((s) => s.groups.first.id, 'id', 5),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateGroup updates existing group in state',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(groups: [makeGroup(id: 1, name: 'G1')]),
    setUp: () {
      when(() => repo.createOrUpdateGroup(any())).thenAnswer((_) async => 1);
      when(
        () => repo.syncGroupMemberships(any(), any()),
      ).thenAnswer((_) async {});
    },
    act: (c) => c.createOrUpdateGroup(makeGroup(id: 1, name: 'G1 Updated')),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.groups.length, 'groups.length', 1)
          .having((s) => s.groups.first.name, 'name', 'G1 Updated'),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateGroup reflects membership changes on in-state students',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(
      students: [makeStudent(id: 10, name: 'Alice')],
      groups: [],
    ),
    setUp: () {
      when(() => repo.createOrUpdateGroup(any())).thenAnswer((_) async => 3);
      when(
        () => repo.syncGroupMemberships(any(), any()),
      ).thenAnswer((_) async {});
    },
    act: (c) => c.createOrUpdateGroup(
      Group(
        id: null,
        name: 'New Group',
        pricing: _rate,
        students: {makeStudent(id: 10)},
      ),
    ),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.students.first.group?.id,
        'students.first.group.id',
        3,
      ),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'createOrUpdateGroup clears group from students removed from membership',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () {
      final group = makeGroup(id: 2);
      return StudentsAndGroupsState(
        students: [makeStudent(id: 10, group: group)],
        groups: [group],
      );
    },
    setUp: () {
      when(() => repo.createOrUpdateGroup(any())).thenAnswer((_) async => 2);
      when(
        () => repo.syncGroupMemberships(any(), any()),
      ).thenAnswer((_) async {});
    },
    // Update group with no students — student 10 should lose its group ref
    act: (c) => c.createOrUpdateGroup(makeGroup(id: 2)),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.students.first.group,
        'students.first.group',
        isNull,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // deleteGroup
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'deleteGroup removes the group from state',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(
      groups: [makeGroup(id: 1), makeGroup(id: 2, name: 'B')],
    ),
    setUp: () {
      when(() => repo.deleteGroup(any())).thenAnswer((_) async {});
    },
    act: (c) => c.deleteGroup(1),
    expect: () => [
      isA<StudentsAndGroupsState>()
          .having((s) => s.groups.length, 'groups.length', 1)
          .having((s) => s.groups.first.id, 'id', 2),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'deleteGroup clears group reference from affected students',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () {
      final group = makeGroup(id: 1);
      return StudentsAndGroupsState(
        groups: [group],
        students: [makeStudent(id: 10, group: group)],
      );
    },
    setUp: () {
      when(() => repo.deleteGroup(any())).thenAnswer((_) async {});
    },
    act: (c) => c.deleteGroup(1),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.students.first.group,
        'students.first.group',
        isNull,
      ),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'deleteGroup resets filterGroupId when it matches the deleted group',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => StudentsAndGroupsState(
      groups: [makeGroup(id: 1)],
      filterGroupId: 1,
    ),
    setUp: () {
      when(() => repo.deleteGroup(any())).thenAnswer((_) async {});
    },
    act: (c) => c.deleteGroup(1),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.filterGroupId,
        'filterGroupId',
        isNull,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // fetchGroupMembers
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'fetchGroupMembers updates groupMembers in state',
    build: () => StudentsAndGroupsCubit(repo),
    setUp: () {
      when(
        () => repo.getGroupMembers(any()),
      ).thenAnswer((_) async => {makeStudent(id: 10)});
    },
    act: (c) => c.fetchGroupMembers(1),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.groupMembers.length,
        'groupMembers.length',
        1,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // setSearchQuery / setFilterGroup
  // ---------------------------------------------------------------------------

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'setSearchQuery updates searchQuery',
    build: () => StudentsAndGroupsCubit(repo),
    act: (c) => c.setSearchQuery('ali'),
    expect: () => [
      isA<StudentsAndGroupsState>().having((s) => s.searchQuery, 'searchQuery', 'ali'),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'setFilterGroup updates filterGroupId',
    build: () => StudentsAndGroupsCubit(repo),
    act: (c) => c.setFilterGroup(3),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.filterGroupId,
        'filterGroupId',
        3,
      ),
    ],
  );

  blocTest<StudentsAndGroupsCubit, StudentsAndGroupsState>(
    'setFilterGroup clears filterGroupId when null is passed',
    build: () => StudentsAndGroupsCubit(repo),
    seed: () => const StudentsAndGroupsState(filterGroupId: 3),
    act: (c) => c.setFilterGroup(null),
    expect: () => [
      isA<StudentsAndGroupsState>().having(
        (s) => s.filterGroupId,
        'filterGroupId',
        isNull,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // StudentsAndGroupsState computed properties (pure, no mock needed)
  // ---------------------------------------------------------------------------

  group('StudentsAndGroupsState.filteredStudents', () {
    final group = makeGroup(id: 1);
    final alice = makeStudent(id: 1, name: 'Alice', group: group);
    final bob = makeStudent(id: 2, name: 'Bob');
    final state = StudentsAndGroupsState(students: [alice, bob], groups: [group]);

    test('returns all students when query and filter are empty', () {
      expect(state.filteredStudents.length, 2);
    });

    test('filters by name (case-insensitive)', () {
      final filtered = state.copyWith(searchQuery: 'ali').filteredStudents;
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Alice');
    });

    test('filters by contact', () {
      final withContact = Student(
        id: 3,
        name: 'Carol',
        contact: 'carol@example.com',
        pricing: _rate,
      );
      final s = state.copyWith(students: [...state.students, withContact]);
      final filtered = s.copyWith(searchQuery: 'carol@').filteredStudents;
      expect(filtered.length, 1);
    });

    test('filters by group id', () {
      final filtered = state
          .copyWith(filterGroupId: () => 1)
          .filteredStudents;
      expect(filtered.length, 1);
      expect(filtered.first.id, 1);
    });

    test('applies both search and group filter together', () {
      // alice is in group 1 and matches 'ali', bob is not in any group
      final filtered = state
          .copyWith(searchQuery: 'ali', filterGroupId: () => 1)
          .filteredStudents;
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Alice');
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
      expect(filtered.length, 1);
      expect(filtered.first.name, 'Alpha');
    });
  });
}
