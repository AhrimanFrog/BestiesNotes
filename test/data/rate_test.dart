import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/rate.dart';
import 'package:besties_notes/extensions/rate_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('Rate.calculateOwed', () {
    final dates = [
      DateTime(2025, 1, 5),
      DateTime(2025, 1, 20),
      DateTime(2025, 2, 3),
    ];

    test('per-lesson rate charges every lesson', () {
      const rate = Rate(rate: 10, period: RatePeriod.perLesson);
      expect(rate.calculateOwed(dates), 30);
    });

    test('monthly rate charges once per month with unpaid lessons', () {
      const rate = Rate(rate: 100, period: RatePeriod.monthly);
      expect(rate.calculateOwed(dates), 200);
    });

    test('nothing unpaid means nothing owed', () {
      const rate = Rate(rate: 100, period: RatePeriod.monthly);
      expect(rate.calculateOwed(const []), 0);
    });
  });

  test('tryParseAmount accepts comma decimals', () {
    expect(Rate.tryParseAmount('12,5'), 12.5);
    expect(Rate.tryParseAmount(' 7.25 '), 7.25);
    expect(Rate.tryParseAmount('abc'), isNull);
  });

  group('label', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final uk = lookupAppLocalizations(const Locale('uk'));
    const perLesson = Rate(rate: 420, period: RatePeriod.perLesson);
    const monthly = Rate(rate: 12.5, period: RatePeriod.monthly);

    test('English', () {
      Intl.withLocale('en', () {
        expect(perLesson.label(en), '420 / lesson');
        expect(monthly.label(en), '12.50 / month');
      });
    });

    test('Ukrainian uses its own decimal separator', () {
      Intl.withLocale('uk', () {
        expect(perLesson.label(uk), '420 / урок');
        expect(monthly.label(uk), '12,50 / міс.');
      });
    });
  });

  group('amounts', () {
    test('display amounts are grouped per locale', () {
      expect(Intl.withLocale('en', () => formatAmount(1200)), '1,200');
      // Ukrainian groups with a no-break space.
      expect(Intl.withLocale('uk', () => formatAmount(1200)), '1 200');
    });

    test('input amounts stay ungrouped so they parse back', () {
      for (final amount in [1200.0, 12.5, 0.75]) {
        final text = Intl.withLocale('uk', () => formatAmountForInput(amount));
        expect(Rate.tryParseAmount(text), amount);
      }
    });
  });
}
