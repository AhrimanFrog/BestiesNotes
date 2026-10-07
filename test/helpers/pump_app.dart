import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in the app theme and localizations (English by default) so
/// widgets can read `context.tokens` and `context.l10n`.
Widget themed(Widget child, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      theme: buildLightTheme(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: syncIntlLocale,
      home: Scaffold(body: child),
    );

extension PumpThemed on WidgetTester {
  Future<void> pumpThemed(Widget child, {Locale locale = const Locale('en')}) =>
      pumpWidget(themed(child, locale: locale));
}
