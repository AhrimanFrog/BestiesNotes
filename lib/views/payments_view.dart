import 'package:besties_notes/cubits/payments/payments_cubit.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/widgets/sections/payments_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsView extends StatefulWidget {
  final int studentId;

  const PaymentsView({super.key, required this.studentId});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().load(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Payments')),
          body: PaymentsOverview(
            state: state,
            unpaidLessons: state.unpaidLessons,
            amountOwed: state.amountOwed,
            paidThisMonth: state.paidThisMonth,
            totalThisMonth: state.totalThisMonth,
            onRetry: () =>
                context.read<PaymentsCubit>().load(widget.studentId),
            onLessonTap: (lesson) async {
              await context.openLesson(lesson.id!);
              if (context.mounted) {
                context.read<PaymentsCubit>().load(widget.studentId);
              }
            },
          ),
        );
      },
    );
  }
}
