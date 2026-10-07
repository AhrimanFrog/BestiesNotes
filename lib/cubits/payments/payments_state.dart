part of 'payments_cubit.dart';

/// One lesson in a payment history. For a group it covers every member who
/// came with the group.
class PaymentEntry extends Equatable {
  final int lessonId;
  final String lessonName;
  final DateTime start;
  final int paid;
  final int total;

  /// The lesson's price (summed over members); null on a monthly rate,
  /// where the month is the charge rather than the lesson.
  final double? amount;

  const PaymentEntry({
    required this.lessonId,
    required this.lessonName,
    required this.start,
    required this.paid,
    required this.total,
    this.amount,
  });

  bool get isPaid => paid == total;

  @override
  List<Object?> get props => [lessonId, lessonName, start, paid, total, amount];
}

/// A calendar month of a payment history, newest first.
class PaymentMonth extends Equatable {
  final DateTime month;
  final EarningsSummary summary;
  final List<PaymentEntry> entries;

  const PaymentMonth({
    required this.month,
    required this.summary,
    required this.entries,
  });

  @override
  List<Object?> get props => [month, summary, entries];
}

class PaymentsState extends Equatable implements CubitState {
  /// The student, or the group (with its members).
  final Teachable? subject;
  final ReportRange range;
  final List<Participation> participations;

  /// Unpaid across all time, regardless of [range].
  final double owedAllTime;
  @override
  final bool isLoading;
  @override
  final String? error;

  const PaymentsState({
    required this.range,
    this.subject,
    this.participations = const [],
    this.owedAllTime = 0,
    this.isLoading = false,
    this.error,
  });

  List<Charge> get charges => Earnings.charges(participations);

  EarningsSummary get summary => EarningsSummary.of(charges);

  /// The history, grouped by month, newest first.
  List<PaymentMonth> get months {
    final byLesson = <int, List<Participation>>{};
    for (final p in participations) {
      byLesson.putIfAbsent(p.lessonId, () => []).add(p);
    }
    final entries = [
      for (final ps in byLesson.values)
        PaymentEntry(
          lessonId: ps.first.lessonId,
          lessonName: ps.first.lessonName,
          start: ps.first.start,
          paid: ps.where((p) => p.isPaid).length,
          total: ps.length,
          amount: ps.every((p) => p.rate.period == RatePeriod.perLesson)
              ? ps.fold<double>(0, (sum, p) => sum + p.rate.rate)
              : null,
        ),
    ]..sort((a, b) => b.start.compareTo(a.start));

    final charges = this.charges;
    final months = <(int, int), List<PaymentEntry>>{};
    for (final e in entries) {
      months.putIfAbsent((e.start.year, e.start.month), () => []).add(e);
    }
    return [
      for (final MapEntry(key: (year, month), value: entries) in months.entries)
        PaymentMonth(
          month: DateTime(year, month),
          summary: EarningsSummary.of(
            charges.where((c) => c.date.year == year && c.date.month == month),
          ),
          entries: entries,
        ),
    ];
  }

  PaymentsState copyWith({
    Teachable? subject,
    ReportRange? range,
    List<Participation>? participations,
    double? owedAllTime,
    bool? isLoading,
    String? error,
  }) {
    return PaymentsState(
      subject: subject ?? this.subject,
      range: range ?? this.range,
      participations: participations ?? this.participations,
      owedAllTime: owedAllTime ?? this.owedAllTime,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    subject,
    range,
    participations,
    owedAllTime,
    isLoading,
    error,
  ];

  @override
  bool get isEmpty => participations.isEmpty;
}
