part of 'group_details_cubit.dart';

class GroupDetailsState extends Equatable implements CubitState {
  final Group group;
  final List<Lesson> lessons;
  @override
  final bool isLoading;
  @override
  final String? error;

  const GroupDetailsState({
    this.group = const Group.demo(),
    this.lessons = const [],
    this.isLoading = false,
    this.error,
  });

  GroupDetailsState copyWith({
    Group? group,
    List<Lesson>? lessons,
    bool? isLoading,
    String? error,
  }) {
    return GroupDetailsState(
      group: group ?? this.group,
      lessons: lessons ?? this.lessons,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [group, lessons, isLoading, error];

  @override
  bool get isEmpty => lessons.isEmpty;
}
