import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class Lesson {
  final int? id;
  final String name;
  final List<Teachable> subjects;
  final List<LessonParticipant> participants;
  final DateTime start;
  final Duration duration;
  final String note;
  final LessonStatus status;

  const Lesson({
    this.id,
    required this.name,
    required this.subjects,
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

  Lesson copyWith({
    int? id,
    String? name,
    List<Teachable>? subjects,
    List<LessonParticipant>? participants,
    DateTime? start,
    Duration? duration,
    String? note,
    LessonStatus? status,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
      participants: participants ?? this.participants,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  Lesson.demoActive()
    : id = null,
      name = "Present simple",
      subjects = [Student.demo()],
      participants = const [],
      start = DateTime.now(),
      duration = Duration(minutes: 70),
      note = "Just text",
      status = LessonStatus.scheduled;

  Lesson.demoNonActive()
    : id = null,
      name = "Present huimple",
      subjects = [Student.demo()],
      participants = const [],
      start = DateTime.now().add(Duration(days: 2, minutes: 70)),
      duration = Duration(minutes: 60),
      note = "Some note here",
      status = LessonStatus.scheduled;
}
