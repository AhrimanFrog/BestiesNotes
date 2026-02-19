import 'student.dart';

class LessonParticipant {
  final Student student;
  final bool attended;
  final bool isPaid;

  const LessonParticipant({
    required this.student,
    required this.attended,
    required this.isPaid,
  });
}
