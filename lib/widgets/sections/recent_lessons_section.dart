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
    return TitledSection(
      title: 'Recent lessons',
      child: Column(
        children: [
          for (final lesson in lessons.take(3))
            CompactLessonTile(lesson: lesson),
          if (lessons.length > 3) SeeAllRow(onTap: onSeeAll),
        ],
      ),
    );
  }
}
