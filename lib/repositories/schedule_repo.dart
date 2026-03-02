import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class ScheduleRepo {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  // ---------------- LESSONS CRUD -----------------

  Future<List<Lesson>> getLessonsForRange(DateTime from, DateTime to) =>
      dataProvider.getLessonsForRange(from, to);

  Future<List<Lesson>> getLessonsForStudent(int studentId) =>
      dataProvider.getLessonsForStudent(studentId);

  Future<Lesson> getLesson({required int lessonId}) =>
      dataProvider.getLesson(lessonId);

  Future<int> createOrUpdateLesson(Lesson lesson) async {
    final lessonId = await dataProvider.createOrUpdateLesson(lesson);
    await dataProvider.syncLessonMembership(lessonId, lesson.subjects);
    return lessonId;
  }

  Future<void> cancelLesson(int lessonId) =>
      dataProvider.updateLessonStatus(lessonId, .cancelled);

  Future<void> updateParticipantStatus(
    int lessonId,
    int studentId, {
    bool? attended,
    bool? isPaid,
    bool? homeworkDone,
  }) => dataProvider.updateParticipantStatus(
    lessonId,
    studentId,
    attended: attended,
    isPaid: isPaid,
    homeworkDone: homeworkDone,
  );

  // ---------------- STUDENTS CRUD ----------------

  Future<int> createOrUpdateStudent(Student student) =>
      dataProvider.createOrUpdateStudent(student);

  Future<void> deleteStudent(int studentId) =>
      dataProvider.deleteStudent(studentId);

  Future<List<Student>> getStudents({int offset = 0, int limit = 100}) =>
      dataProvider.getStudents(offset: offset, limit: limit);

  Future<List<Group>> getGroups({int offset = 0, int limit = 100}) =>
      dataProvider.getGroups(offset: offset, limit: limit);

  // ---------------- GROUPS CRUD -----------------

  Future<int> createOrUpdateGroup(Group group) =>
      dataProvider.createOrUpdateGroup(group);

  Future<void> deleteGroup(int groupId) => dataProvider.deleteGroup(groupId);

  Future<void> syncGroupMemberships(int groupId, Iterable<int> studentIds) =>
      dataProvider.syncGroupMemberships(groupId, studentIds);

  Future<Set<Student>> getGroupMembers(int groupId) async {
    final dbStudents = await dataProvider.getGroupMembers(groupId);
    return dbStudents.toSet();
  }
}
