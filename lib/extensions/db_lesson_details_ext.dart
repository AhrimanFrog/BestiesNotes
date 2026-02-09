import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'db_group_ext.dart';
import 'db_student_ext.dart';

extension DbLessonDetailsExt on DbLessonDetails {
  Lesson toDomain() {
    final List<Teachable> participants = [];
    participants.addAll(students.values.map((s) => s.toDomain()));
    participants.addAll(groups.values.map((g) => g.toDomain()));
    return Lesson(
      id: lesson.id,
      name: lesson.topic,
      subjects: participants.toList(),
      start: lesson.start,
      duration: Duration(minutes: lesson.durationInMinutes),
      note: lesson.note ?? "",
      status: lesson.status,
    );
  }
}
