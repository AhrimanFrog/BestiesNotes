part of 'students_and_groups_cubit.dart';

class StudentsAndGroupsState extends Equatable implements CubitState {
  final List<Student> students;
  final List<Group> groups;

  /// Amount owed per student id; students who owe nothing are absent.
  final Map<int, double> owed;

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
    this.owed = const {},
    this.searchQuery = '',
    this.filterGroupId,
    this.isLoading = false,
    this.error,
    this.activeDataIndex = 0,
  });

  double owedBy(Student student) => owed[student.id] ?? 0;

  int memberCount(Group group) =>
      students.where((s) => s.group?.id == group.id).length;

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
    Map<int, double>? owed,
    String? searchQuery,
    int? Function()? filterGroupId,
    bool? isLoading,
    String? error,
    int? activeDataIndex,
  }) {
    return StudentsAndGroupsState(
      students: students ?? this.students,
      groups: groups ?? this.groups,
      owed: owed ?? this.owed,
      searchQuery: searchQuery ?? this.searchQuery,
      filterGroupId: filterGroupId != null
          ? filterGroupId()
          : this.filterGroupId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      activeDataIndex: activeDataIndex ?? this.activeDataIndex,
    );
  }

  @override
  List<Object?> get props => [
    students,
    groups,
    owed,
    searchQuery,
    filterGroupId,
    isLoading,
    error,
    activeDataIndex,
  ];

  @override
  bool get isEmpty => activeDataIndex == 0 ? students.isEmpty : groups.isEmpty;
}
