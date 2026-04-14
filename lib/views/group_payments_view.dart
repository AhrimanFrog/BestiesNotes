import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/payments/group_payments_cubit.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPaymentsView extends StatefulWidget {
  final int groupId;

  const GroupPaymentsView({super.key, required this.groupId});

  @override
  State<GroupPaymentsView> createState() => _GroupPaymentsViewState();
}

class _GroupPaymentsViewState extends State<GroupPaymentsView> {
  @override
  void initState() {
    super.initState();
    context.read<GroupPaymentsCubit>().load(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPaymentsCubit, GroupPaymentsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('${state.group.name} — Payments')),
          body: GradientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _StatsCard(state: state),
                const SizedBox(height: 20),
                TitledSection(
                  title: 'Unpaid Lessons',
                  child: StateTransitionWidget(
                    state: state,
                    child: Column(
                      children: state.unpaidLessons
                          .map((l) => CompactLessonTile(lesson: l))
                          .toList(),
                    ),
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

// ─── Stats card ───────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  final GroupPaymentsState state;

  const _StatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _StatRow(
            icon: Icons.warning_amber_rounded,
            color: AppColors.accentPink,
            label: 'Unpaid lessons',
            value: '${state.unpaidLessons.length}',
          ),
          _StatRow(
            icon: Icons.group_outlined,
            color: AppColors.pastelBlue,
            label: 'Members',
            value: '${state.group.students.length}',
          ),
          _StatRow(
            icon: Icons.attach_money_rounded,
            color: AppColors.accentGreen,
            label: 'Amount owed',
            value: state.amountOwed > 0
                ? '${state.amountOwed.toStringAsFixed(0)} / ${state.group.pricing.period.name}'
                : '—',
          ),
          const Divider(height: 1, color: AppColors.softPink),
          _StatRow(
            icon: Icons.calendar_month_outlined,
            color: AppColors.pastelBlue,
            label: 'This month',
            value: state.totalThisMonth > 0
                ? '${state.paidThisMonth}/${state.totalThisMonth} paid'
                : 'No lessons this month',
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.mainText,
          ),
        ),
      ],
    );
  }
}
