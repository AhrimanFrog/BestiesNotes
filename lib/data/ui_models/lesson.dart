import 'package:besties_notes/data/ui_models/index.dart';
import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final int? id;
  final String name;
  final List<LessonParticipant> participants;
  final DateTime start;
  final Duration duration;
  final String note;
  final bool isCancelled;

  const Lesson({
    this.id,
    required this.name,
    this.participants = const [],
    required this.start,
    required this.duration,
    this.note = "",
    this.isCancelled = false,
  });

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));

  bool get isCompleted => DateTime.now().isAfter(end);

  bool get isCancellable => !(isCancelled || isCompleted);

  DateTime get end => start.add(duration);

  List<Teachable> get subjects {
    return participants
        .map((p) => p.group == null ? p.student : p.group!)
        .toSet()
        .toList();
  }

  String audienceLabel() {
    if (participants.isEmpty) return 'No one assigned';
    final rest = participants.length - 1;
    return rest > 0
        ? '${participants.first} +$rest'
        : participants.first.toString();
  }

  Lesson copyWith({
    int? id,
    String? name,
    List<LessonParticipant>? participants,
    DateTime? start,
    Duration? duration,
    String? note,
    bool? isCancelled,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      start: start ?? this.start,
      duration: duration ?? this.duration,
      note: note ?? this.note,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    participants,
    start,
    duration,
    note,
    isCancelled,
  ];
}
