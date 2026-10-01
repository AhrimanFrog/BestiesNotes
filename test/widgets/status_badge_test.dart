import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('renders label text', (tester) async {
    await tester.pumpThemed(
      const StatusBadge(label: 'Scheduled', tone: StatusTone.scheduled),
    );
    expect(find.text('Scheduled'), findsOneWidget);
  });

  testWidgets('colors the label with the tone foreground', (tester) async {
    await tester.pumpThemed(
      const StatusBadge(label: 'Cancelled', tone: StatusTone.cancelled),
    );
    final text = tester.widget<Text>(find.text('Cancelled'));
    expect(
      text.style?.color,
      AppTokens.light.tone(StatusTone.cancelled).fg,
    );
  });
}
