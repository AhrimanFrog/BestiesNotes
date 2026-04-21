import 'package:besties_notes/data/ui_models/index.dart';

abstract class PaymentProvider {
  Future<({int paidLessons, int totalLessons})> getPaymentStatForPeriod({
    required DateTime from,
    required DateTime to,
    required int studentId,
  });

  Future<({int paidLessons, int totalLessons})> getPaymentStatForGroup({
    required int groupId,
    required DateTime from,
    required DateTime to,
  });

  Future<List<Lesson>> getLessonsWithPaymentStatus(bool paymentStatus);

  Future<List<Lesson>> getUnpaidLessonsForStudent(int studentId);

  Future<List<Lesson>> getUnpaidLessonsForGroup(int groupId);

  Future<List<Debtor>> getDebtors();
}
