import 'student.dart';

class Debtor {
  final Student debtor;
  final List<DateTime> unpaidLessonDates;

  int get unpaidLessons => unpaidLessonDates.length;

  double get amountOwed => debtor.pricing.calculateOwed(unpaidLessonDates);

  const Debtor({required this.debtor, required this.unpaidLessonDates});
}
