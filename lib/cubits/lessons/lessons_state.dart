part of 'lessons_cubit.dart';

class LessonsState extends Equatable {
  final List<Lesson> lessons;
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool isLoading;
  final String? error;

  LessonsState({
    this.lessons = const [],
    DateTime? dateFrom,
    DateTime? dateTo,
    this.isLoading = false,
    this.error,
  }) : dateFrom = dateFrom ?? defaultDateFrom(),
       dateTo = dateTo ?? defaultDateTo();

  static DateTime defaultDateFrom() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime defaultDateTo() {
    return defaultDateFrom().add(const Duration(days: 7));
  }

  @override
  List<Object?> get props => [lessons, dateFrom, dateTo, isLoading, error];

  Map<DateTime, List<Lesson>> getLessonsByDate() {
    Map<DateTime, List<Lesson>> lessonsMap = {};
    for (final lesson in lessons) {
      final start = lesson.start;
      final lessonDay = DateTime(start.year, start.month, start.day);
      lessonsMap.putIfAbsent(lessonDay, () => []).add(lesson);
    }
    return lessonsMap;
  }

  LessonsState copyWith({
    List<Lesson>? lessons,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? isLoading,
    String? Function()? error,
  }) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}
