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

  final db = DbClient();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DataProvider>(create: (_) => db),
        RepositoryProvider<PaymentProvider>(create: (_) => db),
      ],
      child: MaterialApp.router(
        title: 'Besties Notes',
        theme: buildLightTheme(),
        routerConfig: router,
      ),
    ),
  );
}

/// The bundled fonts are OFL-licensed, which requires shipping the license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Caprasimo', 'assets/fonts/OFL-Caprasimo.txt'),
      ('Karla', 'assets/fonts/OFL-Karla.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString(file));
    }
  });
}
