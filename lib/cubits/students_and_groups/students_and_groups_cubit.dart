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
    await _scheduleRepo.createOrUpdateStudent(student);
    final studentExists = student.id != null;
    if (studentExists) {
      final studentIndex = state.students.indexWhere((s) => s.id == student.id);
      final stateStudents = [...state.students];
      stateStudents[studentIndex] = student;
      return emit(state.copyWith(students: stateStudents));
    }

    emit(state.copyWith(students: [...state.students, student]));
  }

  Future<void> deleteStudent(int studentId) async {
    await _scheduleRepo.deleteStudent(studentId);
    final updatedStudents = state.students.where((s) => s.id != studentId);
    emit(state.copyWith(students: updatedStudents.toList()));
  }
}
