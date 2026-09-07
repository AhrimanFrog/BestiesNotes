import 'package:besties_notes/providers/data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:equatable/equatable.dart';

part 'lesson_info_state.dart';

class LessonInfoCubit extends Cubit<LessonInfoState> {
  final DataProvider _provider;

  LessonInfoCubit(this._provider) : super(LessonInfoState());

  Future<void> cancelLesson(int lessonId) async {
    await _provider.updateCancellation(lessonId, true);
  }

  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    if (state.isEmpty) return;
    final currentLesson = state.lesson;

    // Optimistic update so the dot responds instantly
    final updatedParticipants = state.lesson?.participants.map((p) {
      return (p.student.id != studentId)
          ? p
          : p.copyWith(
              attended: attended,
              isPaid: isPaid,
              homeworkDone: homeworkDone,
            );
    }).toList();
    final updatedLesson = state.lesson?.copyWith(
      participants: updatedParticipants,
    );
    emit(state.copyWith(lesson: updatedLesson));

    try {
      await _provider.updateParticipantStatus(
        lessonId,
        studentId,
        attended: attended,
        isPaid: isPaid,
        homeworkDone: homeworkDone,
      );
    } catch (e) {
      emit(state.copyWith(lesson: currentLesson, error: e.toString()));
    }
  }
}
