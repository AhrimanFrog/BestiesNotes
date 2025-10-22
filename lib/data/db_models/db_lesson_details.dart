import 'package:besties_notes/providers/db_provider.dart';

class DbLessonDetails {
  final DbLesson lesson;
  final Map<int, DbStudent> students = {};
  final Map<int, DbLessonNote> notes = {};

  DbLessonDetails({required this.lesson});
}
