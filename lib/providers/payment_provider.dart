import 'package:besties_notes/data/ui_models/index.dart';

abstract class PaymentProvider {
  Future<({int paidLessons, int totalLessons})> getPaymentStatForPeriod({
    required DateTime from,
    required DateTime to,
    required int studentID,
  });

  Future<List<Lesson>> getLessonsWithPaymentStatus(bool paymentStatus);

  Future<List<Lesson>> getUnpaidLessonsForStudent(int studentId);

  Future<List<Debtor>> getDebtors();
}
