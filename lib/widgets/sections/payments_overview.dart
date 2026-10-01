import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
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
                  label: 'Unpaid lessons',
                  value: '${unpaidLessons.length}',
                ),
                StatRow(
                  icon: Icons.account_balance_wallet_outlined,
                  tone: StatusTone.done,
                  label: 'Amount owed',
                  value: amountOwed > 0 ? amountOwed.toStringAsFixed(0) : '—',
                ),
                ...extraStats,
                const Divider(),
                StatRow(
                  icon: Icons.calendar_month_outlined,
                  tone: StatusTone.scheduled,
                  label: 'This month',
                  value: totalThisMonth > 0
                      ? '$paidThisMonth/$totalThisMonth paid'
                      : 'No lessons',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Section(
            title: 'Unpaid lessons',
            child: unpaidLessons.isEmpty
                ? const EmptyState(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'All paid up',
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
