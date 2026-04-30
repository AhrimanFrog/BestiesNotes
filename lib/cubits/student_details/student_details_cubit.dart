import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'student_details_state.dart';

class StudentDetailsCubit extends Cubit<StudentDetailsState> {
  final DataProvider _provider;

  StudentDetailsCubit(this._provider) : super(const StudentDetailsState());

  Future<void> load(int studentId) async {
    emit(const StudentDetailsState(isLoading: true));
    try {
      final (lessons, student) = await (
        _provider.getLessonsForStudent(studentId),
        _provider.getStudent(studentId),
      ).wait;
      emit(
        state.copyWith(lessons: lessons, student: student, isLoading: false),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
