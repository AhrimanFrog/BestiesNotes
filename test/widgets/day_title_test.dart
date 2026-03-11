import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget build(String weekDay, String date) => MaterialApp(
    home: Scaffold(body: DayTitle(weekDay: weekDay, date: date)),
  );

  testWidgets('renders weekDay text', (tester) async {
    await tester.pumpWidget(build('MON', '13.01.2025'));
    expect(find.text('MON'), findsOneWidget);
  });

  testWidgets('renders date text', (tester) async {
    await tester.pumpWidget(build('MON', '13.01.2025'));
    expect(find.text('13.01.2025'), findsOneWidget);
  });
}
