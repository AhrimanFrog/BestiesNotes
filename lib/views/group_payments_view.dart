import 'package:besties_notes/cubits/payments/group_payments_cubit.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/rows/stat_row.dart';
import 'package:besties_notes/widgets/sections/payments_overview.dart';
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
          appBar: AppBar(title: Text(context.l10n.groupPayments)),
          body: PaymentsOverview(
            state: state,
            unpaidLessons: state.unpaidLessons,
            amountOwed: state.amountOwed,
            paidThisMonth: state.paidThisMonth,
            totalThisMonth: state.totalThisMonth,
            onRetry: () =>
                context.read<GroupPaymentsCubit>().load(widget.groupId),
            onLessonTap: (lesson) async {
              await context.openLesson(lesson.id!);
              if (context.mounted) {
                context.read<GroupPaymentsCubit>().load(widget.groupId);
              }
            },
            extraStats: [
              StatRow(
                icon: Icons.group_outlined,
                tone: StatusTone.scheduled,
                label: context.l10n.commonMembers,
                value: '${state.group.students.length}',
              ),
            ],
          ),
        );
      },
    );
  }
}
