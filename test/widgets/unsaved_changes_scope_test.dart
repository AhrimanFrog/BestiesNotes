import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/layout/unsaved_changes_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<String> calls;

  setUp(() => calls = []);

  /// A home screen that pushes a page wrapped in the scope, so a back
  /// gesture has somewhere to go.
  Future<void> pumpEditor(
    WidgetTester tester, {
    required bool isEditing,
    required bool isDirty,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => UnsavedChangesScope(
                  isEditing: isEditing,
                  isDirty: isDirty,
                  onSave: () async {
                    calls.add('save');
                    return true;
                  },
                  onDiscard: () => calls.add('discard'),
                  child: const Scaffold(body: Text('editor')),
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> goBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  testWidgets('outside edit mode, back simply leaves', (tester) async {
    await pumpEditor(tester, isEditing: false, isDirty: false);
    await goBack(tester);
    expect(find.text('editor'), findsNothing);
    expect(calls, isEmpty);
  });

  testWidgets('clean edit: back exits edit mode without asking', (
    tester,
  ) async {
    await pumpEditor(tester, isEditing: true, isDirty: false);
    await goBack(tester);
    expect(calls, ['discard']);
    expect(find.text('Unsaved changes'), findsNothing);
    expect(find.text('editor'), findsOneWidget, reason: 'route stays');
  });

  testWidgets('dirty edit: back asks, and Save saves', (tester) async {
    await pumpEditor(tester, isEditing: true, isDirty: true);
    await goBack(tester);
    expect(find.text('Unsaved changes'), findsOneWidget);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(calls, ['save']);
  });

  testWidgets('dirty edit: Discard discards', (tester) async {
    await pumpEditor(tester, isEditing: true, isDirty: true);
    await goBack(tester);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(calls, ['discard']);
  });

  testWidgets('dirty edit: Keep editing does nothing', (tester) async {
    await pumpEditor(tester, isEditing: true, isDirty: true);
    await goBack(tester);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);
    expect(find.text('editor'), findsOneWidget);
  });
}
