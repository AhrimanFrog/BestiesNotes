import 'package:besties_notes/data/common.dart';

class Rate {
  final double rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});

  @override
  String toString() => "$rate / ${period.name}";
}
