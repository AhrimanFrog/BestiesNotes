import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DbClient db;

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await settle(tester);
  }

  Future<void> back(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await settle(tester);
  }

  testWidgets('write a checklist note, tick it, and add one for a student', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1720);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      db = DbClient(NativeDatabase.memory());
      await db.createOrUpdateStudent(
        const Student(
          name: 'Anna',
          contact: '',
          pricing: Rate(rate: 10, period: RatePeriod.perLesson),
        ),
      );
    });
    await tester.pumpWidget(BestiesApp(db: db));
    await settle(tester);

    // ── A new note from the Notes tab ──────────────────────────────────────
    await tapAndSettle(tester, find.byIcon(Icons.sticky_note_2_outlined));
    expect(find.text('No notes yet'), findsOneWidget);
    await tapAndSettle(
      tester,
      find.widgetWithText(FloatingActionButton, 'New note'),
    );

    // Opens ready to type.
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Homework');
    await tester.enterText(fields.at(1), '- [ ] page 12');
    await settle(tester);
    // Enter on a checklist line starts the next item.
    await tester.enterText(fields.at(1), '- [ ] page 12\n');
    await settle(tester);
    expect(
      tester.widget<TextField>(fields.at(1)).controller!.text,
      '- [ ] page 12\n- [ ] ',
    );
    await tapAndSettle(tester, find.text('Done'));

    // Read mode renders the checklist; ticking it saves.
    expect(find.text('page 12'), findsOneWidget);
    await tapAndSettle(
      tester,
      find.byIcon(Icons.check_box_outline_blank_rounded),
    );
    expect(find.byIcon(Icons.check_box_rounded), findsOneWidget);

    await back(tester);
    expect(find.text('Homework'), findsOneWidget);
    expect(find.textContaining('1/1 done'), findsOneWidget);

    // ── A note on a student's page ─────────────────────────────────────────
    await tapAndSettle(tester, find.byIcon(Icons.school_outlined));
    await tapAndSettle(tester, find.text('Anna').first);
    expect(find.text('No notes yet'), findsOneWidget);
    await tapAndSettle(tester, find.text('Add note'));
    expect(find.text('Anna'), findsOneWidget, reason: 'linked chip');
    await tester.enterText(find.byType(TextField).at(0), 'Articles');
    // Leaving saves without pressing Done.
    await back(tester);
    expect(find.text('Articles'), findsOneWidget);
    await back(tester);

    // The Notes tab finds it under Students.
    await tapAndSettle(tester, find.byIcon(Icons.sticky_note_2_outlined));
    await tapAndSettle(tester, find.widgetWithText(FilterChip, 'Students'));
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Homework'), findsNothing);

    final stored = (await tester.runAsync(db.getNotes))!;
    expect(stored.map((n) => (n.title, n.studentName)), [
      ('Articles', 'Anna'),
      ('Homework', null),
    ]);
    expect(stored.last.body, '- [x] page 12\n- [ ] ');

    await tester.runAsync(() => db.close());
  });
}
