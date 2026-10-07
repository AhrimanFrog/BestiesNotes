import 'package:equatable/equatable.dart';

import 'rate.dart';
import 'student.dart';

/// One student's place in one billable lesson (started, not cancelled):
/// the raw material of every earnings figure.
class Participation extends Equatable {
  final int lessonId;
  final String lessonName;
  final DateTime start;
  final Student student;

  /// Set when the student came with a group (and is billed the group's rate).
  final int? groupId;

  /// The rate this lesson was priced at for this student.
  final Rate rate;
  final bool isPaid;

  const Participation({
    required this.lessonId,
    this.lessonName = '',
    required this.start,
    required this.student,
    required this.rate,
    required this.isPaid,
    this.groupId,
  });

  Participation copyWith({bool? isPaid}) => Participation(
    lessonId: lessonId,
    lessonName: lessonName,
    start: start,
    student: student,
    groupId: groupId,
    rate: rate,
    isPaid: isPaid ?? this.isPaid,
  );

  @override
  List<Object?> get props => [
    lessonId,
    lessonName,
    start,
    student,
    groupId,
    rate,
    isPaid,
  ];
}
