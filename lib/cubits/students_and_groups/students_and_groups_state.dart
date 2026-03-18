part of 'students_and_groups_cubit.dart';

class StudentsAndGroupsState extends Equatable implements CubitState {
  final List<Student> students;
  final List<Group> groups;
  final bool noMoreStudents;
  final bool noMoreGroups;
  final Set<Student> groupMembers;
  final String searchQuery;
  final int? filterGroupId;
  final int activeDataIndex;
  @override
  final bool isLoading;
  @override
  final String? error;

  const StudentsAndGroupsState({
    this.students = const [],
    this.groups = const [],
    this.noMoreStudents = false,
    this.noMoreGroups = false,
    this.groupMembers = const {},
    this.searchQuery = '',
    this.filterGroupId,
    this.isLoading = false,
    this.error,
    this.activeDataIndex = 0,
  });

  List<Student> get filteredStudents {
    var result = students;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (s) =>
                s.name.toLowerCase().contains(query) ||
                s.contact.toLowerCase().contains(query),
          )
          .toList();
    }
    if (filterGroupId != null) {
      return result.where((s) => s.group?.id == filterGroupId).toList();
    }
    return result;
  }

  List<Group> get filteredGroups {
    var result = groups;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((g) => g.name.toLowerCase().contains(query))
          .toList();
    }
    return result;
  }

  StudentsAndGroupsState copyWith({
    List<Student>? students,
    List<Group>? groups,
    bool? noMoreStudents,
    bool? noMoreGroups,
    Set<Student>? groupMembers,
    String? searchQuery,
    int? Function()? filterGroupId,
    bool? isLoading,
    String? Function()? error,
    int? activeDataIndex,
  }) {
    return StudentsAndGroupsState(
      students: students ?? this.students,
      groups: groups ?? this.groups,
      noMoreStudents: noMoreStudents ?? this.noMoreStudents,
      noMoreGroups: noMoreGroups ?? this.noMoreGroups,
      searchQuery: searchQuery ?? this.searchQuery,
      groupMembers: groupMembers ?? this.groupMembers,
      filterGroupId: filterGroupId != null
          ? filterGroupId()
          : this.filterGroupId,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      activeDataIndex: activeDataIndex ?? this.activeDataIndex,
    );
  }

  @override
  List<Object?> get props => [
    students,
    groups,
    noMoreStudents,
    noMoreGroups,
    groupMembers,
    searchQuery,
    filterGroupId,
    isLoading,
    error,
    activeDataIndex,
  ];

  @override
  bool get isEmpty => activeDataIndex == 0 ? students.isEmpty : groups.isEmpty;
}
