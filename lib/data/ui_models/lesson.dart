import 'package:besties_notes/data/ui_models/index.dart';


class Lesson<T extends Teachable> {
  final String name;
  final T subject;
  final DateTime start;
  final Duration duration;

  const Lesson({
    required this.name,
    required this.subject,
    required this.start,
    required this.duration,
  });

  Lesson.demoActive()
  : name = "Present simple"
  , subject = Student.demo() as T
  , start = DateTime.now()
  , duration = Duration(minutes: 70);

    Lesson.demoNonActive()
  : name = "Present simple"
  , subject = Student.demo() as T
  , start = DateTime.now().add(Duration(minutes: 70))
  , duration = Duration(minutes: 60);

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));

  DateTime get end => start.add(duration);
}
