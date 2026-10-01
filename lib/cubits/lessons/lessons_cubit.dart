import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final DataProvider _provider;

  LessonsCubit(this._provider) : super(LessonsState());

  /// Re-runs the last query, e.g. after a lesson was edited elsewhere.
  Future<void> Function()? _lastQuery;

  Future<void> refresh() => _lastQuery?.call() ?? Future.value();

  Future<void> fetchLessons({DateTime? from, DateTime? to}) async {
    // Re-fetching the range reads it from state, so it follows navigation.
    _lastQuery = fetchLessons;
    final dateFrom = from ?? state.dateFrom;
    final dateTo = to ?? state.dateTo;
    await _fetchLessons(
      () async => await _provider.getLessonsForRange(dateFrom, dateTo),
      dateFrom: from,
      dateTo: to,
    );
  }

  Future<void> fetchLessonsByStudentId(
    int studID, {
    int offset = 0,
    int limit = 100,
  }) async {
    _lastQuery = () =>
        fetchLessonsByStudentId(studID, offset: offset, limit: limit);
    await _fetchLessons(
      () async =>
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
      () async =>
          _provider.getLessonsForGroup(groupId, offset: offset, limit: limit),
    );
  }

  Future<void> _fetchLessons(
    Future<List<Lesson>> Function() fetch, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    emit(state.copyWith(isLoading: true));
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
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> goToPreviousWeek() => fetchLessons(
    from: state.dateFrom.addDays(-7),
    to: state.dateTo.addDays(-7),
  );

  Future<void> goToNextWeek() => fetchLessons(
    from: state.dateFrom.addDays(7),
    to: state.dateTo.addDays(7),
  );

  Future<void> goToCurrentWeek() => fetchLessons(
    from: LessonsState.defaultDateFrom(),
    to: LessonsState.defaultDateTo(),
  );
}
