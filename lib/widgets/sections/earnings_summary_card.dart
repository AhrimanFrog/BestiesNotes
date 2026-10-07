import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/extensions/money_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/cards/app_card.dart';
import 'package:flutter/material.dart';

/// Earned for a period as the headline figure, with paid and unpaid beside
/// it. [footer] adds rows under a divider (e.g. an all-time balance).
class EarningsSummaryCard extends StatelessWidget {
  final EarningsSummary summary;
  final List<Widget> footer;

  const EarningsSummaryCard({
    super.key,
    required this.summary,
    this.footer = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.earningsEarned, style: context.textTheme.labelMedium),
              Text(
                context.money(summary.earned),
                // A figure, so the body sans rather than the display face.
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: _Figure(
                  color: tokens.chartPaid,
                  label: l10n.earningsPaid,
                  value: context.money(summary.paid),
                ),
              ),
              Expanded(
                child: _Figure(
                  color: tokens.chartUnpaid,
                  label: l10n.earningsUnpaid,
                  value: context.money(summary.unpaid),
                ),
              ),
            ],
          ),
          if (footer.isNotEmpty) ...[const Divider(height: 1), ...footer],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _Figure({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.tokens.surfaceMuted,
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Row(
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
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium,
                ),
              ),
            ],
          ),
          Text(value, style: context.textTheme.titleSmall),
        ],
      ),
    );
  }
}
