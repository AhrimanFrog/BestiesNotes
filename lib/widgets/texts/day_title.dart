import 'package:flutter/material.dart';

class DayTitle extends StatelessWidget {
  final String weekDay;
  final String date;

  const DayTitle({super.key, required this.weekDay, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weekDay, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(date, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
