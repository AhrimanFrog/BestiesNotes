import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class ScheduleRepo {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  // ---------------- LESSONS CRUD -----------------

  Future<List<Lesson>> getLessonsForAWeek() async {
    return await dataProvider.getLessonsForWeek();
  }

  Future<Lesson> getLesson({required int lessonId}) async {
    return await dataProvider.getLesson(lessonId);
  }

  Future<int> createOrUpdateLesson(Lesson lesson) async {
    final lessonId = await dataProvider.createOrUpdateLesson(lesson);
    await dataProvider.syncLessonMembership(lessonId, lesson.subjects);
    return lessonId;
  }

  Future<void> cancelLesson(int lessonId) async {
    await dataProvider.updateLessonStatus(lessonId, .cancelled);
  }

  // ---------------- STUDENTS CRUD ----------------

  Future<int> createOrUpdateStudent(Student student) {
    return dataProvider.createOrUpdateStudent(student);
  }

  Future<void> deleteStudent(int studentId) {
    return dataProvider.deleteStudent(studentId);
  }

  Future<List<Student>> getStudents({int offset = 0, limit = 100}) async {
    final dbStudents = await dataProvider.getStudents(
      offset: offset,
      limit: limit,
    );
    return dbStudents.toList();
  }

  Future<List<Group>> getGroups({int offset = 0, limit = 100}) async {
    final dbGroups = await dataProvider.getGroups(offset: offset, limit: limit);
    return dbGroups.toList();
  }

  // ---------------- GROUPS CRUD -----------------

  Future<int> createOrUpdateGroup(Group group) {
    return dataProvider.createOrUpdateGroup(group);
  }

  Future<void> deleteGroup(int groupId) {
    return dataProvider.deleteGroup(groupId);
  }

  Future<void> syncGroupMemberships(int groupId, List<int> studentIds) {
    return dataProvider.syncGroupMemberships(groupId, studentIds);
  }

  Future<Set<Student>> getGroupMembers(int groupId) async {
    final dbStudents = await dataProvider.getGroupMembers(groupId);
    return dbStudents.toSet();
  }
}
