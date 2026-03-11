import 'package:besties_notes/widgets/texts/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget build(String label, Color color) => MaterialApp(
    home: Scaffold(body: StatusBadge(label: label, accentColor: color)),
  );

  testWidgets('renders label text', (tester) async {
    await tester.pumpWidget(build('Scheduled', Colors.blue));
    expect(find.text('Scheduled'), findsOneWidget);
  });

  testWidgets('uses accentColor for text style', (tester) async {
    const color = Colors.red;
    await tester.pumpWidget(build('Cancelled', color));
    final text = tester.widget<Text>(find.text('Cancelled'));
    expect(text.style?.color, color);
  });
}
