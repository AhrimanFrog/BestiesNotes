import 'db_provider.dart';

abstract class DataProvider {
  Future<Map<DbLesson, List<DbLessonNote>>> getLessonsForWeek() async {
    throw UnimplementedError();
  } 
}
