import 'student.dart';

class Debtor {
  final Student debtor;
  final int unpaidLessons;

  double get amountOwed => debtor.pricing.period == .daily
      ? debtor.pricing.rate * unpaidLessons
      : debtor.pricing.rate;

  const Debtor({required this.debtor, required this.unpaidLessons});
}
