import 'package:besties_notes/widgets/navigation/week_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 13.01.2025 – 19.01.2025 (end is exclusive midnight, so display end - 1 day)
  final range = DateTimeRange(
    start: DateTime(2025, 1, 13),
    end: DateTime(2025, 1, 20),
  );

  Widget build({VoidCallback? onLeft, VoidCallback? onRight}) => MaterialApp(
    home: Scaffold(
      body: WeekNavigationBar(
        timeRange: range,
        onTapLeft: onLeft,
        onTapRight: onRight,
      ),
    ),
  );

  testWidgets('displays formatted date range label', (tester) async {
    await tester.pumpWidget(build());
    expect(find.text('13.01.2025 – 19.01.2025'), findsOneWidget);
  });

  testWidgets('left chevron calls onTapLeft', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(build(onLeft: () => tapped = true));
    await tester.tap(find.byIcon(Icons.chevron_left));
    expect(tapped, isTrue);
  });

  testWidgets('right chevron calls onTapRight', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(build(onRight: () => tapped = true));
    await tester.tap(find.byIcon(Icons.chevron_right));
    expect(tapped, isTrue);
  });
}
