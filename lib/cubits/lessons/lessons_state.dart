part of 'lessons_cubit.dart';

class LessonsState extends Equatable implements CubitState {
  final List<Lesson> lessons;
  final CalendarView view;

  /// The day the calendar is centred on; the selected day in month view.
  final DateTime anchor;

  /// [DateTime.monday]..[DateTime.sunday].
  final int weekStart;

  @override
  final bool isLoading;
  @override
  final String? error;

  LessonsState({
    this.lessons = const [],
    this.view = CalendarView.week,
    DateTime? anchor,
    this.weekStart = DateTime.monday,
    this.isLoading = false,
    this.error,
  }) : anchor = (anchor ?? DateTime.now()).dateOnly;

  ({DateTime from, DateTime to}) get _range =>
      CalendarPeriod.range(view, anchor, weekStart);

  /// Where a new lesson goes by default: the selected day in month view,
  /// otherwise today when visible, else the first day shown.
  DateTime get defaultNewLessonDay {
    if (view == CalendarView.month) return anchor;
    return showsToday ? DateTime.now().dateOnly : dateFrom;
  }

  /// First day shown (inclusive).
  DateTime get dateFrom => _range.from;

  /// Day after the last one shown (exclusive).
  DateTime get dateTo => _range.to;

  List<DateTime> get days => [
    for (var d = dateFrom; d.isBefore(dateTo); d = d.addDays(1)) d,
  ];

  bool get showsToday {
    final today = DateTime.now().dateOnly;
    // In month view only the days of the anchor's own month count.
    if (view == CalendarView.month) {
      return today.year == anchor.year && today.month == anchor.month;
    }
    return !today.isBefore(dateFrom) && today.isBefore(dateTo);
  }

  String get periodLabel => CalendarPeriod.label(view, anchor, weekStart);

  List<Lesson> lessonsOn(DateTime day) =>
      lessons.where((l) => l.start.isSameDay(day)).toList();

  /// The lesson happening now, or the next one to start, if it's in view.
  Lesson? get featuredLesson {
    final now = DateTime.now();
    for (final lesson in lessons) {
      if (!lesson.isCancelled && lesson.end.isAfter(now)) return lesson;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    lessons,
    view,
    anchor,
    weekStart,
    isLoading,
    error,
  ];

  @override
  bool get isEmpty => lessons.isEmpty;

  Map<DateTime, List<Lesson>> getLessonsByDate() {
    final Map<DateTime, List<Lesson>> lessonsMap = {};
    for (final lesson in lessons) {
      lessonsMap.putIfAbsent(lesson.start.dateOnly, () => []).add(lesson);
    }
    return lessonsMap;
  }

  LessonsState copyWith({
    List<Lesson>? lessons,
    CalendarView? view,
    DateTime? anchor,
    int? weekStart,
    bool? isLoading,
    String? error,
  }) {
    return LessonsState(
      lessons: lessons ?? this.lessons,
      view: view ?? this.view,
      anchor: anchor ?? this.anchor,
      weekStart: weekStart ?? this.weekStart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
