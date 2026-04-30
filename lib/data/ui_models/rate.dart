import 'package:besties_notes/data/common.dart';
import 'package:equatable/equatable.dart';

class Rate extends Equatable {
  final double rate;
  final RatePeriod period;

  const Rate({required this.rate, required this.period});

  double calculateOwed(int unpaidLessons) =>
      period == .daily ? rate * unpaidLessons : rate;

  @override
  String toString() => "$rate / ${period.name}";

  @override
  List<Object?> get props => [rate, period];
}
