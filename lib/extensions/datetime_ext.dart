import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DatetimeExt on DateTime {
  /// Clock time in the device's 12/24-hour preference.
  String formatTime(BuildContext context) =>
      MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(this),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );

  /// "Thu, 1 Oct 2026".
  String toLongDateFormat() => DateFormat('EEE, d MMM y').format(this);

  /// "1 Oct 2026" — fits half-width fields.
  String toMediumDateFormat() => DateFormat('d MMM y').format(this);

  DateTime get dateOnly => DateTime(year, month, day);

  /// Calendar-day arithmetic. Unlike `add(Duration(days: n))` this doesn't
  /// drift by an hour across DST changes.
  DateTime addDays(int days) => DateTime(year, month, day + days);

  /// Midnight of the first day of the week containing this date.
  /// [weekStart] is a [DateTime.monday]..[DateTime.sunday] constant.
  DateTime startOfWeek(int weekStart) =>
      dateOnly.addDays(-((weekday - weekStart) % 7));

  DateTime get startOfMonth => DateTime(year, month);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool get isToday => isSameDay(DateTime.now());

  String toDateFormat() {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return '$d.$m.$year';
  }

  /// "MON".
  String capsWeekday() => DateFormat('EEE').format(this).toUpperCase();

  /// "28 Sep".
  String toDayMonthFormat() => DateFormat('d MMM').format(this);
}
