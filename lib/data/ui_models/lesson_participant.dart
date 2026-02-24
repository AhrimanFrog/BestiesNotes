import 'student.dart';

class LessonParticipant {
  final Student student;
  final bool attended;
  final bool isPaid;
  final bool homeworkDone;

  const LessonParticipant({
    required this.student,
    required this.attended,
    required this.isPaid,
    required this.homeworkDone,
  });

  LessonParticipant copyWith({
    Student? student,
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) {
    return LessonParticipant(
      student: student ?? this.student,
      attended: attended ?? this.attended,
      isPaid: isPaid ?? this.isPaid,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }
}
