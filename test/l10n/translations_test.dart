import 'dart:convert';
import 'dart:io';

import 'package:besties_notes/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Iterable<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@'));

void main() {
  final en = _arb('en');
  final uk = _arb('uk');

  group('ARB files', () {
    test('Ukrainian has exactly the English keys', () {
      final enKeys = _messageKeys(en).toSet();
      final ukKeys = _messageKeys(uk).toSet();
      expect(enKeys.difference(ukKeys), isEmpty, reason: 'missing in uk');
      expect(ukKeys.difference(enKeys), isEmpty, reason: 'unknown in uk');
    });

    test('every placeholder survives translation', () {
      for (final key in _messageKeys(en)) {
        final meta = en['@$key'] as Map<String, dynamic>?;
        final placeholders =
            (meta?['placeholders'] as Map<String, dynamic>?)?.keys ?? [];
        for (final name in placeholders) {
          expect(
            RegExp('\\{$name[,}]').hasMatch(uk[key] as String),
            isTrue,
            reason: '"$key" in uk lost {$name}',
          );
        }
      }
    });
  });

  group('Ukrainian plurals', () {
    final l10n = lookupAppLocalizations(const Locale('uk'));

    test('lessons: one / few / many', () {
      expect(l10n.lessonCount(0), 'немає уроків');
      expect(l10n.lessonCount(1), '1 урок');
      expect(l10n.lessonCount(3), '3 уроки');
      expect(l10n.lessonCount(5), '5 уроків');
      expect(l10n.lessonCount(11), '11 уроків');
      expect(l10n.lessonCount(21), '21 урок');
    });

    test('members and debts follow the same rules', () {
      expect(l10n.memberCount(2), '2 учасники');
      expect(l10n.memberCount(12), '12 учасників');
      expect(l10n.studentOwesFor(22), 'Борг за 22 уроки');
    });
  });
}
