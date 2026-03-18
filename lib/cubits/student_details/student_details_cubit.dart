import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'student_details_state.dart';

class StudentDetailsCubit extends Cubit<StudentDetailsState> {
  final ScheduleRepo _repo;

  StudentDetailsCubit(this._repo) : super(const StudentDetailsState());

  Future<void> loadStudent(int studentId) async {
    emit(const StudentDetailsState(isLoading: true));
    try {
      final student = await _repo.getStudent(studentId);
      emit(state.copyWith(student: student));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadLessons(int studentId) async {
    emit(const StudentDetailsState(isLoading: true));
    try {
      final lessons = await _repo.getLessonsForStudent(studentId);
      emit(state.copyWith(lessons: lessons, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
