import 'package:besties_notes/data/common.dart';
import 'package:equatable/equatable.dart';

class Rate extends Equatable {
  final double rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});

  /// Parses a user-typed amount, accepting `,` as the decimal separator.
  static double? tryParseAmount(String input) =>
      double.tryParse(input.trim().replaceAll(',', '.'));

  /// Amount owed for unpaid lessons that started on [lessonDates].
  /// A per-lesson rate is charged for every lesson; a monthly rate once for
  /// every calendar month that has at least one unpaid lesson.
  double calculateOwed(Iterable<DateTime> lessonDates) {
    if (period == .perLesson) return rate * lessonDates.length;
    final months = {for (final d in lessonDates) (d.year, d.month)};
    return rate * months.length;
  }

  String get periodLabel => switch (period) {
    .perLesson => 'lesson',
    .monthly => 'month',
  };

  @override
  String toString() {
    final amount = rate == rate.roundToDouble()
        ? rate.toStringAsFixed(0)
        : rate.toStringAsFixed(2);
    return '$amount / $periodLabel';
  }

  @override
  List<Object?> get props => [rate, period];
}
