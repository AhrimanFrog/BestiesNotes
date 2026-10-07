// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v7.dart' as v7;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = DbClient(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'v7 → v8 prices existing lessons at the rates they were billed',
    () async {
      final schema = await verifier.schemaAt(7);
      final old = v7.DatabaseAtV7(schema.newConnection());
      await old.batch((b) {
        b.insert(
          old.dbGroups,
          v7.DbGroupsCompanion.insert(
            id: const Value(1),
            name: 'Club',
            payRate: 7,
            period: 'perLesson',
            createdAt: 0,
            updatedAt: 0,
          ),
        );
        b.insert(
          old.dbStudents,
          v7.DbStudentsCompanion.insert(
            id: const Value(1),
            name: 'Anna',
            contact: '',
            payRate: 100,
            period: 'monthly',
            notes: '',
            groupId: const Value(1),
            createdAt: 0,
            updatedAt: 0,
          ),
        );
        for (final id in [1, 2]) {
          b.insert(
            old.dbLessons,
            v7.DbLessonsCompanion.insert(
              id: Value(id),
              topic: 'Talk',
              start: 1735725600 + id * 86400,
              durationInMinutes: 60,
              isCancelled: 0,
              createdAt: 0,
              updatedAt: 0,
            ),
          );
        }
        // Lesson 1 alone, lesson 2 with the group.
        b.insert(
          old.dbLessonParticipants,
          v7.DbLessonParticipantsCompanion.insert(
            lessonId: 1,
            studentId: 1,
            isPaid: 0,
            attended: 1,
          ),
        );
        b.insert(
          old.dbLessonParticipants,
          v7.DbLessonParticipantsCompanion.insert(
            lessonId: 2,
            studentId: 1,
            isPaid: 1,
            attended: 1,
            groupId: const Value(1),
          ),
        );
      });
      await old.close();

      final db = DbClient(schema.newConnection());
      await verifier.migrateAndValidate(db, 8);
      final rows = {
        for (final p in await db.select(db.dbLessonParticipants).get())
          p.lessonId: (p.payRate, p.period.name, p.isPaid),
      };
      expect(rows, {1: (100.0, 'monthly', false), 2: (7.0, 'perLesson', true)});
      await db.close();
    },
  );
}
