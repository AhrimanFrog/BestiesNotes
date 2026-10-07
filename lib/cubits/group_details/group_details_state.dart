part of 'group_details_cubit.dart';

class GroupDetailsState extends Equatable implements CubitState {
  /// The saved group (with its members); null while loading or when
  /// creating a new one.
  final Group? group;
  final List<Lesson> lessons;
  final List<Lesson> unpaidLessons;

  /// What the members owe for the group's lessons, across all time.
  final double amountOwed;

  /// The edit in progress; null in view mode.
  final GroupDraft? draft;
  final GroupDraft? initialDraft;

  @override
  final bool isLoading;
  final bool isSaving;
  final bool isDeleted;
  @override
  final String? error;

  const GroupDetailsState({
    this.group,
    this.lessons = const [],
    this.unpaidLessons = const [],
    this.amountOwed = 0,
    this.draft,
    this.initialDraft,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.error,
  });

  bool get isEditing => draft != null;
  bool get isNew => isEditing && group == null;
  bool get isDirty => isEditing && draft != initialDraft;

  @override
  bool get isEmpty => group == null && draft == null;

  @override
  List<Object?> get props => [
    group,
    lessons,
    unpaidLessons,
    amountOwed,
    draft,
    initialDraft,
    isLoading,
    isSaving,
    isDeleted,
    error,
  ];

  GroupDetailsState copyWith({
    Group? group,
    List<Lesson>? lessons,
    List<Lesson>? unpaidLessons,
    double? amountOwed,
    GroupDraft? Function()? draft,
    GroupDraft? Function()? initialDraft,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? error,
  }) {
    return GroupDetailsState(
      group: group ?? this.group,
      lessons: lessons ?? this.lessons,
      unpaidLessons: unpaidLessons ?? this.unpaidLessons,
      amountOwed: amountOwed ?? this.amountOwed,
      draft: draft != null ? draft() : this.draft,
      initialDraft: initialDraft != null ? initialDraft() : this.initialDraft,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      error: error,
    );
  }
}
