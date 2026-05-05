import 'package:besties_notes/data/ui_models/index.dart';

class Lesson {
  final int? id;
  final String name;
  final List<LessonParticipant> participants;
  final DateTime start;
  final Duration duration;
  final String note;
  final bool isCancelled;
  /// Non-null when this lesson was generated from a recurring template.
  final int? templateId;
  /// True when this instance is virtual (not yet persisted to DB).
  final bool isVirtual;

  const Lesson({
    this.id,
    required this.name,
    this.participants = const [],
    required this.start,
    required this.duration,
    this.note = "",
    this.isCancelled = false,
    this.templateId,
    this.isVirtual = false,
  });

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));

  bool get isCompleted => DateTime.now().isAfter(end);

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
    bool? isCancelled,
    int? templateId,
    bool? isVirtual,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      note: note ?? this.note,
      isCancelled: isCancelled ?? this.isCancelled,
      templateId: templateId ?? this.templateId,
      isVirtual: isVirtual ?? this.isVirtual,
    );
  }
}
