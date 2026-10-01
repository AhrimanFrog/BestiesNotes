part of 'lesson_info_cubit.dart';

class LessonInfoState extends Equatable implements CubitState {
  /// The saved lesson; null while loading or when creating a new one.
  final Lesson? lesson;

  /// The edit in progress; null in view mode.
  final LessonDraft? draft;

  /// What [draft] started as, to tell whether anything changed.
  final LessonDraft? initialDraft;

  @override
  final bool isLoading;
  final bool isSaving;

  /// Set once the lesson is deleted, so the screen can close.
  final bool isDeleted;

  @override
  final String? error;

  const LessonInfoState({
    this.lesson,
    this.draft,
    this.initialDraft,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.error,
  });

  bool get isEditing => draft != null;
  bool get isNew => isEditing && lesson == null;
  bool get isDirty => isEditing && draft != initialDraft;

  @override
  bool get isEmpty => lesson == null && draft == null;

  @override
  List<Object?> get props => [
    lesson,
    draft,
    initialDraft,
    isLoading,
    isSaving,
    isDeleted,
    error,
  ];

  /// [draft] and [initialDraft] take a nullable builder so they can be cleared.
  LessonInfoState copyWith({
    Lesson? lesson,
    LessonDraft? Function()? draft,
    LessonDraft? Function()? initialDraft,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? error,
  }) {
    return LessonInfoState(
      lesson: lesson ?? this.lesson,
      draft: draft != null ? draft() : this.draft,
      initialDraft: initialDraft != null ? initialDraft() : this.initialDraft,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      error: error,
    );
  }
}
