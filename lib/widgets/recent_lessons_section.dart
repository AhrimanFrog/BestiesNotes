import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';

class RecentLessonsSection extends StatelessWidget {
  final List<Lesson> lessons;
  final VoidCallback? onSeeAll;

  const RecentLessonsSection({
    super.key,
    this.lessons = const [],
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent lessons',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.mainText,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            for (final lesson in lessons.take(3))
              CompactLessonTile(lesson: lesson),
            if (lessons.length > 3) SeeAllRow(onTap: onSeeAll),
          ], // TODO: navigate to lesson history
        ),
      ],
    );
  }
}
