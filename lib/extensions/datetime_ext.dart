import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date formats use intl skeletons, so order and wording follow the current
/// locale (see `syncIntlLocale`): "Thu, Oct 1, 2026" / "чт, 1 жовт. 2026 р.".
extension DatetimeExt on DateTime {
  /// Clock time in the device's 12/24-hour preference.
  String formatTime(BuildContext context) =>
      MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(this),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );

  /// "Thu, Oct 1, 2026".
  String toLongDateFormat() => DateFormat.yMMMEd().format(this);

  /// "Oct 1, 2026".
  String toMediumDateFormat() => DateFormat.yMMMd().format(this);

  /// "10/1/2026" / "01.10.2026" — fits half-width fields in any language.
  String toShortDateFormat() => DateFormat.yMd().format(this);

  /// "Oct 1".
  String toDayMonthFormat() => DateFormat.MMMd().format(this);

  /// "THU".
  String capsWeekday() => DateFormat.E().format(this).toUpperCase();

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
}
