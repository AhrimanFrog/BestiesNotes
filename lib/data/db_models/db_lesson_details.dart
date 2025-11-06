import 'package:besties_notes/providers/db_provider.dart';

class DbLessonDetails {
  final DbLesson lesson;
  final Map<int, DbStudent> students = {};

  DbLessonDetails({required this.lesson});
}
