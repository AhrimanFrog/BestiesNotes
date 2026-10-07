import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  /// The app's strings in the current language.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// A `MaterialApp.builder` that keeps intl's default locale in sync with the
/// app's, so plain `DateFormat` / `NumberFormat` calls follow the language.
Widget syncIntlLocale(BuildContext context, Widget? child) {
  Intl.defaultLocale = Localizations.localeOf(context).toLanguageTag();
  return child!;
}
