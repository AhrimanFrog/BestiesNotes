part of 'group_payments_cubit.dart';

class GroupPaymentsState extends Equatable implements CubitState {
  final Group group;
  final List<Lesson> unpaidLessons;
  final int paidThisMonth;
  final int totalThisMonth;
  @override
  final bool isLoading;
  @override
  final String? error;

  const GroupPaymentsState({
    this.group = const Group.demo(),
    this.unpaidLessons = const [],
    this.paidThisMonth = 0,
    this.totalThisMonth = 0,
    this.isLoading = false,
    this.error,
  });

  double get amountOwed => group.pricing.calculateOwed(unpaidLessons.length);

  GroupPaymentsState copyWith({
    Group? group,
    List<Lesson>? unpaidLessons,
    int? paidThisMonth,
    int? totalThisMonth,
    bool? isLoading,
    String? error,
  }) {
    return GroupPaymentsState(
      group: group ?? this.group,
      unpaidLessons: unpaidLessons ?? this.unpaidLessons,
      paidThisMonth: paidThisMonth ?? this.paidThisMonth,
      totalThisMonth: totalThisMonth ?? this.totalThisMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    group,
    unpaidLessons,
    paidThisMonth,
    totalThisMonth,
    isLoading,
    error,
  ];

  @override
  bool get isEmpty => unpaidLessons.isEmpty;
}
