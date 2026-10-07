import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:equatable/equatable.dart';

enum RangePreset { thisMonth, lastMonth, thisYear, allTime, custom }

/// The period a report covers, as a half-open range `[from, to)`.
class ReportRange extends Equatable {
  final RangePreset preset;
  final DateTime from;
  final DateTime to;

  const ReportRange._(this.preset, this.from, this.to);

  factory ReportRange.preset(RangePreset preset, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dateOnly;
    return switch (preset) {
      RangePreset.thisMonth => ReportRange._(
        preset,
        DateTime(today.year, today.month),
        DateTime(today.year, today.month + 1),
      ),
      RangePreset.lastMonth => ReportRange._(
        preset,
        DateTime(today.year, today.month - 1),
        DateTime(today.year, today.month),
      ),
      RangePreset.thisYear => ReportRange._(
        preset,
        DateTime(today.year),
        DateTime(today.year + 1),
      ),
      // Wider than any lesson the app could hold.
      RangePreset.allTime => ReportRange._(
        preset,
        DateTime(1970),
        DateTime(3000),
      ),
      // A custom range needs its days; default to this month.
      RangePreset.custom => ReportRange.custom(
        DateTime(today.year, today.month),
        DateTime(today.year, today.month + 1).addDays(-1),
      ),
    };
  }

  /// From the start of [firstDay] to the end of [lastDay], both included.
  factory ReportRange.custom(DateTime firstDay, DateTime lastDay) =>
      ReportRange._(
        RangePreset.custom,
        firstDay.dateOnly,
        lastDay.dateOnly.addDays(1),
      );

  /// The last day inside the range.
  DateTime get lastDay => to.addDays(-1);

  @override
  List<Object?> get props => [preset, from, to];
}
