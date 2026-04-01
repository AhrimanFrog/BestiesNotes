import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final ScheduleRepo _scheduleRepo;

  LessonsCubit(this._scheduleRepo) : super(LessonsState());

  Future<void> fetchLessons({DateTime? from, DateTime? to}) async {
    final dateFrom = from ?? state.dateFrom;
    final dateTo = to ?? state.dateTo;
    await _fetchLessons(
      () async => await _scheduleRepo.getLessonsForRange(dateFrom, dateTo),
      dateFrom: from,
      dateTo: to,
    );
  }

  Future<void> fetchLessonsByStudentId(
    int studID, {
    int offset = 0,
    int limit = 100,
  }) async {
    _fetchLessons(
      () async => _scheduleRepo.getLessonsForStudent(
        studID,
        offset: offset,
        limit: limit,
      ),
    );
  }

  Future<void> fetchLessonsByGroupId(
    int groupId, {
    int offset = 0,
    int limit = 100,
  }) async {
    _fetchLessons(
      () async => _scheduleRepo.getLessonsForGroup(
        groupId,
        offset: offset,
        limit: limit,
      ),
    );
  }

  Future<void> _fetchLessons(
    Future<List<Lesson>> Function() fetch, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    emit(state.copyWith(isLoading: true, error: () => null));
    try {
      emit(
        state.copyWith(
          lessons: await fetch(),
          dateFrom: dateFrom,
          dateTo: dateTo,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => e.toString()));
    }
  }

  Future<void> goToPreviousWeek() => fetchLessons(
    from: state.dateFrom.subtract(const Duration(days: 7)),
    to: state.dateTo.subtract(const Duration(days: 7)),
  );

  Future<void> goToNextWeek() => fetchLessons(
    from: state.dateFrom.add(const Duration(days: 7)),
    to: state.dateTo.add(const Duration(days: 7)),
  );

  Future<void> goToCurrentWeek() => fetchLessons(
    from: LessonsState.defaultDateFrom(),
    to: LessonsState.defaultDateTo(),
  );

  Future<void> createOrUpdateLesson(Lesson lesson) async {
    await _scheduleRepo.createOrUpdateLesson(lesson);
    await fetchLessons();
  }

  Future<void> cancelLesson(int lessonId) async {
    await _scheduleRepo.cancelLesson(lessonId);
    await fetchLessons();
  }

  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) async {
    final previousLessons = state.lessons;

    // Optimistic update so the dot responds instantly
    final updatedLessons = state.lessons.map((lesson) {
      if (lesson.id != lessonId) return lesson;
      final updatedParticipants = lesson.participants.map((p) {
        return (p.student.id != studentId)
            ? p
            : p.copyWith(
                attended: attended,
                isPaid: isPaid,
                homeworkDone: homeworkDone,
              );
      }).toList();
      return lesson.copyWith(participants: updatedParticipants);
    }).toList();
    emit(state.copyWith(lessons: updatedLessons));

    try {
      await _scheduleRepo.updateParticipantStatus(
        lessonId,
        studentId,
        attended: attended,
        isPaid: isPaid,
        homeworkDone: homeworkDone,
      );
    } catch (e) {
      emit(state.copyWith(lessons: previousLessons, error: () => e.toString()));
    }
  }
}
