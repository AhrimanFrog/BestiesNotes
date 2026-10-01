part of 'student_details_cubit.dart';

class StudentDetailsState extends Equatable implements CubitState {
  /// The saved student; null while loading or when creating a new one.
  final Student? student;
  final List<Lesson> lessons;
  final List<Lesson> unpaidLessons;
  final int paidThisMonth;
  final int totalThisMonth;

  /// The edit in progress; null in view mode.
  final StudentDraft? draft;
  final StudentDraft? initialDraft;

  @override
  final bool isLoading;
  final bool isSaving;
  final bool isDeleted;
  @override
  final String? error;

  const StudentDetailsState({
    this.student,
    this.lessons = const [],
    this.unpaidLessons = const [],
    this.paidThisMonth = 0,
    this.totalThisMonth = 0,
    this.draft,
    this.initialDraft,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleted = false,
    this.error,
  });

  bool get isEditing => draft != null;
  bool get isNew => isEditing && student == null;
  bool get isDirty => isEditing && draft != initialDraft;

  double get amountOwed =>
      student?.pricing.calculateOwed(unpaidLessons.map((l) => l.start)) ?? 0;

  @override
  bool get isEmpty => student == null && draft == null;

  @override
  List<Object?> get props => [
    student,
    lessons,
    unpaidLessons,
    paidThisMonth,
    totalThisMonth,
    draft,
    initialDraft,
    isLoading,
    isSaving,
    isDeleted,
    error,
  ];

  StudentDetailsState copyWith({
    Student? student,
    List<Lesson>? lessons,
    List<Lesson>? unpaidLessons,
    int? paidThisMonth,
    int? totalThisMonth,
    StudentDraft? Function()? draft,
    StudentDraft? Function()? initialDraft,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleted,
    String? error,
  }) {
    return StudentDetailsState(
      student: student ?? this.student,
      lessons: lessons ?? this.lessons,
      unpaidLessons: unpaidLessons ?? this.unpaidLessons,
      paidThisMonth: paidThisMonth ?? this.paidThisMonth,
      totalThisMonth: totalThisMonth ?? this.totalThisMonth,
      draft: draft != null ? draft() : this.draft,
      initialDraft: initialDraft != null ? initialDraft() : this.initialDraft,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleted: isDeleted ?? this.isDeleted,
      error: error,
    );
  }
}
