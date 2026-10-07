import 'package:besties_notes/data/common.dart';
import 'package:equatable/equatable.dart';

class Rate extends Equatable {
  final double rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});

  /// Parses a user-typed amount, accepting `,` as the decimal separator.
  static double? tryParseAmount(String input) =>
      double.tryParse(input.trim().replaceAll(',', '.'));

  /// For debugging; the UI uses `RateUIExt.label`, which is translated.
  @override
  String toString() => 'Rate($rate, ${period.name})';

  @override
  List<Object?> get props => [rate, period];
}
