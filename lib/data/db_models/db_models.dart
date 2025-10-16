import 'package:drift/drift.dart';
import 'package:besties_notes/data/ui_models/rate.dart';

class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get pricing => real()();
  TextColumn get period => textEnum<RatePeriod>()();
}

class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get start => dateTime()();
  IntColumn get durationInMinutes => integer()();
}

class StudentsLessons extends Table {
  // many-to-many rlations table of Lessons and Students
  IntColumn get studentId =>
      integer().references(Students, #id, onDelete: KeyAction.cascade)();
  IntColumn get lessonId =>
      integer().references(Lessons, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {lessonId, studentId};
}

class RoadmapNodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isPaid => boolean()();
  BoolColumn get isHomeworkDone => boolean()();
  IntColumn get studentId => integer().references(Students, #id)();
}
