import 'package:besties_notes/data/ui_models/lesson.dart';
import 'package:besties_notes/data/ui_models/lesson_participant.dart';
import 'package:besties_notes/data/ui_models/teachable.dart';

class RecurringTemplate {
  final int? id;
  final String name;
  /// ISO weekday: 1 = Monday … 7 = Sunday (matches DateTime.weekday).
  final int dayOfWeek;
  final int startHour;
  final int startMinute;
  final Duration duration;
  final String note;
  final DateTime startDate;
  final DateTime? endDate;
  /// Pre-resolved participants (students expanded from groups) for virtual lesson generation.
  final List<LessonParticipant> participants;

  const RecurringTemplate({
    this.id,
    required this.name,
    required this.dayOfWeek,
    required this.startHour,
    required this.startMinute,
    required this.duration,
    this.note = '',
    required this.startDate,
    this.endDate,
    this.participants = const [],
  });

  List<Teachable> get subjects => participants
      .map((p) => p.group == null ? (p.student as Teachable) : p.group!)
      .toSet()
      .toList();

  /// All occurrence start times within [from, to] inclusive.
  List<DateTime> occurrencesInRange(DateTime from, DateTime to) {
    final result = <DateTime>[];
    var current = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    while (!current.isAfter(end)) {
      if (current.weekday == dayOfWeek) {
        final occurrence = DateTime(
          current.year, current.month, current.day, startHour, startMinute,
        );
        final afterStart = !occurrence.isBefore(startDate);
        final beforeEnd = endDate == null || !occurrence.isAfter(endDate!);
        if (afterStart && beforeEnd) result.add(occurrence);
      }
      current = current.add(const Duration(days: 1));
    }
    return result;
  }

  /// Generates a virtual (not-yet-persisted) Lesson for a given occurrence date.
  Lesson toVirtualLesson(DateTime occurrenceStart) {
    return Lesson(
      name: name,
      start: occurrenceStart,
      duration: duration,
      note: note,
      templateId: id,
      isVirtual: true,
      participants: participants.map((p) => p.copyWith(
        attended: false,
        isPaid: false,
        homeworkDone: false,
      )).toList(),
    );
  }

  RecurringTemplate copyWith({
    int? id,
    String? name,
    int? dayOfWeek,
    int? startHour,
    int? startMinute,
    Duration? duration,
    String? note,
    DateTime? startDate,
    DateTime? endDate,
    List<LessonParticipant>? participants,
  }) {
    return RecurringTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      duration: duration ?? this.duration,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      participants: participants ?? this.participants,
    );
  }
}
