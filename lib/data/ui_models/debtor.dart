import 'student.dart';

class Debtor {
  final Student debtor;
  final int unpaidLessons;

  double get amountOwed => debtor.pricing.calculateOwed(unpaidLessons);

  const Debtor({required this.debtor, required this.unpaidLessons});
}
