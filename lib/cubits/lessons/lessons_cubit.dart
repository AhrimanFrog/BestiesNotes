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
    final lessons = await _scheduleRepo.getLessonsForRange(dateFrom, dateTo);
    emit(state.copyWith(lessons: lessons, dateFrom: dateFrom, dateTo: dateTo));
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
}
