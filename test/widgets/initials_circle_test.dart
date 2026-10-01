import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/avatar/initials_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  const colors = TonePair(Colors.purple, Colors.white);

  testWidgets('renders initials text', (tester) async {
    await tester.pumpThemed(
      const InitialsCircle(initials: 'AS', colors: colors),
    );
    expect(find.text('AS'), findsOneWidget);
  });

  testWidgets('tiny circles show a single letter', (tester) async {
    await tester.pumpThemed(
      const InitialsCircle(initials: 'AS', colors: colors, size: 24),
    );
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('truncates long initials to two letters', (tester) async {
    await tester.pumpThemed(
      const InitialsCircle(initials: 'ABCD', colors: colors),
    );
    expect(find.text('AB'), findsOneWidget);
  });
}
