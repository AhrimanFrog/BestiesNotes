import 'package:besties_notes/data/ui_models/index.dart';

class Lesson<T extends Teachable> {
  final String name;
  final List<T> subjects;
  final DateTime start;
  final Duration duration;
  final List<String> notes;

  const Lesson({
    required this.name,
    required this.subjects,
    required this.start,
    required this.duration,
    this.notes = const [],
  });

  Lesson.demoActive()
    : name = "Present simple",
      subjects = [Student.demo()] as List<T>,
      start = DateTime.now(),
      duration = Duration(minutes: 70),
      notes = ["Nothing interesting", "Just text"];

  Lesson.demoNonActive()
    : name = "Present huimple",
      subjects = [Student.demo()] as List<T>,
      start = DateTime.now().add(Duration(days: 2, minutes: 70)),
      duration = Duration(minutes: 60),
      notes = ["Some note here"];

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));

  DateTime get end => start.add(duration);
}
