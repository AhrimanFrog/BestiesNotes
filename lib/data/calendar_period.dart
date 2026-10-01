import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:intl/intl.dart';

enum CalendarView { week, month }

/// The span of days a calendar view shows around an anchor day.
/// Ranges are half-open: `[from, to)`.
abstract final class CalendarPeriod {
  /// Month grids always span six weeks so their height never jumps.
  static const monthGridDays = 42;

  static ({DateTime from, DateTime to}) range(
    CalendarView view,
    DateTime anchor,
    int weekStart,
  ) {
    switch (view) {
      case CalendarView.week:
        final from = anchor.startOfWeek(weekStart);
        return (from: from, to: from.addDays(7));
      case CalendarView.month:
        final from = anchor.startOfMonth.startOfWeek(weekStart);
        return (from: from, to: from.addDays(monthGridDays));
    }
  }

  /// The anchor [steps] periods away. Moving by months lands on the 1st, so
  /// e.g. 31 Jan + 1 month is 1 Feb rather than overflowing into March.
  static DateTime shift(CalendarView view, DateTime anchor, int steps) {
    return switch (view) {
      CalendarView.week => anchor.addDays(7 * steps),
      CalendarView.month => DateTime(anchor.year, anchor.month + steps),
    };
  }

  /// "28 Sep – 4 Oct", "October 2026". Adds the year when it isn't the
  /// current one, or when a week spans two years.
  static String label(
    CalendarView view,
    DateTime anchor,
    int weekStart, {
    DateTime? now,
  }) {
    final currentYear = (now ?? DateTime.now()).year;
    switch (view) {
      case CalendarView.month:
        return DateFormat('MMMM y').format(anchor);
      case CalendarView.week:
        final (:from, :to) = range(view, anchor, weekStart);
        final last = to.addDays(-1);
        final withYear = from.year != last.year || from.year != currentYear;
        final format = DateFormat(withYear ? 'd MMM y' : 'd MMM');
        return '${format.format(from)} – ${format.format(last)}';
    }
  }
}
