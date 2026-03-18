part of 'student_details_cubit.dart';

class StudentDetailsState extends Equatable implements CubitState {
  final Student student;
  final List<Lesson> lessons;
  @override
  final bool isLoading;
  @override
  final String? error;

  const StudentDetailsState({
    this.student = const .demo(),
    this.lessons = const [],
    this.isLoading = false,
    this.error,
  });

  StudentDetailsState copyWith({
    Student? student,
    List<Lesson>? lessons,
    bool? isLoading,
    String? error,
  }) {
    return StudentDetailsState(
      student: student ?? this.student,
      lessons: lessons ?? this.lessons,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [student, lessons, isLoading, error];

  @override
  bool get isEmpty => lessons.isEmpty;
}
