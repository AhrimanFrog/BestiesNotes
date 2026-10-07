import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:flutter_test/flutter_test.dart';

const _perLesson = Rate(rate: 10, period: RatePeriod.perLesson);
const _monthly = Rate(rate: 100, period: RatePeriod.monthly);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _perLesson);
const ben = Student(id: 2, name: 'Ben', contact: '', pricing: _monthly);

var _nextLesson = 0;

Participation p(
  DateTime start, {
  Student student = anna,
  Rate rate = _perLesson,
  bool isPaid = false,
  int? groupId,
}) => Participation(
  lessonId: ++_nextLesson,
  start: start,
  student: student,
  rate: rate,
  isPaid: isPaid,
  groupId: groupId,
);

void main() {
  group('charges', () {
    test('a per-lesson rate charges every lesson', () {
      final summary = Earnings.summarize([
        p(DateTime(2025, 1, 5), isPaid: true),
        p(DateTime(2025, 1, 12)),
        p(DateTime(2025, 2, 2)),
      ]);
      expect(summary.earned, 30);
      expect(summary.paid, 10);
      expect(summary.unpaid, 20);
    });

    test('a monthly rate charges once per month with lessons', () {
      final charges = Earnings.charges([
        p(DateTime(2025, 1, 5), student: ben, rate: _monthly),
        p(DateTime(2025, 1, 19), student: ben, rate: _monthly),
        p(DateTime(2025, 2, 2), student: ben, rate: _monthly),
      ]);
      expect(charges, hasLength(2));
      expect(charges.map((c) => c.date), [
        DateTime(2025, 1),
        DateTime(2025, 2),
      ]);
      expect(charges.first.lessonIds, hasLength(2));
      expect(EarningsSummary.of(charges).earned, 200);
    });

    test('a month is paid only once all its lessons are', () {
      final charges = Earnings.charges([
        p(DateTime(2025, 1, 5), student: ben, rate: _monthly, isPaid: true),
        p(DateTime(2025, 1, 19), student: ben, rate: _monthly),
      ]);
      expect(charges.single.isPaid, isFalse);
      expect(EarningsSummary.of(charges).unpaid, 100);
    });

    test('a month is priced at its latest rate', () {
      final charges = Earnings.charges([
        p(DateTime(2025, 1, 19), student: ben, rate: _monthly.copy(120)),
        p(DateTime(2025, 1, 5), student: ben, rate: _monthly),
      ]);
      expect(charges.single.amount, 120);
    });

    test('individual and group months are charged separately', () {
      final charges = Earnings.charges([
        p(DateTime(2025, 1, 5), student: ben, rate: _monthly),
        p(DateTime(2025, 1, 6), student: ben, rate: _monthly, groupId: 7),
      ]);
      expect(charges, hasLength(2));
      expect(charges.map((c) => c.groupId), containsAll([null, 7]));
    });

    test('nothing billed means nothing earned', () {
      expect(Earnings.summarize(const []), const EarningsSummary());
    });
  });

  test('byStudent totals each student, highest first', () {
    final rows = Earnings.byStudent(
      Earnings.charges([
        p(DateTime(2025, 1, 5)),
        p(DateTime(2025, 1, 6), student: ben, rate: _monthly, isPaid: true),
      ]),
    );
    expect(rows.map((r) => r.student), [ben, anna]);
    expect(rows.first.summary, const EarningsSummary(earned: 100, paid: 100));
    expect(rows.last.lessons, 1);
  });

  group('buckets', () {
    test('a month splits into weeks from the week start', () {
      // October 2025 starts on a Wednesday.
      final range = ReportRange.preset(
        RangePreset.thisMonth,
        now: DateTime(2025, 10, 15),
      );
      final data = Earnings.buckets(
        Earnings.charges([p(DateTime(2025, 10, 1)), p(DateTime(2025, 10, 8))]),
        range,
        weekStart: DateTime.monday,
      );
      expect(data.size, BucketSize.week);
      expect(data.buckets.first.start, DateTime(2025, 9, 29));
      expect(data.buckets.last.start, DateTime(2025, 10, 27));
      expect(data.buckets.map((b) => b.summary.earned).take(2), [10, 10]);
    });

    test('the week start setting moves the boundaries', () {
      final range = ReportRange.preset(
        RangePreset.thisMonth,
        now: DateTime(2025, 10, 15),
      );
      final data = Earnings.buckets(
        const [],
        range,
        weekStart: DateTime.sunday,
      );
      expect(data.buckets.first.start, DateTime(2025, 9, 28));
    });

    test('a year splits into months', () {
      final range = ReportRange.preset(
        RangePreset.thisYear,
        now: DateTime(2025, 6, 1),
      );
      final data = Earnings.buckets(
        Earnings.charges([p(DateTime(2025, 3, 3))]),
        range,
        weekStart: DateTime.monday,
      );
      expect(data.size, BucketSize.month);
      expect(data.buckets, hasLength(12));
      expect(data.buckets[2].summary.earned, 10);
    });

    test('all time spans the months that have charges', () {
      final data = Earnings.buckets(
        Earnings.charges([p(DateTime(2024, 11, 3)), p(DateTime(2025, 2, 3))]),
        ReportRange.preset(RangePreset.allTime),
        weekStart: DateTime.monday,
      );
      expect(data.buckets.map((b) => b.start), [
        DateTime(2024, 11),
        DateTime(2024, 12),
        DateTime(2025, 1),
        DateTime(2025, 2),
      ]);
    });

    test('a monthly fee before a custom range lands in its first week', () {
      final data = Earnings.buckets(
        Earnings.charges([
          p(DateTime(2025, 10, 20), student: ben, rate: _monthly),
        ]),
        ReportRange.custom(DateTime(2025, 10, 15), DateTime(2025, 10, 31)),
        weekStart: DateTime.monday,
      );
      expect(data.buckets.first.summary.earned, 100);
    });
  });
}

extension on Rate {
  Rate copy(double amount) => Rate(rate: amount, period: period);
}
