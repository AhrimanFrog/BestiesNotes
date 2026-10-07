import 'package:besties_notes/cubits/reports/reports_cubit.dart';
import 'package:besties_notes/cubits/settings/settings_cubit.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/money_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/charts/earnings_chart.dart';
import 'package:besties_notes/widgets/fields/range_selector.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/widgets/sections/earnings_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Lessons are marked paid elsewhere.
    return RefreshOnShow(
      location: '/reports',
      onShown: () => context.read<ReportsCubit>().load(quiet: true),
      child: _scaffold(context, l10n),
    );
  }

  Widget _scaffold(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: const [
          SettingsButton(),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          final cubit = context.read<ReportsCubit>();
          final hasCharges = state.charges.isNotEmpty;
          return StateTransitionWidget(
            state: state,
            isEmpty: false,
            onRetry: cubit.load,
            child: RefreshIndicator(
              onRefresh: () => cubit.load(quiet: true),
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                children: [
                  RangeSelector(range: state.range, onChanged: cubit.setRange),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpacing.xxl,
                      children: [
                        if (hasCharges) ...[
                          EarningsSummaryCard(summary: state.summary),
                          AppCard(child: _Chart(state: state)),
                        ] else if (!state.isLoading)
                          EmptyState(
                            icon: Icons.insights_rounded,
                            title: l10n.reportsNothingYet,
                            message: l10n.reportsNothingYetMessage,
                            compact: true,
                          ),
                        if (state.debtors.isNotEmpty)
                          Section(
                            title: l10n.reportsOwedToYou,
                            child: _StudentList(
                              rows: [
                                for (final d in state.debtors)
                                  _StudentRow(
                                    student: d.debtor,
                                    subtitle: l10n.unpaidLessonCount(
                                      d.unpaidLessons,
                                    ),
                                    amount: context.money(d.amountOwed),
                                  ),
                              ],
                            ),
                          ),
                        if (hasCharges) ...[
                          Section(
                            title: l10n.reportsByStudent,
                            child: _StudentList(
                              rows: [
                                for (final s in state.byStudent)
                                  _StudentRow(
                                    student: s.student,
                                    subtitle: s.summary.unpaid > 0
                                        ? '${l10n.lessonCount(s.lessons)} · '
                                              '${l10n.earningsUnpaidAmount(context.money(s.summary.unpaid))}'
                                        : l10n.lessonCount(s.lessons),
                                    amount: context.money(s.summary.earned),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            l10n.reportsHowCounted,
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final ReportsState state;

  const _Chart({required this.state});

  @override
  Widget build(BuildContext context) {
    final weekStart = context.select((SettingsCubit c) => c.state.weekStart);
    return EarningsChart(
      data: Earnings.buckets(state.charges, state.range, weekStart: weekStart),
    );
  }
}

class _StudentList extends StatelessWidget {
  final List<_StudentRow> rows;

  const _StudentList({required this.rows});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (final (i, row) in rows.indexed) ...[
            if (i > 0) const Divider(height: 1, indent: 72),
            row,
          ],
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final Student student;
  final String subtitle;
  final String amount;

  const _StudentRow({
    required this.student,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(teachable: student, size: 40),
      title: Text(student.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: Text(amount, style: context.textTheme.titleSmall),
      onTap: () => context.openStudentPayments(student.id!),
    );
  }
}
