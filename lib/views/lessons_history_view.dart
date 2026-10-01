import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/widgets/sections/lessons_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsHistoryView extends StatelessWidget {
  const LessonsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson history')),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) => LessonsListSection(
          state: state,
          onLessonTap: (lesson) async {
            await context.openLesson(lesson.id!);
            if (context.mounted) context.read<LessonsCubit>().refresh();
          },
        ),
      ),
    );
  }
}
