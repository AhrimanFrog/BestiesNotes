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

  /// Billable participations (lesson started, not cancelled) with lessons
  /// starting in `[from, to)`, oldest first. Narrowed to one student, or to
  /// the members billed through one group, when given.
  Future<List<Participation>> getParticipations({
    DateTime? from,
    DateTime? to,
    int? studentId,
    int? groupId,
    bool unpaidOnly = false,
  });

  /// Students with unpaid charges, most owed first.
  Future<List<Debtor>> getDebtors();
}
