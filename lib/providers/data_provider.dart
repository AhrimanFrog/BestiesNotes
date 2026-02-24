import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';

abstract class DataProvider {
  Future<List<Lesson>> getLessonsForRange(DateTime from, DateTime to);

  Future<Lesson> getLesson(int lessonId);

  Future<int> createOrUpdateLesson(Lesson lesson);

  Future<int> createOrUpdateStudent(Student student);

  Future<void> deleteStudent(int studentId);

  Future<List<Student>> getStudents({int offset = 0, int limit = 100});

  Future<List<Group>> getGroups({int offset = 0, int limit = 100});

  Future<int> createOrUpdateGroup(Group group);

  Future<void> deleteGroup(int groupId);

  Future<List<Student>> getGroupMembers(int groupId);

  Future<void> syncGroupMemberships(int groupId, Iterable<int> studentIds);

  Future<void> syncLessonMembership(int lessonId, List<Teachable> subjects);

  Future<void> updateLessonStatus(int lessonId, LessonStatus status);

  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  });
}
