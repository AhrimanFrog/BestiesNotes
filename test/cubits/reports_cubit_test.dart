import 'dart:async';

import 'package:besties_notes/cubits/reports/reports_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentProvider extends Mock implements PaymentProvider {}

const _rate = Rate(rate: 10, period: RatePeriod.perLesson);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _rate);

void main() {
  late MockPaymentProvider payments;
  final now = DateTime(2025, 10, 15);

  setUp(() {
    payments = MockPaymentProvider();
    when(() => payments.getDebtors()).thenAnswer(
      (_) async => [
        const Debtor(debtor: anna, unpaidLessons: 1, amountOwed: 10),
      ],
    );
  });

  void stubParticipations(
    Future<List<Participation>> Function(DateTime from) answer,
  ) {
    when(
      () => payments.getParticipations(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((i) => answer(i.namedArguments[#from] as DateTime));
  }

  blocTest<ReportsCubit, ReportsState>(
    'load totals this month and lists debtors',
    build: () => ReportsCubit(payments, now: now),
    setUp: () => stubParticipations(
      (_) async => [
        Participation(
          lessonId: 1,
          start: DateTime(2025, 10, 6),
          student: anna,
          rate: _rate,
          isPaid: true,
        ),
        Participation(
          lessonId: 2,
          start: DateTime(2025, 10, 13),
          student: anna,
          rate: _rate,
          isPaid: false,
        ),
      ],
    ),
    act: (c) => c.load(),
    verify: (c) {
      expect(c.state.range.from, DateTime(2025, 10));
      expect(c.state.summary.earned, 20);
      expect(c.state.summary.paid, 10);
      expect(c.state.byStudent.single.lessons, 2);
      expect(c.state.debtors.single.amountOwed, 10);
      expect(c.state.isLoading, isFalse);
    },
  );

  test('a slow load for an old range is dropped', () async {
    final slow = Completer<List<Participation>>();
    final thisMonth = DateTime(2025, 10);
    stubParticipations(
      (from) => from == thisMonth ? slow.future : Future.value(const []),
    );
    final cubit = ReportsCubit(payments, now: now);

    final first = cubit.load();
    await cubit.setRange(ReportRange.preset(RangePreset.allTime));
    slow.complete([
      Participation(
        lessonId: 1,
        start: DateTime(2025, 10, 6),
        student: anna,
        rate: _rate,
        isPaid: false,
      ),
    ]);
    await first;

    expect(cubit.state.range.preset, RangePreset.allTime);
    expect(cubit.state.charges, isEmpty);
    await cubit.close();
  });

  blocTest<ReportsCubit, ReportsState>(
    'a quiet reload keeps the figures instead of showing a spinner',
    build: () => ReportsCubit(payments, now: now),
    setUp: () => stubParticipations((_) async => const []),
    act: (c) => c.load(quiet: true),
    expect: () => [
      isA<ReportsState>().having((s) => s.isLoading, 'isLoading', false),
    ],
  );
}
