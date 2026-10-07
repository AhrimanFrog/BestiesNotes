import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/l10n/l10n.dart';

extension RateUIExt on Rate {
  /// "25 / lesson", "180 / month".
  String label(AppLocalizations l10n) {
    final amount = formatAmount(rate);
    return switch (period) {
      RatePeriod.perLesson => l10n.ratePerLesson(amount),
      RatePeriod.monthly => l10n.ratePerMonth(amount),
    };
  }
}
