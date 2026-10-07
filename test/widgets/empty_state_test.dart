import 'package:besties_notes/widgets/layout/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows title, message and a working action', (tester) async {
    var tapped = false;
    await tester.pumpThemed(
      EmptyState(
        icon: Icons.school_outlined,
        title: 'No students yet',
        message: 'Add the people you teach.',
        actionLabel: 'Add a student',
        onAction: () => tapped = true,
      ),
    );
    expect(find.text('No students yet'), findsOneWidget);
    expect(find.text('Add the people you teach.'), findsOneWidget);

    await tester.tap(find.text('Add a student'));
    expect(tapped, isTrue);
  });

  testWidgets('hides the button without an action', (tester) async {
    await tester.pumpThemed(
      const EmptyState(icon: Icons.inbox_outlined, title: 'Nothing here'),
    );
    expect(find.byType(FilledButton), findsNothing);
  });
}
