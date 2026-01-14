import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/views/modals/student_form.dart';
import 'package:besties_notes/widgets/cards/student_card.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  final double inset = 2;

  const StudentsPage({super.key});

  void _showDeleteConfirmation(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (student.id != null) {
                final cubit = context.read<StudentsAndGroupsCubit>();
                cubit.deleteStudent(student.id!);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.settings), onPressed: () => {}),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<StudentsAndGroupsCubit>(),
                  child: StudentForm(),
                ),
                backgroundColor: Colors.transparent,
                useSafeArea: true,
                isScrollControlled: true,
              ),
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: BlocBuilder<StudentsAndGroupsCubit, StudentsAndGroupsState>(
          builder: (context, state) {
            return SafeArea(
              minimum: .all(inset),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: inset,
                crossAxisSpacing: inset,
                childAspectRatio: 0.75,
                children: [
                  for (final student in state.students)
                    StudentCard(
                      student: student,
                      onDelete: () => _showDeleteConfirmation(context, student),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
