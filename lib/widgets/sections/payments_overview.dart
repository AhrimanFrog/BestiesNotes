import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/extensions/money_ui_ext.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

/// Stats + unpaid lesson list shared by the student and group payment screens.
class PaymentsOverview extends StatelessWidget {
  final CubitState state;
  final List<Lesson> unpaidLessons;
  final double amountOwed;
  final int paidThisMonth;
  final int totalThisMonth;
  final VoidCallback? onRetry;
  final ValueChanged<Lesson>? onLessonTap;

  /// Extra stat rows shown under the main ones (e.g. a group's member count).
  final List<Widget> extraStats;

  const PaymentsOverview({
    super.key,
    required this.state,
    required this.unpaidLessons,
    required this.amountOwed,
    required this.paidThisMonth,
    required this.totalThisMonth,
    this.onRetry,
    this.onLessonTap,
    this.extraStats = const [],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StateTransitionWidget(
      state: state,
      isEmpty: false,
      onRetry: onRetry,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.xxxl,
        ),
        children: [
          AppCard(
            child: Column(
              spacing: AppSpacing.md,
              children: [
                StatRow(
                  icon: Icons.warning_amber_rounded,
                  tone: unpaidLessons.isEmpty
                      ? StatusTone.neutral
                      : StatusTone.warning,
                  label: l10n.paymentsUnpaidLessons,
                  value: '${unpaidLessons.length}',
                ),
                StatRow(
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StatusTone.done,
                  label: l10n.paymentsAmountOwed,
                  value: amountOwed > 0 ? context.money(amountOwed) : '—',
                ),
                ...extraStats,
                const Divider(),
                StatRow(
                  icon: Icons.calendar_month_outlined,
                  tone: StatusTone.scheduled,
                  label: l10n.commonThisMonth,
                  value: totalThisMonth > 0
                      ? l10n.paidOfTotal(paidThisMonth, totalThisMonth)
                      : l10n.commonNoLessons,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Section(
            title: l10n.paymentsUnpaidLessons,
            child: unpaidLessons.isEmpty
                ? EmptyState(
                    icon: Icons.check_circle_outline_rounded,
                    title: l10n.paymentsAllPaidUp,
                    compact: true,
                  )
                : Column(
                    spacing: AppSpacing.sm,
                    children: [
                      for (final lesson in unpaidLessons)
                        CompactLessonTile(
                          lesson: lesson,
                          onTap: onLessonTap != null
                              ? () => onLessonTap!(lesson)
                              : null,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
