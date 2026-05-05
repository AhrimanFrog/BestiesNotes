part of 'recurring_cubit.dart';

class RecurringState extends Equatable {
  final List<RecurringTemplate> templates;
  final bool isLoading;
  final String? error;

  const RecurringState({
    this.templates = const [],
    this.isLoading = false,
    this.error,
  });

  RecurringState copyWith({
    List<RecurringTemplate>? templates,
    bool? isLoading,
    String? Function()? error,
  }) {
    return RecurringState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [templates, isLoading, error];
}
