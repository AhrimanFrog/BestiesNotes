import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/l10n/l10n.dart';

extension RateUIExt on Rate {
  /// "₴25 / lesson", "180 / month" (without a [currency]).
  String label(AppLocalizations l10n, {String? currency}) {
    final amount = formatMoney(rate, currency: currency);
    return switch (period) {
      RatePeriod.perLesson => l10n.ratePerLesson(amount),
      RatePeriod.monthly => l10n.ratePerMonth(amount),
    };
  }
}
