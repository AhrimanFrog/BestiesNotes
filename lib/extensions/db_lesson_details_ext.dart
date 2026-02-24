import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/lesson_participant.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';
import 'db_group_ext.dart';
import 'db_student_ext.dart';

extension DbLessonDetailsExt on DbLessonDetails {
  Lesson toDomain() {
    final List<Teachable> subjects = [];
    subjects.addAll(students.values.map((s) => s.toDomain()));
    subjects.addAll(groups.values.map((g) => g.toDomain()));

    final lessonParticipants = students.values.map((s) {
      final status = participantStatus[s.id];
      return LessonParticipant(
        student: s.toDomain(),
        attended: status?.attended ?? false,
        isPaid: status?.isPaid ?? false,
        homeworkDone: status?.homeworkDone ?? false,
      );
    }).toList();

    return Lesson(
      id: lesson.id,
      name: lesson.topic,
      subjects: subjects,
      participants: lessonParticipants,
      start: lesson.start,
      duration: Duration(minutes: lesson.durationInMinutes),
      note: lesson.note ?? "",
      status: lesson.status,
    );
  }
}
