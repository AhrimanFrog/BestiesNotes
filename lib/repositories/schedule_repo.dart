import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/extensions/db_group_ext.dart';
import 'package:besties_notes/extensions/db_lesson_details_ext.dart';
import 'package:besties_notes/extensions/db_student_ext.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:drift/drift.dart';

class ScheduleRepo {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  // ---------------- LESSONS CRUD -----------------

  Future<List<Lesson>> getLessonsForAWeek() async {
    final dbLessons = await dataProvider.getLessonsForWeek();
    return dbLessons.map((details) => details.toDomain()).toList();
  }

  Future<Lesson> getLesson({required int lessonId}) async {
    return (await dataProvider.getLesson(lessonId)).toDomain();
  }

  Future<int> createOrUpdateLesson(Lesson lesson) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    return dataProvider.createOrUpdateLesson(
      .insert(
        id: lesson.id != null ? Value(lesson.id!) : .absent(),
        topic: lesson.name,
        start: lesson.start,
        durationInMinutes: lesson.duration.inMinutes,
        status: lesson.status,
        createdAt: now,
        updatedAt: now
      )
    );
  }

  Future<void> cancelLesson(int lessonId) async {
    final dbDetails = await dataProvider.getLesson(lessonId);
    final dbLesson = dbDetails.lesson;
    final now = DateTime.now().millisecondsSinceEpoch;
    await dataProvider.createOrUpdateLesson(
      .insert(
        id: Value(dbLesson.id),
        topic: dbLesson.topic,
        start: dbLesson.start,
        durationInMinutes: dbLesson.durationInMinutes,
        note: Value(dbLesson.note),
        status: LessonStatus.cancelled,
        createdAt: dbLesson.createdAt,
        updatedAt: now,
      )
    );
  }

  // ---------------- STUDENTS CRUD ----------------

  Future<int> createOrUpdateStudent(Student student) {
    return dataProvider.createOrUpdateStudent(
      .insert(
        id: student.id != null ? Value(student.id!) : .absent(),
        name: student.name,
        contact: student.contact,
        payRate: student.pricing.rate,
        period: student.pricing.period,
        notes: student.note,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch
      )
     );
  }

  Future<void> deleteStudent(int studentId) {
    return dataProvider.deleteStudent(studentId);
  }

  Future<List<Student>> getStudents({int offset = 0, limit = 100}) async {
    final dbStudents = await dataProvider.getStudents(
      offset: offset, limit: limit
    );
    return dbStudents.map((s) => s.toDomain()).toList();
  }

  Future<List<Group>> getGroups({int offset = 0, limit = 100}) async {
    final dbGroups = await dataProvider.getGroups(offset: offset, limit: limit);
    return dbGroups.map((g) => g.toDomain()).toList();
  }
}