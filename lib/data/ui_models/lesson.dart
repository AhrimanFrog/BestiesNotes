import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class Lesson {
  final int? id;
  final String name;
  final List<LessonParticipant> participants;
  final DateTime start;
  final Duration duration;
  final String note;
  final LessonStatus status;

  const Lesson({
    this.id,
    required this.name,
    this.participants = const [],
    required this.start,
    required this.duration,
    this.note = "",
    this.status = LessonStatus.scheduled,
  });

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));

  bool get isCancelled => status == LessonStatus.cancelled;

  DateTime get end => start.add(duration);

  List<Teachable> get subjects {
    return participants
        .map((p) => p.group == null ? p.student : p.group!)
        .toSet()
        .toList();
  }

  Lesson copyWith({
    int? id,
    String? name,
    List<LessonParticipant>? participants,
    DateTime? start,
    Duration? duration,
    String? note,
    LessonStatus? status,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }
}
