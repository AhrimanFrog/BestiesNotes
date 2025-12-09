import 'package:besties_notes/extensions/db_group_ext.dart';
import 'package:besties_notes/extensions/db_student_ext.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/data/ui_models/index.dart';

class ScheduleRepo {
  late final DataProvider dataProvider;

  ScheduleRepo({required this.dataProvider});

  Future<List<Lesson>> getLessonsForAWeek() async {
    final dbLessons = await dataProvider.getLessonsForWeek();
    return dbLessons.map((details) {
      final List<Teachable> participants = [];
      participants.addAll(details.students.values.map((s) => s.toDomain()));
      participants.addAll(details.groups.values.map((g) => g.toDomain()));
      return Lesson(
        name: details.lesson.topic,
        subjects: participants.toList(),
        start: details.lesson.start,
        duration: Duration(minutes: details.lesson.durationInMinutes),
        note: details.lesson.note ?? "",
      );
    }).toList();
  }

  Future<int> createOrUpdateStudent(Student student) {
    return dataProvider.createOrUpdateStudent(
      .insert(
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