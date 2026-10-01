import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rate.calculateOwed', () {
    final dates = [
      DateTime(2025, 1, 5),
      DateTime(2025, 1, 20),
      DateTime(2025, 2, 3),
    ];

    test('per-lesson rate charges every lesson', () {
      const rate = Rate(rate: 10, period: RatePeriod.perLesson);
      expect(rate.calculateOwed(dates), 30);
    });

    test('monthly rate charges once per month with unpaid lessons', () {
      const rate = Rate(rate: 100, period: RatePeriod.monthly);
      expect(rate.calculateOwed(dates), 200);
    });

    test('nothing unpaid means nothing owed', () {
      const rate = Rate(rate: 100, period: RatePeriod.monthly);
      expect(rate.calculateOwed(const []), 0);
    });
  });

  test('tryParseAmount accepts comma decimals', () {
    expect(Rate.tryParseAmount('12,5'), 12.5);
    expect(Rate.tryParseAmount(' 7.25 '), 7.25);
    expect(Rate.tryParseAmount('abc'), isNull);
  });

  test('toString is human readable', () {
    expect(
      const Rate(rate: 420, period: RatePeriod.perLesson).toString(),
      '420 / lesson',
    );
    expect(
      const Rate(rate: 12.5, period: RatePeriod.monthly).toString(),
      '12.50 / month',
    );
  });
}
