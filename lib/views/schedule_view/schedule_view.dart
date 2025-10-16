import 'schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:besties_notes/widgets/white_box.dart';

class SchedulePage extends StatelessWidget {
  final ScheduleViewModel viewModel;

  const SchedulePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return WhiteBox(
      child: SafeArea(child: Table(children: [],)),
    );
  }
}
