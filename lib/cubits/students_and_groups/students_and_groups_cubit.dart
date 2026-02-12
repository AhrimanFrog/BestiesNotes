import 'package:besties_notes/data/ui_models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'students_and_groups_state.dart';

class StudentsAndGroupsCubit extends Cubit<StudentsAndGroupsState> {
  final ScheduleRepo _scheduleRepo;

  StudentsAndGroupsCubit(this._scheduleRepo) : super(StudentsAndGroupsState());

  Future<void> fetchStudents({int offset = 0, limit = 100}) async {
    if (state.noMoreStudents) return;
    final students = await _scheduleRepo.getStudents(
      offset: offset,
      limit: limit,
    );
    if (students.isEmpty) return emit(state.copyWith(noMoreStudents: true));

    emit(state.copyWith(students: [...state.students, ...students]));
  }

  Future<void> fetchGroups({int offset = 0, limit = 100}) async {
    if (state.noMoreGroups) return;
    final groups = await _scheduleRepo.getGroups(offset: offset, limit: limit);
    if (groups.isEmpty) return emit(state.copyWith(noMoreGroups: true));
    emit(state.copyWith(groups: [...state.groups, ...groups]));
  }

  Future<void> createOrUpdateStudent(Student student) async {
    final id = await _scheduleRepo.createOrUpdateStudent(student);
    final studentWithId = Student(
      id: id,
      name: student.name,
      contact: student.contact,
      pricing: student.pricing,
      note: student.note,
      iconPath: student.iconPath,
      group: student.group,
    );
    final studentExists = student.id != null;

    if (studentExists) {
      final studentIndex = state.students.indexWhere((s) => s.id == student.id);
      final stateStudents = [...state.students];
      stateStudents[studentIndex] = studentWithId;
      return emit(state.copyWith(students: stateStudents));
    }

    emit(state.copyWith(students: [...state.students, studentWithId]));
  }

  Future<void> deleteStudent(int studentId) async {
    await _scheduleRepo.deleteStudent(studentId);
    final updatedStudents = state.students.where((s) => s.id != studentId);
    emit(state.copyWith(students: updatedStudents.toList()));
  }

  Future<void> createOrUpdateGroup(Group group) async {
    final id = await _scheduleRepo.createOrUpdateGroup(group);
    final studentIds = group.students
        .where((s) => s.id != null)
        .map((s) => s.id!)
        .toList();
    await _scheduleRepo.syncGroupMemberships(id, studentIds);

    final groupWithId = Group(
      id: id,
      name: group.name,
      pricing: group.pricing,
      iconPath: group.iconPath,
      students: group.students,
    );

    final groupExists = group.id != null;
    if (groupExists) {
      final groupIndex = state.groups.indexWhere((g) => g.id == group.id);
      final stateGroups = [...state.groups];
      stateGroups[groupIndex] = groupWithId;
      return emit(state.copyWith(groups: stateGroups));
    }

    emit(state.copyWith(groups: [...state.groups, groupWithId]));
  }

  Future<void> deleteGroup(int groupId) async {
    await _scheduleRepo.deleteGroup(groupId);
    final updatedGroups = state.groups.where((g) => g.id != groupId).toList();
    emit(state.copyWith(groups: updatedGroups));
  }

  Future<Set<Student>> fetchGroupMembers(int groupId) {
    return _scheduleRepo.getGroupMembers(groupId);
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setFilterGroup(int? groupId) {
    emit(state.copyWith(filterGroupId: () => groupId));
  }
}
