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

  LessonParticipant copyWith({Student? student, bool? attended, bool? isPaid}) {
    return LessonParticipant(
      student: student ?? this.student,
      attended: attended ?? this.attended,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
