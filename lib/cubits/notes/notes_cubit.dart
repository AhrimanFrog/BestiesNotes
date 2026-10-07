import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/notes_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'notes_state.dart';

/// A list of notes: every note on the Notes tab, or one student's or one
/// lesson's notes on their pages.
class NotesCubit extends Cubit<NotesState> {
  final NotesProvider _notes;
  final int? studentId;
  final int? lessonId;

  NotesCubit(this._notes, {this.studentId, this.lessonId})
    : super(const NotesState());

  /// With [quiet], the list stays on screen instead of a spinner (refreshing
  /// after an edit elsewhere).
  Future<void> load({bool quiet = false}) async {
    if (!quiet) emit(state.copyWith(isLoading: true));
    try {
      final notes = await _notes.getNotes(
        studentId: studentId,
        lessonId: lessonId,
      );
      emit(state.copyWith(notes: notes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setFilter(NoteFilter filter) => emit(state.copyWith(filter: filter));

  /// Shown at once; reverted if saving fails.
  Future<void> togglePin(Note note) async {
    final pinned = !note.isPinned;
    List<Note> withPin(bool value) => [
      for (final n in state.notes)
        n.id == note.id ? n.copyWith(isPinned: value) : n,
    ];
    emit(state.copyWith(notes: withPin(pinned)));
    try {
      await _notes.setNotePinned(note.id!, pinned);
    } catch (e) {
      emit(state.copyWith(notes: withPin(!pinned), error: e.toString()));
    }
  }
}
