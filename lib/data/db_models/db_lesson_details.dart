import 'package:besties_notes/providers/db_client.dart';

class DbLessonDetails {
  final DbLesson lesson;
  final Map<int, DbStudent> students = {};
  final Map<int, DbGroup> groups = {};
  final Map<int, DbLessonParticipant> participantStatus = {};

  DbLessonDetails({required this.lesson});
}
