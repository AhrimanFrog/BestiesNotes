import 'package:equatable/equatable.dart';

import 'lesson.dart';
import 'teachable.dart';

/// The editable fields of a lesson while it's being created or changed.
/// Value equality makes "unsaved changes" a plain comparison.
class LessonDraft extends Equatable {
  final String topic;
  final DateTime start;
  final int durationMinutes;
  final List<Teachable> subjects;

  const LessonDraft({
    required this.topic,
    required this.start,
    required this.durationMinutes,
    this.subjects = const [],
  });

  factory LessonDraft.fromLesson(Lesson lesson) => LessonDraft(
    topic: lesson.name,
    start: lesson.start,
    durationMinutes: lesson.duration.inMinutes,
    subjects: lesson.subjects,
  );

  /// A blank lesson on [date]. Today starts at the next full hour; other days
  /// at a typical 10:00.
  factory LessonDraft.blank({DateTime? date, int durationMinutes = 60}) {
    final now = DateTime.now();
    final day = date ?? now;
    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    final hour = isToday ? (now.hour + 1).clamp(0, 23) : 10;
    return LessonDraft(
      topic: '',
      start: DateTime(day.year, day.month, day.day, hour),
      durationMinutes: durationMinutes,
    );
  }

  bool get isValid =>
      topic.trim().isNotEmpty && durationMinutes > 0 && subjects.isNotEmpty;

  /// Applies this draft on top of [base] (keeps id and cancellation).
  Lesson toLesson({Lesson? base}) => Lesson(
    id: base?.id,
    name: topic.trim(),
    start: start,
    duration: Duration(minutes: durationMinutes),
    isCancelled: base?.isCancelled ?? false,
  );

  LessonDraft copyWith({
    String? topic,
    DateTime? start,
    int? durationMinutes,
    List<Teachable>? subjects,
  }) {
    return LessonDraft(
      topic: topic ?? this.topic,
      start: start ?? this.start,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [
    topic,
    start,
    durationMinutes,
    // Order of selection doesn't make a draft different.
    {...subjects},
  ];
}
