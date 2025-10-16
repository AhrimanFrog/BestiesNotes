import 'teachable.dart';

class Lesson<T extends Teachable> {
  final String name;
  final Set<T> students;
  final DateTime start;
  final Duration duration;

  const Lesson({
    required this.name,
    required this.students,
    required this.start,
    required this.duration,
  });

  bool get isNow =>
      DateTime.now().isAfter(start) &&
      DateTime.now().isBefore(start.add(duration));
}
