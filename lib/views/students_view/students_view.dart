import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/widgets/cards/student_card.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: BlocBuilder<StudentsAndGroupsCubit, StudentsAndGroupsState>(
        builder: (context, state) {
          return SafeArea(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                for (final student in state.students)
                  StudentCard(student: student),
              ],
            ),
          );
        },
      ),
    );
  }
}
