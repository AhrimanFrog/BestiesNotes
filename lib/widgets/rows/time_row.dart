import 'package:flutter/material.dart';
import '../texts/arrowed_text.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';

class TimeRow extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const TimeRow({super.key, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          spacing: 8,
          children: [
            Text('Time', style: Theme.of(context).textTheme.titleMedium),
            const Icon(Icons.access_time, size: 22),
          ],
        ),
        Row(
          children: [
            ArrowedText(
              origin: start.toHoursAndMinsFormat(),
              destination: end.toHoursAndMinsFormat(),
              isMain: true,
            ),
            const Spacer(),
            Icon(Icons.repeat, size: 18, color: Colors.grey.shade600),
          ],
        ),
      ],
    );
  }
}
