import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/calendar_period.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:besties_notes/data/calendar_period.dart' show CalendarView;

part 'lessons_state.dart';

/// Lessons for the schedule (a week or month around an anchor day), or for
/// one student's / group's history.
class LessonsCubit extends Cubit<LessonsState> {
  final DataProvider _provider;

  LessonsCubit(this._provider, {int weekStart = DateTime.monday})
    : super(LessonsState(weekStart: weekStart));

  /// Re-runs the last query, e.g. after a lesson was edited elsewhere.
  Future<void> Function()? _lastQuery;

  Future<void> refresh() => _lastQuery?.call() ?? Future.value();

  /// Loads the lessons of the period currently in view.
  Future<void> fetchLessons() async {
    // Reads the range from state, so a refresh follows navigation.
    _lastQuery = fetchLessons;
    final (from, to) = (state.dateFrom, state.dateTo);
    await _fetchLessons(() => _provider.getLessonsForRange(from, to));
  }

  Future<void> fetchLessonsByStudentId(
    int studID, {
    int offset = 0,
    int limit = 100,
  }) async {
    _lastQuery = () =>
        fetchLessonsByStudentId(studID, offset: offset, limit: limit);
    await _fetchLessons(
      () =>
          _provider.getLessonsForStudent(studID, offset: offset, limit: limit),
    );
  }

  Future<void> fetchLessonsByGroupId(
    int groupId, {
    int offset = 0,
    int limit = 100,
  }) async {
    _lastQuery = () =>
        fetchLessonsByGroupId(groupId, offset: offset, limit: limit);
    await _fetchLessons(
      () => _provider.getLessonsForGroup(groupId, offset: offset, limit: limit),
    );
  }

  Future<void> _fetchLessons(Future<List<Lesson>> Function() fetch) async {
    emit(state.copyWith(isLoading: true));
    try {
      emit(state.copyWith(lessons: await fetch(), isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Calendar navigation
  // ---------------------------------------------------------------------------

  Future<void> setView(CalendarView view) {
    if (view == state.view) return Future.value();
    emit(state.copyWith(view: view));
    return fetchLessons();
  }

  Future<void> goToPrevious() =>
      jumpTo(CalendarPeriod.shift(state.view, state.anchor, -1));

  Future<void> goToNext() =>
      jumpTo(CalendarPeriod.shift(state.view, state.anchor, 1));

  Future<void> goToToday() => jumpTo(DateTime.now());

  /// Applies a changed week-start setting to the calendar.
  Future<void> setWeekStart(int weekStart) {
    if (weekStart == state.weekStart) return Future.value();
    emit(state.copyWith(weekStart: weekStart));
    return fetchLessons();
  }

  Future<void> jumpTo(DateTime day) {
    emit(state.copyWith(anchor: day.dateOnly));
    return fetchLessons();
  }

  /// Selects a day in month view. A day from a neighbouring month (the grid's
  /// leading/trailing days) moves the grid to that month.
  Future<void> selectDay(DateTime day) {
    final sameMonth =
        day.year == state.anchor.year && day.month == state.anchor.month;
    if (state.view == CalendarView.month && !sameMonth) return jumpTo(day);
    emit(state.copyWith(anchor: day.dateOnly));
    return Future.value();
  }
}
