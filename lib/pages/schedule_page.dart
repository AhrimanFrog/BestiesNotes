import 'package:flutter/material.dart';
import 'package:besties_notes/widgets/white_box.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<StatefulWidget> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return WhiteBox(
      child: SafeArea(child: Table(children: [
        
      ],
    )),
    );
  }
}
