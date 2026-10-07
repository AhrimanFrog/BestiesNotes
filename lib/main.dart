import 'dart:io';

import 'package:besties_notes/cubits/settings/settings_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/providers/settings_provider.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();

  // Read settings before the first frame: language and week start apply
  // from the start instead of flickering in.
  final db = DbClient();
  final settings = AppSettings.fromMap(await db.loadSettings());

  runApp(BestiesApp(db: db, settings: settings));
}

/// App-level operations that replace the data underneath every screen.
abstract class AppSession {
  DbClient get db;

  /// Replaces the database with [backup] and restarts on the restored data.
  Future<void> restore(File backup);

  /// Rebuilds every screen from the database, e.g. after clearing it.
  Future<void> reload();
}

class BestiesApp extends StatefulWidget {
  final DbClient db;
  final AppSettings settings;

  /// Where the database file lives. Overridable for tests.
  final Future<File> Function() databaseFile;

  /// Opens the database at its file. Overridable for tests.
  final DbClient Function() openDatabase;

  const BestiesApp({
    super.key,
    required this.db,
    this.settings = const AppSettings(),
    this.databaseFile = DbClient.databaseFile,
    this.openDatabase = DbClient.new,
  });

  @override
  State<BestiesApp> createState() => _BestiesAppState();
}

class _BestiesAppState extends State<BestiesApp> implements AppSession {
  @override
  late DbClient db = widget.db;
  late AppSettings _settings = widget.settings;

  /// Bumped to rebuild the whole tree (and every cubit) from scratch.
  int _generation = 0;

  @override
  Future<void> restore(File backup) async {
    final target = await widget.databaseFile();
    await db.close();
    try {
      // Stale journal files would be replayed onto the restored data.
      for (final suffix in ['-wal', '-shm', '-journal']) {
        final journal = File('${target.path}$suffix');
        if (journal.existsSync()) journal.deleteSync();
      }
      await backup.copy(target.path);
    } finally {
      // Reopen whatever is in place now; migrations upgrade older backups.
      db = widget.openDatabase();
    }
    await reload();
  }

  @override
  Future<void> reload() async {
    final settings = AppSettings.fromMap(await db.loadSettings());
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _generation++;
    });
    router.go('/schedule');
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(_generation),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AppSession>.value(value: this),
          RepositoryProvider<DataProvider>.value(value: db),
          RepositoryProvider<PaymentProvider>.value(value: db),
          RepositoryProvider<SettingsProvider>.value(value: db),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SettingsCubit(db, _settings)),
            // App-wide: the students tab and every lesson's subject picker
            // use it. Not lazy, so the lists are ready before anything asks.
            BlocProvider(
              lazy: false,
              create: (_) => StudentsAndGroupsCubit(db, db)
                ..fetchStudents()
                ..fetchGroups(),
            ),
          ],
          child: BlocSelector<SettingsCubit, AppSettings, Locale?>(
            selector: (s) => s.locale,
            builder: (context, locale) => MaterialApp.router(
              onGenerateTitle: (context) => context.l10n.appTitle,
              theme: buildLightTheme(),
              // Null follows the system language (English if unsupported).
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: syncIntlLocale,
              routerConfig: router,
            ),
          ),
        ),
      ),
    );
  }
}

/// The bundled fonts are OFL-licensed, which requires shipping the license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Yeseva One', 'assets/fonts/OFL-YesevaOne.txt'),
      ('Nunito', 'assets/fonts/OFL-Nunito.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(file));
    }
  });
}
