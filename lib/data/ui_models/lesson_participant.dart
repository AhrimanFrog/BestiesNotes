import 'package:equatable/equatable.dart';

import 'student.dart';
import 'group.dart';

class LessonParticipant extends Equatable {
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

  @override
  String toString() => group?.name ?? student.name;

  @override
  List<Object?> get props => [student, attended, isPaid, homeworkDone, group];

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
