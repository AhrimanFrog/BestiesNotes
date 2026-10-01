part of 'lessons_cubit.dart';

class LessonsState extends Equatable implements CubitState {
  final List<Lesson> lessons;
  final DateTime dateFrom;
  final DateTime dateTo;
  @override
  final bool isLoading;
  @override
  final String? error;

  LessonsState({
    this.lessons = const [],
    DateTime? dateFrom,
    DateTime? dateTo,
    this.isLoading = false,
    this.error,
  }) : dateFrom = dateFrom ?? defaultDateFrom(),
       dateTo = dateTo ?? defaultDateTo();

  /// Start of the current week. Monday until week start becomes a setting.
  static DateTime defaultDateFrom() =>
      DateTime.now().startOfWeek(DateTime.monday);

  /// Exclusive end of the current week.
  static DateTime defaultDateTo() => defaultDateFrom().addDays(7);

  @override
  List<Object?> get props => [lessons, dateFrom, dateTo, isLoading, error];

  @override
  bool get isEmpty => lessons.isEmpty;

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
    String? error,
  }) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
