import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/cards/student_card.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  final List<Student> students;

  const StudentsPage({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            for (final student in students) StudentCard(student: student),
          ],
        ),
      ),
    );
  }
}
