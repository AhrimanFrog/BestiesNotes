import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/texts/day_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  Widget build({int lessons = 0, bool isToday = false}) => DayTitle(
    weekDay: 'MON',
    date: '13.01.2025',
    lessonsNumber: lessons,
    isToday: isToday,
  );

  testWidgets('renders weekday and date', (tester) async {
    await tester.pumpThemed(build());
    expect(find.text('MON'), findsOneWidget);
    expect(find.text('13.01.2025'), findsOneWidget);
  });

  testWidgets('pluralizes the lesson count', (tester) async {
    await tester.pumpThemed(build(lessons: 1));
    expect(find.text('1 lesson'), findsOneWidget);

    await tester.pumpThemed(build(lessons: 3));
    expect(find.text('3 lessons'), findsOneWidget);
  });

  testWidgets('highlights today in the accent color', (tester) async {
    await tester.pumpThemed(build(isToday: true));
    final weekday = tester.widget<Text>(find.text('MON'));
    expect(weekday.style?.color, AppTokens.light.accent);
  });
}
