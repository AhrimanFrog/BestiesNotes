part of 'lessons_cubit.dart';

class LessonsState extends Equatable {
  final List<Lesson> lessons;
  final bool noMoreLessons;

  const LessonsState({this.lessons = const [], this.noMoreLessons = false});

  @override
  List<Object?> get props => [lessons, noMoreLessons];

  LessonsState copyWith({List<Lesson>? lessons, bool? noMoreLessons}) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      noMoreLessons: noMoreLessons ?? this.noMoreLessons,
    );
  }
}
