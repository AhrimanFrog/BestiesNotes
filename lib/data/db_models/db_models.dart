import 'package:drift/drift.dart';
import 'package:besties_notes/data/common.dart';

class DbStudents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get contact => text()();
  TextColumn get email => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  RealColumn get payRate => real()();
  TextColumn get period => textEnum<RatePeriod>()();
  TextColumn get notes => text()();
  IntColumn get groupId => integer()
      .references(DbGroups, #id, onDelete: KeyAction.setNull)
      .nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  RealColumn get payRate => real()();
  TextColumn get period => textEnum<RatePeriod>()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbRecurringTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  /// ISO weekday: 1 = Monday … 7 = Sunday.
  IntColumn get dayOfWeek => integer()();
  /// Minutes from midnight (e.g. 900 = 15:00).
  IntColumn get startTimeMinutes => integer()();
  IntColumn get durationInMinutes => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbRecurringParticipants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId => integer()
      .references(DbRecurringTemplates, #id, onDelete: KeyAction.cascade)();
  IntColumn get studentId =>
      integer().references(DbStudents, #id, onDelete: KeyAction.cascade)();
  IntColumn get groupId => integer()
      .references(DbGroups, #id, onDelete: KeyAction.setNull)
      .nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {templateId, studentId},
  ];
}

class DbLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  DateTimeColumn get start => dateTime()();
  IntColumn get durationInMinutes => integer()();
  TextColumn get note => text().nullable()();
  BoolColumn get isCancelled => boolean()();
  /// Set when this lesson was materialized from a recurring template.
  IntColumn get templateId => integer()
      .references(DbRecurringTemplates, #id, onDelete: KeyAction.setNull)
      .nullable()();
  /// The original scheduled date for this template instance (used to detect existing materializations).
  DateTimeColumn get templateDate => dateTime().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbLessonParticipants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId =>
      integer().references(DbLessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get studentId =>
      integer().references(DbStudents, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isPaid => boolean()();
  BoolColumn get attended => boolean()();
  BoolColumn get homeworkDone => boolean().withDefault(const Constant(false))();
  IntColumn get groupId => integer()
      .references(DbGroups, #id, onDelete: KeyAction.setNull)
      .nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {lessonId, studentId},
  ];
}
