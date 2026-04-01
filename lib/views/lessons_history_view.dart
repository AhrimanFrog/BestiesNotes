import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/widgets/sections/lessons_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsHistoryView extends StatelessWidget {
  const LessonsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (_, state) => LessonsListSection(state: state),
      ),
    );
  }
}
