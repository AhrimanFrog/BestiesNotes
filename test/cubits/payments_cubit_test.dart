import 'package:besties_notes/cubits/payments/payments_cubit.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

class MockPaymentProvider extends Mock implements PaymentProvider {}

void main() {
  late MockDataProvider data;
  late MockPaymentProvider payments;

  setUp(() {
    data = MockDataProvider();
    payments = MockPaymentProvider();
  });

  blocTest<PaymentsCubit, PaymentsState>(
    'load clears isLoading when it fails',
    build: () => PaymentsCubit(payments, data),
    setUp: () {
      when(() => data.getStudent(any())).thenThrow(Exception('db error'));
      when(
        () => payments.getUnpaidLessonsForStudent(any()),
      ).thenAnswer((_) async => []);
      when(
        () => payments.getPaymentStatForPeriod(
          from: any(named: 'from'),
          to: any(named: 'to'),
          studentId: any(named: 'studentId'),
        ),
      ).thenAnswer((_) async => (paidLessons: 0, totalLessons: 0));
    },
    act: (c) => c.load(1),
    expect: () => [
      isA<PaymentsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<PaymentsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );
}
