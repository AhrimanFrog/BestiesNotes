import 'package:besties_notes/widgets/avatar/initials_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget build(String initials) => MaterialApp(
    home: Scaffold(
      body: InitialsCircle(initials: initials, circleColor: Colors.pink),
    ),
  );

  testWidgets('renders initials text', (tester) async {
    await tester.pumpWidget(build('AS'));
    expect(find.text('AS'), findsOneWidget);
  });
}
