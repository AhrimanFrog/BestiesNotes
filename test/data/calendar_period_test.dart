import 'package:besties_notes/data/calendar_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const monday = DateTime.monday;
  const sunday = DateTime.sunday;

  group('range', () {
    test('week view spans seven days from the week start', () {
      final r = CalendarPeriod.range(
        CalendarView.week,
        DateTime(2025, 1, 22),
        monday,
      );
      expect(r.from, DateTime(2025, 1, 20));
      expect(r.to, DateTime(2025, 1, 27));
    });

    test('month view always spans six whole weeks', () {
      // March 2026 starts on a Sunday: worst case for a Monday-first grid.
      final r = CalendarPeriod.range(
        CalendarView.month,
        DateTime(2026, 3, 15),
        monday,
      );
      // 42 calendar days. (Not via Duration.inDays: this range crosses the
      // March DST change, where a "day" is 23 hours.)
      expect(r.from, DateTime(2026, 2, 23));
      expect(r.to, DateTime(2026, 4, 6));
    });

    test('a Sunday week start begins the grid on a Sunday', () {
      final r = CalendarPeriod.range(
        CalendarView.month,
        DateTime(2026, 3, 15),
        sunday,
      );
      expect(r.from, DateTime(2026, 3, 1));
    });
  });

  group('shift', () {
    test('weeks move by seven days', () {
      expect(
        CalendarPeriod.shift(CalendarView.week, DateTime(2025, 12, 29), 1),
        DateTime(2026, 1, 5),
      );
    });

    test('months land on the 1st, never overflowing', () {
      expect(
        CalendarPeriod.shift(CalendarView.month, DateTime(2025, 1, 31), 1),
        DateTime(2025, 2, 1),
      );
      expect(
        CalendarPeriod.shift(CalendarView.month, DateTime(2025, 1, 15), -1),
        DateTime(2024, 12, 1),
      );
    });
  });

  group('label', () {
    final now = DateTime(2025, 6, 1);

    test('weeks of the current year omit the year', () {
      expect(
        CalendarPeriod.label(
          CalendarView.week,
          DateTime(2025, 1, 22),
          monday,
          now: now,
        ),
        '20 Jan – 26 Jan',
      );
    });

    test('a week spanning two years shows both', () {
      expect(
        CalendarPeriod.label(
          CalendarView.week,
          DateTime(2025, 12, 31),
          monday,
          now: now,
        ),
        '29 Dec 2025 – 4 Jan 2026',
      );
    });

    test('months show name and year', () {
      expect(
        CalendarPeriod.label(
          CalendarView.month,
          DateTime(2025, 10, 9),
          monday,
          now: now,
        ),
        'October 2025',
      );
    });
  });
}
