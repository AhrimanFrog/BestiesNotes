import 'package:besties_notes/data/db_models/db_lesson_details.dart';
import 'package:besties_notes/providers/db_client.dart';

abstract class DataProvider {
  Future<List<DbLessonDetails>> getLessonsForWeek() async {
    throw UnimplementedError();
  }

  Future<int> createOrUpdateStudent(DbStudentsCompanion student);

  Future<List<DbStudent>> getStudents({int offset = 0, int limit = 100});

  Future<List<DbGroup>> getGroups({int offset = 0, int limit = 100});
}
