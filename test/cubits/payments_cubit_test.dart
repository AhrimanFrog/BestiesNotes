import 'package:besties_notes/cubits/payments/payments_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataProvider extends Mock implements DataProvider {}

class MockPaymentProvider extends Mock implements PaymentProvider {}

const _rate = Rate(rate: 10, period: RatePeriod.perLesson);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _rate);
const ben = Student(id: 2, name: 'Ben', contact: '', pricing: _rate);
const club = Group(id: 5, name: 'Club', pricing: _rate);

Participation take(
  int lessonId,
  DateTime start, {
  Student student = anna,
  bool isPaid = false,
  int? groupId,
}) => Participation(
  lessonId: lessonId,
  lessonName: 'Lesson $lessonId',
  start: start,
  student: student,
  rate: _rate,
  isPaid: isPaid,
  groupId: groupId,
);

void main() {
  late MockDataProvider data;
  late MockPaymentProvider payments;

  setUp(() {
    data = MockDataProvider();
    payments = MockPaymentProvider();
    when(() => data.getStudent(any())).thenAnswer((_) async => anna);
    when(() => data.getGroup(any())).thenAnswer((_) async => club);
    when(
      () => data.getGroupMembers(any()),
    ).thenAnswer((_) async => [anna, ben]);
    when(
      () => data.updateParticipantStatus(
        any(),
        any(),
        isPaid: any(named: 'isPaid'),
      ),
    ).thenAnswer((_) async {});
    when(
      () =>
          data.updateGroupStatuses(any(), any(), isPaid: any(named: 'isPaid')),
    ).thenAnswer((_) async {});
  });

  void stubParticipations(List<Participation> all) {
    when(
      () => payments.getParticipations(
        from: any(named: 'from'),
        to: any(named: 'to'),
        studentId: any(named: 'studentId'),
        groupId: any(named: 'groupId'),
        unpaidOnly: any(named: 'unpaidOnly'),
      ),
    ).thenAnswer((invocation) async {
      final unpaidOnly = invocation.namedArguments[#unpaidOnly] as bool;
      return [
        for (final p in all)
          if (!unpaidOnly || !p.isPaid) p,
      ];
    });
  }

  blocTest<PaymentsCubit, PaymentsState>(
    'load groups the history by month, newest first',
    build: () => PaymentsCubit(payments, data, studentId: 1),
    setUp: () => stubParticipations([
      take(1, DateTime(2025, 1, 6), isPaid: true),
      take(2, DateTime(2025, 2, 3)),
      take(3, DateTime(2025, 2, 10)),
    ]),
    act: (c) => c.load(),
    verify: (c) {
      final s = c.state;
      expect(s.subject, anna);
      expect(s.summary.earned, 30);
      expect(s.owedAllTime, 20);
      expect(s.months.map((m) => m.month), [
        DateTime(2025, 2),
        DateTime(2025, 1),
      ]);
      expect(s.months.first.entries.map((e) => e.lessonId), [3, 2]);
      expect(s.months.first.summary.unpaid, 20);
    },
  );

  blocTest<PaymentsCubit, PaymentsState>(
    "a group's lesson is one entry covering every member",
    build: () => PaymentsCubit(payments, data, groupId: 5),
    setUp: () => stubParticipations([
      take(1, DateTime(2025, 1, 6), groupId: 5, isPaid: true),
      take(1, DateTime(2025, 1, 6), groupId: 5, student: ben),
    ]),
    act: (c) => c.load(),
    verify: (c) {
      final entry = c.state.months.single.entries.single;
      expect((entry.paid, entry.total, entry.amount), (1, 2, 20.0));
      expect(entry.isPaid, isFalse);
      expect(c.state.subject, isA<Group>());
    },
  );

  blocTest<PaymentsCubit, PaymentsState>(
    "toggling a student's lesson marks it paid",
    build: () => PaymentsCubit(payments, data, studentId: 1),
    setUp: () => stubParticipations([take(1, DateTime(2025, 1, 6))]),
    act: (c) async {
      await c.load();
      await c.togglePaid(c.state.months.single.entries.single);
    },
    verify: (_) => verify(
      () => data.updateParticipantStatus(1, 1, isPaid: true),
    ).called(1),
  );

  blocTest<PaymentsCubit, PaymentsState>(
    "toggling a part-paid group lesson marks the whole group paid",
    build: () => PaymentsCubit(payments, data, groupId: 5),
    setUp: () => stubParticipations([
      take(1, DateTime(2025, 1, 6), groupId: 5, isPaid: true),
      take(1, DateTime(2025, 1, 6), groupId: 5, student: ben),
    ]),
    act: (c) async {
      await c.load();
      await c.togglePaid(c.state.months.single.entries.single);
    },
    verify: (_) =>
        verify(() => data.updateGroupStatuses(1, 5, isPaid: true)).called(1),
  );

  blocTest<PaymentsCubit, PaymentsState>(
    'setRange reloads for the new period',
    build: () => PaymentsCubit(payments, data, studentId: 1),
    setUp: () => stubParticipations(const []),
    act: (c) => c.setRange(ReportRange.preset(RangePreset.lastMonth)),
    verify: (c) {
      expect(c.state.range.preset, RangePreset.lastMonth);
      verify(
        () => payments.getParticipations(
          from: c.state.range.from,
          to: c.state.range.to,
          studentId: 1,
          groupId: null,
          unpaidOnly: false,
        ),
      ).called(1);
    },
  );

  blocTest<PaymentsCubit, PaymentsState>(
    'load clears isLoading when it fails',
    build: () => PaymentsCubit(payments, data, studentId: 1),
    setUp: () {
      stubParticipations(const []);
      when(() => data.getStudent(any())).thenThrow(Exception('db error'));
    },
    act: (c) => c.load(),
    expect: () => [
      isA<PaymentsState>().having((s) => s.isLoading, 'isLoading', true),
      isA<PaymentsState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNotNull),
    ],
  );
}
