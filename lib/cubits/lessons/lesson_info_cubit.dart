import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_info_state.dart';

/// Drives the lesson detail screen: viewing a lesson, toggling participant
/// statuses, and editing it through a [LessonDraft].
class LessonInfoCubit extends Cubit<LessonInfoState> {
  final DataProvider _provider;

  LessonInfoCubit(this._provider) : super(const LessonInfoState());

  Future<void> load(int lessonId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final lesson = await _provider.getLesson(lessonId);
      emit(state.copyWith(lesson: lesson, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Opens an empty draft for a new lesson on [date].
  void startNew({DateTime? date, int durationMinutes = 60}) {
    final draft = LessonDraft.blank(
      date: date,
      durationMinutes: durationMinutes,
    );
    emit(LessonInfoState(draft: draft, initialDraft: draft));
  }

  // ---------------------------------------------------------------------------
  // Editing
  // ---------------------------------------------------------------------------

  void startEditing() {
    final lesson = state.lesson;
    if (lesson == null || state.isEditing) return;
    final draft = LessonDraft.fromLesson(lesson);
    emit(state.copyWith(draft: () => draft, initialDraft: () => draft));
  }

  void updateDraft({
    String? topic,
    DateTime? start,
    int? durationMinutes,
    List<Teachable>? subjects,
  }) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: () => draft.copyWith(
          topic: topic,
          start: start,
          durationMinutes: durationMinutes,
          subjects: subjects,
        ),
      ),
    );
  }

  /// Leaves edit mode without saving. For a new lesson there's nothing to go
  /// back to; the screen closes instead.
  void discardChanges() {
    emit(state.copyWith(draft: () => null, initialDraft: () => null));
  }

  /// Saves the draft. Returns false (without saving) when it's incomplete or
  /// the write fails.
  Future<bool> save() async {
    final draft = state.draft;
    if (draft == null || !draft.isValid || state.isSaving) return false;

    emit(state.copyWith(isSaving: true));
    try {
      final id = await _provider.createOrUpdateLesson(
        draft.toLesson(base: state.lesson),
      );
      await _provider.syncLessonMembership(id, draft.subjects);
      final saved = await _provider.getLesson(id);
      emit(LessonInfoState(lesson: saved));
      return true;
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Lesson actions (view mode)
  // ---------------------------------------------------------------------------

  Future<void> setCancelled(bool isCancelled) async {
    final lesson = state.lesson;
    if (lesson?.id == null) return;
    emit(state.copyWith(lesson: lesson!.copyWith(isCancelled: isCancelled)));
    try {
      await _provider.updateCancellation(lesson.id!, isCancelled);
    } catch (e) {
      emit(state.copyWith(lesson: lesson, error: e.toString()));
    }
  }

  Future<void> delete() async {
    final id = state.lesson?.id;
    if (id == null) return;
    try {
      await _provider.deleteLesson(id);
      emit(state.copyWith(isDeleted: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Participant statuses — optimistic, so toggles respond instantly
  // ---------------------------------------------------------------------------

  Future<void> updateParticipantStatus(
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) {
    final lessonId = state.lesson?.id;
    if (lessonId == null) return Future.value();
    return _optimistically(
      (p) => p.student.id == studentId,
      attended: attended,
      isPaid: isPaid,
      homeworkDone: homeworkDone,
      persist: () => _provider.updateParticipantStatus(
        lessonId,
        studentId,
        attended: attended,
        isPaid: isPaid,
        homeworkDone: homeworkDone,
      ),
    );
  }

  Future<void> markAll({bool? attended, bool? isPaid}) {
    final lessonId = state.lesson?.id;
    if (lessonId == null) return Future.value();
    return _optimistically(
      (_) => true,
      attended: attended,
      isPaid: isPaid,
      persist: () => _provider.updateAllParticipantStatuses(
        lessonId,
        attended: attended,
        isPaid: isPaid,
      ),
    );
  }

  Future<void> _optimistically(
    bool Function(LessonParticipant) matches, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
    required Future<void> Function() persist,
  }) async {
    final before = state.lesson!;
    emit(
      state.copyWith(
        lesson: before.copyWith(
          participants: [
            for (final p in before.participants)
              matches(p)
                  ? p.copyWith(
                      attended: attended,
                      isPaid: isPaid,
                      homeworkDone: homeworkDone,
                    )
                  : p,
          ],
        ),
      ),
    );
    try {
      await persist();
    } catch (e) {
      emit(state.copyWith(lesson: before, error: e.toString()));
    }
  }
}
