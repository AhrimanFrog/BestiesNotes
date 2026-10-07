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

class DbLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  DateTimeColumn get start => dateTime()();
  IntColumn get durationInMinutes => integer()();
  TextColumn get note => text().nullable()();
  BoolColumn get isCancelled => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// App preferences as key/value pairs. Kept in the database (rather than
/// platform preferences) so backups carry them.
class DbSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
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

  /// The price of this lesson for this student: the group's rate when they
  /// came with a group, their own otherwise. Copied when the lesson starts
  /// being billed, so later rate changes don't re-price history.
  RealColumn get payRate => real().withDefault(const Constant(0))();
  TextColumn get period =>
      textEnum<RatePeriod>().withDefault(Constant(RatePeriod.perLesson.name))();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {lessonId, studentId},
  ];
}
