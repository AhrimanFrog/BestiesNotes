import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final ScheduleRepo _scheduleRepo;

  LessonsCubit(this._scheduleRepo) : super(LessonsState());

  Future<void> fetchLessons() async {
    if (state.noMoreLessons) return;
    final lessons = await _scheduleRepo.getLessonsForAWeek();
    if (lessons.isEmpty) return emit(state.copyWith(noMoreLessons: true));

    emit(state.copyWith(lessons: [...state.lessons, ...lessons]));
  }

  Future<void> createOrUpdateLesson(Lesson lesson) async {
    final id = await _scheduleRepo.createOrUpdateLesson(lesson);
    final lessonExists = lesson.id != null;

    final lessonWithId = Lesson(
      id: id,
      name: lesson.name,
      subjects: lesson.subjects,
      start: lesson.start,
      duration: lesson.duration,
      note: lesson.note,
      status: lesson.status,
    );

    if (lessonExists) {
      final lessonIndex = state.lessons.indexWhere((s) => s.id == lesson.id);
      final stateLessons = [...state.lessons];
      stateLessons[lessonIndex] = lessonWithId;
      return emit(state.copyWith(lessons: stateLessons));
    }

    emit(state.copyWith(lessons: [...state.lessons, lessonWithId]));
  }

  Future<void> cancelLesson(int lessonId) async {
    await _scheduleRepo.cancelLesson(lessonId);
    final lessonIndex = state.lessons.indexWhere((s) => s.id == lessonId);
    if (lessonIndex == -1) return;

    final stateLessons = [...state.lessons];
    final lesson = stateLessons[lessonIndex];
    stateLessons[lessonIndex] = Lesson(
      id: lesson.id,
      name: lesson.name,
      subjects: lesson.subjects,
      start: lesson.start,
      duration: lesson.duration,
      note: lesson.note,
      status: LessonStatus.cancelled,
    );
    emit(state.copyWith(lessons: stateLessons));
  }

  Future<void> deleteLesson(int lessonId) async {
    await _scheduleRepo.removeLesson(lessonId);
    final updatedLessons = state.lessons.where((s) => s.id != lessonId);
    emit(state.copyWith(lessons: updatedLessons.toList()));
  }
}
