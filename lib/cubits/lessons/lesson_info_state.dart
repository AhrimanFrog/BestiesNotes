part of 'lesson_info_cubit.dart';

class LessonInfoState extends Equatable implements CubitState {
  final Lesson? lesson;
  @override
  final bool isLoading;
  @override
  final String? error;

  const LessonInfoState({this.lesson, this.isLoading = false, this.error});

  @override
  bool get isEmpty => lesson == null;

  @override
  List<Object?> get props => [lesson, isLoading, error];

  LessonInfoState copyWith({Lesson? lesson, bool? isLoading, String? error}) {
    return LessonInfoState(
      lesson: lesson ?? this.lesson,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
