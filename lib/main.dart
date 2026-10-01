import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();

  runApp(BestiesApp(db: DbClient()));
}

class BestiesApp extends StatelessWidget {
  final DbClient db;

  const BestiesApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DataProvider>.value(value: db),
        RepositoryProvider<PaymentProvider>.value(value: db),
      ],
      // App-wide: the students tab and every lesson's subject picker use it.
      // Not lazy, so the lists are ready before anything asks for them.
      child: BlocProvider(
        lazy: false,
        create: (_) => StudentsAndGroupsCubit(db, db)
          ..fetchStudents()
          ..fetchGroups(),
        child: MaterialApp.router(
          title: 'Besties Notes',
          theme: buildLightTheme(),
          routerConfig: router,
        ),
      ),
    );
  }
}

/// The bundled fonts are OFL-licensed, which requires shipping the license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Caprasimo', 'assets/fonts/OFL-Caprasimo.txt'),
      ('Karla', 'assets/fonts/OFL-Karla.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(file));
    }
  });
}
