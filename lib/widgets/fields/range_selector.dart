import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A row of period chips (this month, last month, …, custom). Picking
/// "Custom" opens a date range picker.
class RangeSelector extends StatelessWidget {
  final ReportRange range;
  final ValueChanged<ReportRange> onChanged;
  final List<RangePreset> presets;

  const RangeSelector({
    super.key,
    required this.range,
    required this.onChanged,
    this.presets = RangePreset.values,
  });

  Future<void> _pickCustom(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      // "All time" has no meaningful days to start from.
      initialDateRange: range.preset == RangePreset.allTime
          ? null
          : DateTimeRange(start: range.from, end: range.lastDay),
    );
    if (picked != null) onChanged(ReportRange.custom(picked.start, picked.end));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          for (final preset in presets)
            ChoiceChip(
              label: Text(rangeLabel(context, preset, range)),
              avatar: preset == RangePreset.custom
                  ? const Icon(Icons.date_range_rounded, size: 18)
                  : null,
              selected: range.preset == preset,
              onSelected: (_) => preset == RangePreset.custom
                  ? _pickCustom(context)
                  : onChanged(ReportRange.preset(preset)),
            ),
        ],
      ),
    );
  }
}

/// A chip's label. The custom chip shows its dates once picked.
String rangeLabel(BuildContext context, RangePreset preset, ReportRange range) {
  final l10n = context.l10n;
  return switch (preset) {
    RangePreset.thisMonth => l10n.rangeThisMonth,
    RangePreset.lastMonth => l10n.rangeLastMonth,
    RangePreset.thisYear => l10n.rangeThisYear,
    RangePreset.allTime => l10n.rangeAllTime,
    RangePreset.custom when range.preset == RangePreset.custom => _datesLabel(
      range,
    ),
    RangePreset.custom => l10n.rangeCustom,
  };
}

String _datesLabel(ReportRange range) {
  final first = range.from;
  final last = range.lastDay;
  final format = first.year == last.year && first.year == DateTime.now().year
      ? DateFormat.MMMd()
      : DateFormat.yMMMd();
  return first == last
      ? format.format(first)
      : '${format.format(first)} – ${format.format(last)}';
}
