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
            const Text(
              'Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Icon(Icons.access_time, size: 22),
          ],
        ),
        ArrowedText(
          origin: start.toHoursAndMinsFormat(),
          destination: end.toHoursAndMinsFormat(),
          isMain: true,
        ),
        Row(
          children: [
            ArrowedText(
              origin: '09 Oct 2024',
              destination: '09 Oct 2024',
              isMain: false,
            ),
            const Spacer(),
            Icon(Icons.repeat, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              'Repeat',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}
