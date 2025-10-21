extension DatetimeExt on DateTime {
  

  String toHoursAndMinsFormat() {
    return '$hour:$minute';
  }

  String toDateFormat() {
    return "$day.$month.$year";
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
