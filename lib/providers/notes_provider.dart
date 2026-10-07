import 'package:besties_notes/data/ui_models/index.dart';

abstract class NotesProvider {
  /// Notes, most recently changed first. Narrowed to one student's or one
  /// lesson's notes when given.
  Future<List<Note>> getNotes({int? studentId, int? lessonId});

  Future<Note> getNote(int noteId);

  /// Inserts or updates [note]; returns its id.
  Future<int> saveNote(Note note);

  Future<void> setNotePinned(int noteId, bool isPinned);

  Future<void> deleteNote(int noteId);
}
