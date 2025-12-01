import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/views/students_view/students_view_model.dart';
import 'package:besties_notes/widgets/cards/student_card.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentsPage extends ConsumerWidget {
  final List<Student> students;

  const StudentsPage({super.key, required this.students});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(studentViewModelProvider);

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
