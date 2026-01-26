// import 'schedule_view_model.dart';
import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/views/modals/lesson_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

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
                  value: context.read<LessonsCubit>(),
                  child: LessonForm(null),
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
        child: BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            return ListView(
              children: [
                for (final entry in state.getLessonsByDate().entries)
                  ScheduleCard(date: entry.key, lessons: entry.value),
              ],
            );
          },
        ),
      ),
    );
  }
}
