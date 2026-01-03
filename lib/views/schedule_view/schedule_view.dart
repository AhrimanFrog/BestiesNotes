// import 'schedule_view_model.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {
              // TODO: Implement add lesson functionality
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: ListView(
          children: [
            for (final ls in [Lesson.demoActive(), Lesson.demoNonActive()])
              ScheduleCard(date: ls.start, lessons: [ls]),
          ],
        ),
      ),
    );
  }
}
