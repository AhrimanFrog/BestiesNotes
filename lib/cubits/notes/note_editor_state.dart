part of 'note_editor_cubit.dart';

class NoteEditorState extends Equatable implements CubitState {
  /// The note as on screen, including unsaved typing.
  final Note note;

  /// The note as last stored; null until the first save.
  final Note? saved;
  final bool isEditing;
  final bool saveFailed;
  final bool isDeleted;
  @override
  final bool isLoading;
  @override
  final String? error;

  const NoteEditorState({
    this.note = const Note(),
    this.saved,
    this.isEditing = false,
    this.saveFailed = false,
    this.isDeleted = false,
    this.isLoading = false,
    this.error,
  });

  /// Whether the screen shows something not yet stored. `updatedAt` is set
  /// by the store, so it doesn't count.
  bool get isDirty {
    final saved = this.saved;
    if (saved == null) return !note.isBlank || note.isPinned;
    return note.title != saved.title ||
        note.body != saved.body ||
        note.isPinned != saved.isPinned ||
        note.studentId != saved.studentId ||
        note.lessonId != saved.lessonId;
  }

  NoteEditorState copyWith({
    Note? note,
    Note? Function()? saved,
    bool? isEditing,
    bool? saveFailed,
    bool? isDeleted,
    bool? isLoading,
    String? error,
  }) {
    return NoteEditorState(
      note: note ?? this.note,
      saved: saved != null ? saved() : this.saved,
      isEditing: isEditing ?? this.isEditing,
      saveFailed: saveFailed ?? this.saveFailed,
      isDeleted: isDeleted ?? this.isDeleted,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    note,
    saved,
    isEditing,
    saveFailed,
    isDeleted,
    isLoading,
    error,
  ];

  @override
  bool get isEmpty => false;
}
