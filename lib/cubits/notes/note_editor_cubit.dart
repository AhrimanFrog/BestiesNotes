import 'dart:async';

import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/markdown_lite.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/notes_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'note_editor_state.dart';

/// One note: read mode (with tickable checkboxes) and an edit mode that
/// saves by itself shortly after typing stops, and on leaving.
class NoteEditorCubit extends Cubit<NoteEditorState> {
  final NotesProvider _notes;
  final DataProvider _data;
  final Duration autosaveDelay;
  Timer? _autosave;
  Future<void>? _saving;

  NoteEditorCubit(
    this._notes,
    this._data, {
    this.autosaveDelay = const Duration(milliseconds: 800),
  }) : super(const NoteEditorState());

  Future<void> load(int noteId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final note = await _notes.getNote(noteId);
      emit(state.copyWith(note: note, saved: () => note, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// A new note, already linked to a student or lesson when given. Opens in
  /// edit mode; nothing is stored until it has some text.
  Future<void> startNew({int? studentId, int? lessonId}) async {
    emit(
      state.copyWith(
        note: Note(studentId: studentId, lessonId: lessonId),
        isEditing: true,
      ),
    );
    try {
      // Names for the link chip.
      final student = studentId != null
          ? await _data.getStudent(studentId)
          : null;
      final lesson = lessonId != null ? await _data.getLesson(lessonId) : null;
      // Typing may have started meanwhile; keep it.
      emit(
        state.copyWith(
          note: state.note.copyWith(
            studentName: () => student?.name,
            lessonName: () => lesson?.name,
            lessonStart: () => lesson?.start,
          ),
        ),
      );
    } catch (_) {
      // Only the chip's label is missing; the link itself is set.
    }
  }

  void startEditing() => emit(state.copyWith(isEditing: true));

  void updateTitle(String title) => _change(state.note.copyWith(title: title));

  void updateBody(String body) => _change(state.note.copyWith(body: body));

  /// Saves what's pending and returns to read mode.
  Future<void> finishEditing() async {
    await flush();
    emit(state.copyWith(isEditing: false));
  }

  /// Ticks a checkbox in read mode; saved at once.
  Future<void> toggleCheckbox(int line) async {
    _change(
      state.note.copyWith(
        body: MarkdownLite.toggleCheckbox(state.note.body, line),
      ),
      immediately: true,
    );
    await flush();
  }

  Future<void> togglePin() async {
    final pinned = !state.note.isPinned;
    _change(state.note.copyWith(isPinned: pinned), immediately: true);
    await flush();
  }

  /// Links the note to [student], or unlinks it with null.
  Future<void> linkStudent(Student? student) async {
    _change(
      state.note.copyWith(
        studentId: () => student?.id,
        studentName: () => student?.name,
      ),
      immediately: true,
    );
    await flush();
  }

  Future<void> unlinkLesson() async {
    _change(state.note.copyWith(lessonId: () => null), immediately: true);
    await flush();
  }

  Future<void> delete() async {
    _autosave?.cancel();
    final id = state.note.id;
    try {
      if (id != null) await _notes.deleteNote(id);
      emit(state.copyWith(isDeleted: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Saves pending changes now. Safe to call repeatedly; a blank new note
  /// is never stored.
  Future<void> flush() async {
    _autosave?.cancel();
    // One save at a time; a change made meanwhile is saved right after.
    while (_saving != null) {
      await _saving;
    }
    if (!state.isDirty || isClosed) return;
    if (state.note.id == null && state.note.isBlank) return;

    final note = state.note;
    final saving = _save(note);
    _saving = saving;
    await saving;
    _saving = null;
    if (state.isDirty) await flush();
  }

  Future<void> _save(Note note) async {
    try {
      final id = await _notes.saveNote(note);
      if (isClosed) return;
      final saved = note.copyWith(id: id, updatedAt: DateTime.now());
      // Keep edits typed while saving, with the id from this save.
      emit(
        state.copyWith(
          note: state.note.copyWith(id: id),
          saved: () => saved,
          saveFailed: false,
        ),
      );
    } catch (e) {
      if (!isClosed) emit(state.copyWith(saveFailed: true));
    }
  }

  void _change(Note note, {bool immediately = false}) {
    emit(state.copyWith(note: note));
    _autosave?.cancel();
    if (!immediately) _autosave = Timer(autosaveDelay, flush);
  }

  @override
  Future<void> close() async {
    // Leaving the screen never loses typing.
    await flush();
    return super.close();
  }
}
