import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:flutter/material.dart';

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
    // dateTo is exclusive (midnight after the last day), display dateTo - 1 day
    final to = timeRange.end.subtract(const Duration(days: 1));
    final label = '${from.toDateFormat()} – ${to.toDateFormat()}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: AppColors.accentPink,
          onPressed: onTapLeft,
        ),
        GestureDetector(
          onTap: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDateRange: DateTimeRange(start: from, end: to),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.accentPink,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.mainText,
                  ),
                ),
                child: child!,
              ),
            );
            if (range != null && onRangeSelection != null) {
              onRangeSelection!(range);
            }
          },
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.mainText,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: AppColors.accentPink,
          onPressed: onTapRight,
        ),
      ],
    );
  }
}
