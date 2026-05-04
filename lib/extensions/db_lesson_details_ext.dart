import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/lesson_participant.dart';
import 'db_group_ext.dart';
import 'db_student_ext.dart';

extension DbLessonDetailsExt on DbLessonDetails {
  Lesson toDomain() {
    final lessonParticipants = students.values.map((s) {
      final status = participantStatus[s.id];
      final groupId = status?.groupId;
      return LessonParticipant(
        student: s.toDomain(),
        attended: status?.attended ?? false,
        isPaid: status?.isPaid ?? false,
        homeworkDone: status?.homeworkDone ?? false,
        group: groups[groupId]?.toDomain(),
      );
    }).toList();

    return Lesson(
      id: lesson.id,
      name: lesson.topic,
      participants: lessonParticipants,
      start: lesson.start,
      duration: Duration(minutes: lesson.durationInMinutes),
      note: lesson.note ?? "",
      isCancelled: lesson.isCancelled,
    );
  }
}
