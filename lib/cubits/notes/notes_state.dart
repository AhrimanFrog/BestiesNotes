part of 'notes_cubit.dart';

enum NoteFilter { all, general, students, lessons }

class NotesState extends Equatable implements CubitState {
  /// Most recently changed first, as loaded.
  final List<Note> notes;
  final String query;
  final NoteFilter filter;
  @override
  final bool isLoading;
  @override
  final String? error;

  const NotesState({
    this.notes = const [],
    this.query = '',
    this.filter = NoteFilter.all,
    this.isLoading = false,
    this.error,
  });

  /// Filtered and searched, pinned first.
  List<Note> get visible {
    final q = query.trim().toLowerCase();
    bool matches(Note n) =>
        q.isEmpty ||
        [
          n.title,
          n.body,
          n.studentName ?? '',
          n.lessonName ?? '',
        ].any((s) => s.toLowerCase().contains(q));
    bool inFilter(Note n) => switch (filter) {
      NoteFilter.all => true,
      NoteFilter.general => !n.isLinked,
      NoteFilter.students => n.studentId != null,
      NoteFilter.lessons => n.lessonId != null,
    };
    final shown = notes.where((n) => inFilter(n) && matches(n));
    return [
      ...shown.where((n) => n.isPinned),
      ...shown.where((n) => !n.isPinned),
    ];
  }

  NotesState copyWith({
    List<Note>? notes,
    String? query,
    NoteFilter? filter,
    bool? isLoading,
    String? error,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [notes, query, filter, isLoading, error];

  @override
  bool get isEmpty => notes.isEmpty;
}
