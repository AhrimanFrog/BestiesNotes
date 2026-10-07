part of 'reports_cubit.dart';

class ReportsState extends Equatable implements CubitState {
  final ReportRange range;

  /// Everything billed in [range].
  final List<Charge> charges;

  /// Who owes money, across all time.
  final List<Debtor> debtors;
  @override
  final bool isLoading;
  @override
  final String? error;

  const ReportsState({
    required this.range,
    this.charges = const [],
    this.debtors = const [],
    this.isLoading = false,
    this.error,
  });

  EarningsSummary get summary => EarningsSummary.of(charges);

  List<StudentEarnings> get byStudent => Earnings.byStudent(charges);

  ReportsState copyWith({
    ReportRange? range,
    List<Charge>? charges,
    List<Debtor>? debtors,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      range: range ?? this.range,
      charges: charges ?? this.charges,
      debtors: debtors ?? this.debtors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [range, charges, debtors, isLoading, error];

  @override
  bool get isEmpty => charges.isEmpty && debtors.isEmpty;
}
