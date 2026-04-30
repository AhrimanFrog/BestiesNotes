part of 'payments_cubit.dart';

class PaymentsState extends Equatable implements CubitState {
  final Student student;
  final List<Lesson> unpaidLessons;
  final int paidThisMonth;
  final int totalThisMonth;
  @override
  final bool isLoading;
  @override
  final String? error;

  const PaymentsState({
    this.student = const Student.demo(),
    this.unpaidLessons = const [],
    this.paidThisMonth = 0,
    this.totalThisMonth = 0,
    this.isLoading = false,
    this.error,
  });

  double get amountOwed => student.pricing.calculateOwed(unpaidLessons.length);

  PaymentsState copyWith({
    Student? student,
    List<Lesson>? unpaidLessons,
    int? paidThisMonth,
    int? totalThisMonth,
    bool? isLoading,
    String? error,
  }) {
    return PaymentsState(
      student: student ?? this.student,
      unpaidLessons: unpaidLessons ?? this.unpaidLessons,
      paidThisMonth: paidThisMonth ?? this.paidThisMonth,
      totalThisMonth: totalThisMonth ?? this.totalThisMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    student,
    unpaidLessons,
    paidThisMonth,
    totalThisMonth,
    isLoading,
    error,
  ];

  @override
  bool get isEmpty => unpaidLessons.isEmpty;
}
