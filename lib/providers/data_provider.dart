import 'package:besties_notes/data/db_models/db_lesson_details.dart';

abstract class DataProvider {
  Future<List<DbLessonDetails>> getLessonsForWeek() async {
    throw UnimplementedError();
  }
}
