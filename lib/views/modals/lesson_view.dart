import 'package:flutter/material.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/widgets/index.dart'
    show PersonRow, TimeRow, NoteRow, ModalHeaderRow;

class LessonView extends StatelessWidget {
  final Lesson lesson;

  const LessonView({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.softWarmPink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ModalHeaderRow(
            title: lesson.name,
            icon: Icons.business_center_outlined,
          ),
          const SizedBox(height: 28),
          PersonRow(subject: lesson.subjects.first),
          const SizedBox(height: 28),
          TimeRow(start: lesson.start, end: lesson.end),
          const SizedBox(height: 28),
          NoteRow(note: "Something important"),
        ],
      ),
    );
  }
}
