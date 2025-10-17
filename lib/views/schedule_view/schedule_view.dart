// import 'schedule_view_model.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  // final ScheduleViewModel viewModel;

  // const SchedulePage({super.key, required this.viewModel});
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ScheduleCard());
  }
}
