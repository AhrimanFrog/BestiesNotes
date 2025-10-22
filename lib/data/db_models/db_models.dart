import 'package:drift/drift.dart';
import 'package:besties_notes/data/ui_models/rate.dart';

class DbGroup extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class DbStudents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get pricing => real()();
  TextColumn get period => textEnum<RatePeriod>()();
  IntColumn get groupId => integer().nullable()();
}

class DbLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get start => dateTime()();
  IntColumn get durationInMinutes => integer()();
}

class DbStudentsLessons extends Table {
  // many-to-many rlations table of Lessons and Students
  IntColumn get studentId =>
      integer().references(DbStudents, #id, onDelete: KeyAction.cascade)();
  IntColumn get lessonId =>
      integer().references(DbLessons, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {lessonId, studentId};
}

class DbLessonNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  IntColumn get lessonId =>
      integer().references(DbLessons, #id, onDelete: KeyAction.cascade)();
}
