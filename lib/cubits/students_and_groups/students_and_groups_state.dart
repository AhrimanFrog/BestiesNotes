part of 'students_and_groups_cubit.dart';

class StudentsAndGroupsState extends Equatable {
  final List<Student> students;
  final List<Group> groups;
  final bool noMoreStudents;
  final bool noMoreGroups;
  final String searchQuery;
  final int? filterGroupId;

  const StudentsAndGroupsState({
    this.students = const [],
    this.groups = const [],
    this.noMoreStudents = false,
    this.noMoreGroups = false,
    this.searchQuery = '',
    this.filterGroupId,
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
      result = result.where((s) => s.group?.id == filterGroupId).toList();
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
    String? searchQuery,
    int? Function()? filterGroupId,
  }) {
    return StudentsAndGroupsState(
      students: students ?? this.students,
      groups: groups ?? this.groups,
      noMoreStudents: noMoreStudents ?? this.noMoreStudents,
      noMoreGroups: noMoreGroups ?? this.noMoreGroups,
      searchQuery: searchQuery ?? this.searchQuery,
      filterGroupId: filterGroupId != null
          ? filterGroupId()
          : this.filterGroupId,
    );
  }

  @override
  List<Object?> get props => [
    students,
    groups,
    noMoreStudents,
    noMoreGroups,
    searchQuery,
    filterGroupId,
  ];
}
