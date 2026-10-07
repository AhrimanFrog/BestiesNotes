import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Pumps a button that opens the dialog and records its result.
  Future<List<bool>> open(WidgetTester tester) async {
    final results = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => results.add(
              await showConfirmDialog(
                context,
                title: 'Delete Alice?',
                message: 'This cannot be undone.',
                confirmLabel: 'Delete',
                destructive: true,
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('shows title and message', (tester) async {
    await open(tester);
    expect(find.text('Delete Alice?'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);
  });

  testWidgets('confirm resolves to true', (tester) async {
    final results = await open(tester);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(results, [true]);
    expect(find.byType(ConfirmDialog), findsNothing);
  });

  testWidgets('cancel resolves to false', (tester) async {
    final results = await open(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(results, [false]);
  });

  testWidgets('dismissing by tapping outside resolves to false', (
    tester,
  ) async {
    final results = await open(tester);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(results, [false]);
  });
}
