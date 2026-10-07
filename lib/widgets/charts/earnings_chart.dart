import 'dart:math' as math;

import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/extensions/money_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Earnings per week or month as stacked columns: paid at the bottom, unpaid
/// on top. Tapping a column shows its totals underneath, which is also where
/// values are spelled out (the unpaid colour is too light to rely on alone).
class EarningsChart extends StatefulWidget {
  final EarningsBuckets data;

  const EarningsChart({super.key, required this.data});

  static const _plotHeight = 132.0;
  static const _maxBarWidth = 24.0;
  static const _gap = 2.0;

  /// Past this many columns they get a fixed width and scroll sideways.
  static const _maxFitting = 12;
  static const _scrollingSlot = 44.0;

  @override
  State<EarningsChart> createState() => _EarningsChartState();
}

class _EarningsChartState extends State<EarningsChart> {
  int? _selected;

  List<EarningsBucket> get _buckets => widget.data.buckets;

  @override
  void didUpdateWidget(EarningsChart old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) _selected = null;
  }

  /// The current period if it's shown, else the latest one with earnings.
  int get _defaultSelection {
    final now = DateTime.now();
    final current = _buckets.lastIndexWhere((b) => !b.start.isAfter(now));
    if (current >= 0 && _buckets[current].summary.earned > 0) return current;
    final latest = _buckets.lastIndexWhere((b) => b.summary.earned > 0);
    return latest >= 0 ? latest : math.max(current, 0);
  }

  String _bucketLabel(EarningsBucket bucket, {bool long = false}) {
    return switch (widget.data.size) {
      BucketSize.week => DateFormat.MMMd().format(bucket.start),
      BucketSize.month =>
        long
            ? DateFormat.yMMMM().format(bucket.start)
            : DateFormat.LLL().format(bucket.start),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_buckets.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = context.l10n;
    final selected = _selected ?? _defaultSelection;
    final bucket = _buckets[selected];
    final maxEarned = _buckets.fold<double>(
      0,
      (m, b) => math.max(m, b.summary.earned),
    );

    final columns = [
      for (var i = 0; i < _buckets.length; i++)
        _Column(
          bucket: _buckets[i],
          label: _bucketLabel(_buckets[i]),
          maxEarned: maxEarned,
          selected: i == selected,
          semanticsLabel:
              '${_bucketLabel(_buckets[i], long: true)}: '
              '${l10n.earningsEarned} ${context.money(_buckets[i].summary.earned)}, '
              '${l10n.earningsUnpaid} ${context.money(_buckets[i].summary.unpaid)}',
          onTap: () => setState(() => _selected = i),
        ),
    ];
    final scrolls = columns.length > EarningsChart._maxFitting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        Wrap(
          spacing: AppSpacing.lg,
          children: [
            _LegendKey(color: tokens.chartPaid, label: l10n.earningsPaid),
            _LegendKey(color: tokens.chartUnpaid, label: l10n.earningsUnpaid),
          ],
        ),
        SizedBox(
          // Plot plus the label row, which grows with the text size.
          height:
              EarningsChart._plotHeight +
              MediaQuery.textScalerOf(context).scale(16) +
              AppSpacing.md,
          child: scrolls
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: [
                    for (final c in columns.reversed)
                      SizedBox(width: EarningsChart._scrollingSlot, child: c),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final c in columns) Expanded(child: c)],
                ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.data.size == BucketSize.week
                    ? l10n.reportsWeekOf(_bucketLabel(bucket))
                    : _bucketLabel(bucket, long: true),
                style: context.textTheme.titleSmall,
              ),
              TextSpan(
                text:
                    '\n${l10n.earningsEarned} ${context.money(bucket.summary.earned)}'
                    ' · ${l10n.earningsUnpaid} ${context.money(bucket.summary.unpaid)}',
              ),
            ],
          ),
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  final EarningsBucket bucket;
  final String label;
  final double maxEarned;
  final bool selected;
  final String semanticsLabel;
  final VoidCallback onTap;

  const _Column({
    required this.bucket,
    required this.label,
    required this.maxEarned,
    required this.selected,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final summary = bucket.summary;
    const top = BorderRadius.vertical(top: Radius.circular(4));

    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                // Emphasis: the selected column at full strength.
                opacity: selected ? 1 : 0.45,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // The gap comes out of the scale so a full column fits.
                    final scale = maxEarned == 0
                        ? 0.0
                        : (constraints.maxHeight - EarningsChart._gap) /
                              maxEarned;
                    final paidHeight = summary.paid * scale;
                    final unpaidHeight = summary.unpaid * scale;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (unpaidHeight > 0)
                          Container(
                            width: EarningsChart._maxBarWidth,
                            height: unpaidHeight,
                            decoration: BoxDecoration(
                              color: tokens.chartUnpaid,
                              borderRadius: top,
                            ),
                          ),
                        if (unpaidHeight > 0 && paidHeight > 0)
                          const SizedBox(height: EarningsChart._gap),
                        if (paidHeight > 0)
                          Container(
                            width: EarningsChart._maxBarWidth,
                            height: paidHeight,
                            decoration: BoxDecoration(
                              color: tokens.chartPaid,
                              borderRadius: unpaidHeight > 0 ? null : top,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(height: 1, color: tokens.divider),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: context.textTheme.labelMedium?.copyWith(
                color: selected ? tokens.text : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendKey extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendKey({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs + 2,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
        ),
        Text(label, style: context.textTheme.labelMedium),
      ],
    );
  }
}
