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
    if (groups.isEmpty) {
      return emit(state.copyWith(noMoreGroups: true));
    }

    final stateGroups = state.groups;
    stateGroups.addAll(groups);

    emit(state.copyWith(groups: stateGroups));
  }

  Future<void> createStudent(Student student) async {
    await _scheduleRepo.createOrUpdateStudent(student);
    emit(state.copyWith(students: [...state.students, student]));
  }
}
