import 'dart:io';

import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/backup_service.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory dir;
  late DbClient db;
  const rate = Rate(rate: 10, period: RatePeriod.perLesson);

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('besties_backup_test');
    db = DbClient(NativeDatabase.memory());
    await db.createOrUpdateStudent(
      const Student(name: 'Anna', contact: '', pricing: rate),
    );
    await db.createOrUpdateLesson(
      Lesson(
        name: 'Grammar',
        start: DateTime(2025, 1, 6),
        duration: const Duration(hours: 1),
      ),
    );
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  group('settings storage', () {
    test('saves, overwrites and loads key/value pairs', () async {
      await db.saveSettings({'currency': 'UAH', 'week_start': '1'});
      await db.saveSettings({'week_start': '7'});
      expect(await db.loadSettings(), {'currency': 'UAH', 'week_start': '7'});
    });
  });

  group('export & inspect', () {
    test('a fresh export inspects as a valid backup', () async {
      final file = await BackupService.create(db, dir);
      final summary = BackupService.inspect(
        file,
        currentVersion: db.schemaVersion,
      );
      expect(summary.schemaVersion, db.schemaVersion);
      expect(summary.students, 1);
      expect(summary.lessons, 1);
    });

    test('a random file is rejected', () {
      final file = File('${dir.path}/notes.txt')
        ..writeAsStringSync('not a database at all');
      expect(
        () => BackupService.inspect(file, currentVersion: 7),
        throwsA(
          isA<BackupException>().having(
            (e) => e.problem,
            'problem',
            BackupProblem.notABackup,
          ),
        ),
      );
    });

    test('an unrelated SQLite database is rejected', () {
      final path = '${dir.path}/other.sqlite';
      sqlite3.open(path)
        ..execute('CREATE TABLE things (id INTEGER)')
        ..close();
      expect(
        () => BackupService.inspect(File(path), currentVersion: 7),
        throwsA(
          isA<BackupException>().having(
            (e) => e.problem,
            'problem',
            BackupProblem.notABackup,
          ),
        ),
      );
    });

    test('a backup from a newer app version is rejected', () async {
      final file = await BackupService.create(db, dir);
      sqlite3.open(file.path)
        ..userVersion = db.schemaVersion + 1
        ..close();
      expect(
        () => BackupService.inspect(file, currentVersion: db.schemaVersion),
        throwsA(
          isA<BackupException>().having(
            (e) => e.problem,
            'problem',
            BackupProblem.tooNew,
          ),
        ),
      );
    });

    test('inspecting does not modify the file', () async {
      final file = await BackupService.create(db, dir);
      final before = file.readAsBytesSync();
      BackupService.inspect(file, currentVersion: db.schemaVersion);
      expect(file.readAsBytesSync(), before);
    });
  });

  test('clearAllRecords empties the data but keeps settings', () async {
    await db.saveSettings({'currency': 'EUR'});
    await db.clearAllRecords();
    expect(await db.getStudents(), isEmpty);
    expect(
      await db.getLessonsForRange(DateTime(2000), DateTime(2100)),
      isEmpty,
    );
    expect(await db.loadSettings(), {'currency': 'EUR'});
  });
}
