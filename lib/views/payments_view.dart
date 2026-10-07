import 'package:besties_notes/cubits/payments/payments_cubit.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/money_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/fields/range_selector.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/widgets/sections/earnings_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// A student's (or a group's) payment history: totals for a period and every
/// billable lesson in it by month, each with a paid toggle.
class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  static const _presets = [
    RangePreset.allTime,
    RangePreset.thisMonth,
    RangePreset.lastMonth,
    RangePreset.thisYear,
    RangePreset.custom,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PaymentsCubit>();
    return BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        final months = state.months;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.groupId != null ? l10n.groupPayments : l10n.commonPayments,
            ),
          ),
          body: StateTransitionWidget(
            state: state,
            isEmpty: false,
            onRetry: cubit.load,
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
              children: [
                if (state.subject case final subject?)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.md,
                    ),
                    child: Text(
                      subject.name,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                RangeSelector(
                  range: state.range,
                  presets: _presets,
                  onChanged: cubit.setRange,
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.xxl,
                    children: [
                      EarningsSummaryCard(
                        summary: state.summary,
                        footer: [
                          StatRow(
                            icon: Icons.account_balance_wallet_outlined,
                            tone: state.owedAllTime > 0
                                ? StatusTone.warning
                                : StatusTone.done,
                            label: l10n.paymentsOwedInTotal,
                            value: state.owedAllTime > 0
                                ? context.money(state.owedAllTime)
                                : l10n.paymentsAllPaidUp,
                          ),
                        ],
                      ),
                      if (months.isEmpty && !state.isLoading)
                        EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: l10n.paymentsNoLessons,
                          compact: true,
                        ),
                      for (final month in months) _MonthSection(month: month),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MonthSection extends StatelessWidget {
  final PaymentMonth month;

  const _MonthSection({required this.month});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = month.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          spacing: AppSpacing.sm,
          children: [
            Text(
              DateFormat.yMMMM().format(month.month),
              style: context.textTheme.titleMedium,
            ),
            Expanded(
              child: Text(
                summary.unpaid > 0
                    ? '${context.money(summary.earned)} · '
                          '${l10n.earningsUnpaidAmount(context.money(summary.unpaid))}'
                    : context.money(summary.earned),
                textAlign: TextAlign.end,
                style: context.textTheme.labelMedium,
              ),
            ),
          ],
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (final (i, entry) in month.entries.indexed) ...[
                if (i > 0) const Divider(height: 1, indent: AppSpacing.lg),
                _EntryRow(entry: entry),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  final PaymentEntry entry;

  const _EntryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PaymentsCubit>();
    final when =
        '${entry.start.toDayMonthFormat()} · ${entry.start.formatTime(context)}';
    final details = [
      when,
      // A group lesson can be partly paid.
      if (entry.total > 1) l10n.paidOfTotal(entry.paid, entry.total),
      if (entry.amount case final amount?) context.money(amount),
    ].join(' · ');

    return InkWell(
      onTap: () async {
        await context.openLesson(entry.lessonId);
        await cubit.load();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.sm,
          top: AppSpacing.xs,
          bottom: AppSpacing.xs,
        ),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    entry.lessonName.isEmpty ? when : entry.lessonName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall,
                  ),
                  Text(details, style: context.textTheme.labelMedium),
                ],
              ),
            ),
            _PaidToggle(
              isPaid: entry.isPaid,
              onPressed: () => cubit.togglePaid(entry),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Paid" / "Unpaid" pill that flips the state.
class _PaidToggle extends StatelessWidget {
  final bool isPaid;
  final VoidCallback onPressed;

  const _PaidToggle({required this.isPaid, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.tokens.tone(
      isPaid ? StatusTone.done : StatusTone.warning,
    );
    return Tooltip(
      message: isPaid ? l10n.paymentsMarkUnpaid : l10n.paymentsMarkPaid,
      child: Semantics(
        toggled: isPaid,
        child: TextButton.icon(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.fg,
            backgroundColor: colors.bg,
            textStyle: context.textTheme.labelMedium,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.padded,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
            shape: const StadiumBorder(),
          ),
          icon: Icon(
            isPaid ? Icons.check_rounded : Icons.schedule_rounded,
            size: 16,
          ),
          label: Text(isPaid ? l10n.earningsPaid : l10n.earningsUnpaid),
        ),
      ),
    );
  }
}
