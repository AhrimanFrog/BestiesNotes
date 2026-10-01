import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('renders weekday and date', (tester) async {
    await tester.pumpThemed(DayTitle(date: DateTime(2025, 1, 13)));
    expect(find.text('MON'), findsOneWidget);
    expect(find.text('13 Jan'), findsOneWidget);
    expect(find.text('Today'), findsNothing);
  });

  testWidgets('marks today in the accent color', (tester) async {
    await tester.pumpThemed(DayTitle(date: DateTime.now()));
    expect(find.text('Today'), findsOneWidget);
    final weekday = tester.widget<Text>(find.byType(Text).first);
    expect(weekday.style?.color, AppTokens.light.accent);
  });

  testWidgets('add button only when onAdd is set', (tester) async {
    await tester.pumpThemed(DayTitle(date: DateTime(2025, 1, 13)));
    expect(find.byIcon(Icons.add_rounded), findsNothing);

    var added = false;
    await tester.pumpThemed(
      DayTitle(date: DateTime(2025, 1, 13), onAdd: () => added = true),
    );
    await tester.tap(find.byIcon(Icons.add_rounded));
    expect(added, isTrue);
  });
}
