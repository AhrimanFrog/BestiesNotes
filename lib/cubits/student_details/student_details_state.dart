part of 'student_details_cubit.dart';

class StudentDetailsState extends Equatable {
  final List<Lesson> lessons;
  final bool isLoading;
  final String? error;

  const StudentDetailsState({
    this.lessons = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [lessons, isLoading, error];
}
