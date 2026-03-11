import 'package:besties_notes/widgets/dialogs/deletion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget build({VoidCallback? onDelete}) => MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => DeletionDialog(
              entryName: 'Alice',
              onDelete: onDelete,
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    ),
  );

  Future<void> openDialog(WidgetTester tester, {VoidCallback? onDelete}) async {
    await tester.pumpWidget(build(onDelete: onDelete));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows title with entry name', (tester) async {
    await openDialog(tester);
    expect(find.text('Delete Alice'), findsOneWidget);
  });

  testWidgets('shows confirmation content with entry name', (tester) async {
    await openDialog(tester);
    expect(
      find.text('Are you sure you want to delete Alice?'),
      findsOneWidget,
    );
  });

  testWidgets('Cancel button dismisses dialog', (tester) async {
    await openDialog(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(DeletionDialog), findsNothing);
  });

  testWidgets('Delete button calls onDelete and dismisses dialog', (tester) async {
    bool deleted = false;
    await openDialog(tester, onDelete: () => deleted = true);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(deleted, isTrue);
    expect(find.byType(DeletionDialog), findsNothing);
  });

  testWidgets('Delete without onDelete still dismisses', (tester) async {
    await openDialog(tester, onDelete: null);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.byType(DeletionDialog), findsNothing);
  });
}
