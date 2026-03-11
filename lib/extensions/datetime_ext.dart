extension DatetimeExt on DateTime {
  String toHoursAndMinsFormat() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String toDateFormat() {
    final d = day.toString().padLeft(2, '0');
    final m = month.toString().padLeft(2, '0');
    return '$d.$m.$year';
  }

  String capsWeekday() {
    switch (weekday) {
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      case 7:
        return "SUN";
      case _:
        return "WHAT?!";
    }
  }
}
