part of 'students_and_groups_cubit.dart';

class StudentsAndGroupsState extends Equatable {
  final List<Student> students;
  final List<Group> groups;
  final bool noMoreStudents;
  final bool noMoreGroups;

  const StudentsAndGroupsState({
    this.students = const [],
    this.groups = const [],
    this.noMoreStudents = false,
    this.noMoreGroups = false,
  });

  StudentsAndGroupsState copyWith({
    List<Student>? students,
    List<Group>? groups,
    bool? noMoreStudents,
    bool? noMoreGroups,
  }) {
    return StudentsAndGroupsState(
      students: students ?? this.students,
      groups: groups ?? this.groups,
      noMoreStudents: noMoreStudents ?? this.noMoreStudents,
      noMoreGroups: noMoreGroups ?? this.noMoreGroups,
    );
  }

  @override
  List<Object?> get props => [students, groups, noMoreStudents, noMoreGroups];
}
