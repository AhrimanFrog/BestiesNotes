import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'students_and_groups_state.dart';

class StudentsAndGroupsCubit extends Cubit<StudentsAndGroupsState> {
  final ScheduleRepo _scheduleRepo;

  StudentsAndGroupsCubit(this._scheduleRepo) : super(StudentsAndGroupsState());

  Future<void> fetchStudents({int offset = 0, int limit = 100}) async {
    if (state.noMoreStudents) return;
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      final students = await _scheduleRepo.getStudents(
        offset: offset,
        limit: limit,
      );
      if (students.isEmpty) {
        return emit(state.copyWith(noMoreStudents: true, isLoading: false));
      }
      emit(state.copyWith(
        students: [...state.students, ...students],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> fetchGroups({int offset = 0, limit = 100}) async {
    if (state.noMoreGroups) return;
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      final groups = await _scheduleRepo.getGroups(
        offset: offset,
        limit: limit,
      );
      if (groups.isEmpty) {
        return emit(state.copyWith(noMoreGroups: true, isLoading: false));
      }
      emit(state.copyWith(
        groups: [...state.groups, ...groups],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> createOrUpdateStudent(Student student) async {
    final id = await _scheduleRepo.createOrUpdateStudent(student);
    final studentWithId = student.copyWith(id: id);

    final updatedStudents = student.id != null
        ? state.students
              .map((s) => s.id == student.id ? studentWithId : s)
              .toList()
        : [...state.students, studentWithId];

    emit(state.copyWith(students: updatedStudents));
  }

  Future<void> deleteStudent(int studentId) async {
    await _scheduleRepo.deleteStudent(studentId);
    final updatedStudents = state.students.where((s) => s.id != studentId);
    emit(state.copyWith(students: updatedStudents.toList()));
  }

  Future<void> createOrUpdateGroup(Group group) async {
    final id = await _scheduleRepo.createOrUpdateGroup(group);
    final newMemberIds = group.students
        .where((s) => s.id != null)
        .map((s) => s.id!);
    await _scheduleRepo.syncGroupMemberships(id, newMemberIds);

    final groupWithId = group.copyWith(id: id);

    // Reflect new memberships on the student objects already in state so that
    // group-based filtering works immediately without a refetch.
    final updatedStudents = state.students.map((s) {
      if (newMemberIds.contains(s.id)) {
        return s.copyWith(group: groupWithId);
      } else if (s.group?.id == id) {
        // Student was removed from this group.
        return Student(
          id: s.id,
          name: s.name,
          pricing: s.pricing,
          contact: s.contact,
          iconPath: s.iconPath,
          note: s.note,
        );
      }
      return s;
    }).toList();

    final updatedGroups = group.id != null
        ? state.groups.map((g) => g.id == group.id ? groupWithId : g).toList()
        : [...state.groups, groupWithId];

    emit(state.copyWith(groups: updatedGroups, students: updatedStudents));
  }

  Future<void> deleteGroup(int groupId) async {
    await _scheduleRepo.deleteGroup(groupId);
    final updatedGroups = state.groups.where((g) => g.id != groupId).toList();

    // Clear the group reference from students that belonged to the deleted group.
    final updatedStudents = state.students.map((s) {
      return (s.group?.id != groupId)
          ? s
          : Student(
              id: s.id,
              name: s.name,
              pricing: s.pricing,
              contact: s.contact,
              iconPath: s.iconPath,
              note: s.note,
            );
    }).toList();

    emit(
      state.copyWith(
        groups: updatedGroups,
        students: updatedStudents,
        // If the deleted group was the active filter, reset it so students appear.
        filterGroupId: state.filterGroupId == groupId ? () => null : null,
      ),
    );
  }

  Future<void> fetchGroupMembers(int groupId) async {
    final groupMembers = await _scheduleRepo.getGroupMembers(groupId);
    emit(state.copyWith(groupMembers: groupMembers));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setFilterGroup(int? groupId) {
    emit(state.copyWith(filterGroupId: () => groupId));
  }
}
