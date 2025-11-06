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
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get payRate => real()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class GroupMemberships extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId =>
      integer().references(DbGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get studentId =>
      integer().references(DbStudents, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {groupId, studentId}
  ];
}

class DbLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get topic => text()();
  DateTimeColumn get start => dateTime()();
  IntColumn get durationInMinutes => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get status => textEnum<LessonStatus>()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DbLessonParticipants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(DbLessons, #id)();
  IntColumn get studentId => integer().references(DbStudents, #id)();
  BoolColumn get isPaid => boolean()();
  BoolColumn get attended => boolean()();
  IntColumn get groupId => integer().references(DbGroups, #id).nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {lessonId, studentId}
  ];
}
