part of 'lessons_cubit.dart';

class LessonsState extends Equatable {
  final List<Lesson> lessons;
  final bool noMoreLessons;

  const LessonsState({this.lessons = const [], this.noMoreLessons = false});

  @override
  List<Object?> get props => [lessons, noMoreLessons];

  Map<DateTime, List<Lesson>> getLessonsByDate() {
    Map<DateTime, List<Lesson>> lessonsMap = {};
    for (final lesson in lessons) {
      final start = lesson.start;
      final lessonDay = DateTime(start.year, start.month, start.day);
      lessonsMap.putIfAbsent(lessonDay, () => []).add(lesson);
    }
    return lessonsMap;
  }

  LessonsState copyWith({List<Lesson>? lessons, bool? noMoreLessons}) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      noMoreLessons: noMoreLessons ?? this.noMoreLessons,
    );
  }
}
