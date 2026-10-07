import 'dart:io';

import 'package:besties_notes/providers/db_client.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

enum BackupProblem {
  /// Not an SQLite file, or missing the app's tables.
  notABackup,

  /// Made by a newer version of the app than this one.
  tooNew,
}

class BackupException implements Exception {
  final BackupProblem problem;

  const BackupException(this.problem);

  @override
  String toString() => 'BackupException(${problem.name})';
}

/// What a backup file contains, read without modifying it.
class BackupSummary {
  final int schemaVersion;
  final int students;
  final int lessons;

  const BackupSummary({
    required this.schemaVersion,
    required this.students,
    required this.lessons,
  });
}

/// Creating and checking backups. A backup is simply a compacted copy of
/// the database file, so restoring it is a file swap (see `AppSession`).
abstract final class BackupService {
  static const _requiredTables = {
    'db_students',
    'db_groups',
    'db_lessons',
    'db_lesson_participants',
  };

  /// Writes a backup of [db] into [directory] and returns the file.
  static Future<File> create(DbClient db, Directory directory) async {
    // A fixed ISO date, independent of locale data: "2026-10-07".
    final stamp = DateTime.now().toIso8601String().substring(0, 10);
    final file = File(p.join(directory.path, 'besties-notes-$stamp.sqlite'));
    await db.exportTo(file);
    return file;
  }

  /// Opens [file] read-only and checks it's a backup this app can restore.
  /// Throws [BackupException] otherwise.
  static BackupSummary inspect(File file, {required int currentVersion}) {
    final Database db;
    try {
      db = sqlite3.open(file.path, mode: OpenMode.readOnly);
    } on SqliteException {
      throw const BackupException(BackupProblem.notABackup);
    }
    try {
      final tables = {
        for (final row in db.select(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        ))
          row['name'] as String,
      };
      if (!tables.containsAll(_requiredTables)) {
        throw const BackupException(BackupProblem.notABackup);
      }
      final version = db.userVersion;
      if (version > currentVersion) {
        throw const BackupException(BackupProblem.tooNew);
      }
      int count(String table) =>
          db.select('SELECT COUNT(*) AS n FROM $table').first['n'] as int;
      return BackupSummary(
        schemaVersion: version,
        students: count('db_students'),
        lessons: count('db_lessons'),
      );
    } on SqliteException {
      // e.g. "file is not a database" surfaces on the first query.
      throw const BackupException(BackupProblem.notABackup);
    } finally {
      db.close();
    }
  }
}
