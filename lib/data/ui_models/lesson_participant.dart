import 'student.dart';
import 'group.dart';

class LessonParticipant {
  final Student student;
  final bool attended;
  final bool isPaid;
  final bool homeworkDone;
  final Group? group;

  const LessonParticipant({
    required this.student,
    required this.attended,
    required this.isPaid,
    required this.homeworkDone,
    this.group,
  });

  LessonParticipant copyWith({
    Student? student,
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
    Group? group,
  }) {
    return LessonParticipant(
      student: student ?? this.student,
      attended: attended ?? this.attended,
      isPaid: isPaid ?? this.isPaid,
      homeworkDone: homeworkDone ?? this.homeworkDone,
      group: group ?? this.group,
    );
  }
}
