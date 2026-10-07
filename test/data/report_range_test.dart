import 'package:besties_notes/data/report_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 1, 20, 15, 30);

  test('this month covers the whole calendar month', () {
    final r = ReportRange.preset(RangePreset.thisMonth, now: now);
    expect(r.from, DateTime(2026, 1));
    expect(r.to, DateTime(2026, 2));
  });

  test('last month wraps into the previous year', () {
    final r = ReportRange.preset(RangePreset.lastMonth, now: now);
    expect(r.from, DateTime(2025, 12));
    expect(r.to, DateTime(2026, 1));
  });

  test('this year runs January to January', () {
    final r = ReportRange.preset(RangePreset.thisYear, now: now);
    expect(r.from, DateTime(2026));
    expect(r.to, DateTime(2027));
  });

  test('a custom range includes its last day', () {
    final r = ReportRange.custom(DateTime(2026, 1, 5), DateTime(2026, 1, 11));
    expect(r.to, DateTime(2026, 1, 12));
    expect(r.lastDay, DateTime(2026, 1, 11));
  });
}
