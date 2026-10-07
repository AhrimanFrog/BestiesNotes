import 'package:besties_notes/data/calendar_period.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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

    setUpAll(() => initializeDateFormatting('uk'));

    String label(CalendarView view, DateTime anchor, {String locale = 'en'}) =>
        Intl.withLocale(
          locale,
          () => CalendarPeriod.label(view, anchor, monday, now: now),
        );

    test('weeks of the current year omit the year', () {
      expect(
        label(CalendarView.week, DateTime(2025, 1, 22)),
        'Jan 20 – Jan 26',
      );
    });

    test('a week spanning two years shows both', () {
      expect(
        label(CalendarView.week, DateTime(2025, 12, 31)),
        'Dec 29, 2025 – Jan 4, 2026',
      );
    });

    test('months show name and year', () {
      expect(label(CalendarView.month, DateTime(2025, 10, 9)), 'October 2025');
    });

    test('Ukrainian: day before month, standalone month name', () {
      expect(
        label(CalendarView.week, DateTime(2025, 1, 22), locale: 'uk'),
        '20 січ. – 26 січ.',
      );
      expect(
        label(CalendarView.month, DateTime(2025, 10, 9), locale: 'uk'),
        // intl puts a narrow no-break space before "р." (рік, year).
        'жовтень 2025 р.',
      );
    });
  });
}
