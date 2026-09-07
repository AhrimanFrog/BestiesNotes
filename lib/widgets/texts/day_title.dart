import 'package:flutter/material.dart';

class DayTitle extends StatelessWidget {
  final String weekDay;
  final String date;
  final int lessonsNumber;

  const DayTitle({
    super.key,
    required this.weekDay,
    required this.date,
    required this.lessonsNumber,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("$weekDay $date", style: Theme.of(context).textTheme.titleSmall),
      Text(
        "$lessonsNumber lessons",
        style: Theme.of(context).textTheme.labelMedium,
      ),
    ],
  );
}
