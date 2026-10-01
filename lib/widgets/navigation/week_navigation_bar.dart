import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// "‹  06.01.2025 – 12.01.2025  ›". [timeRange] is half-open: its `end` is
/// the exclusive midnight after the last shown day.
class WeekNavigationBar extends StatelessWidget {
  final DateTimeRange timeRange;
  final Function(DateTimeRange)? onRangeSelection;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;

  const WeekNavigationBar({
    super.key,
    required this.timeRange,
    this.onRangeSelection,
    this.onTapLeft,
    this.onTapRight,
  });

  @override
  Widget build(BuildContext context) {
    final from = timeRange.start;
    final lastDay = timeRange.end.addDays(-1);
    final label = '${from.toDateFormat()} – ${lastDay.toDateFormat()}';
    final accent = context.tokens.accent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: accent,
          tooltip: 'Previous week',
          onPressed: onTapLeft,
        ),
        Flexible(
          // Shrinks instead of overflowing with large system text.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDateRange: DateTimeRange(start: from, end: lastDay),
                );
                if (range != null && onRangeSelection != null) {
                  // The picker's end is inclusive; the app's ranges are not.
                  onRangeSelection!(
                    DateTimeRange(
                      start: range.start,
                      end: range.end.addDays(1),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: context.tokens.text),
              child: Text(label, style: context.textTheme.titleSmall),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: accent,
          tooltip: 'Next week',
          onPressed: onTapRight,
        ),
      ],
    );
  }
}
