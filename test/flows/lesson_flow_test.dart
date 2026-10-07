import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives the real app (router, cubits, widgets) against an in-memory db.
void main() {
  late DbClient db;

  /// Drift completes its futures outside the fake clock, so alternate real
  /// waits with frame pumps instead of pumpAndSettle.
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

  testWidgets('create a lesson, track attendance, abandon an edit', (
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
          pricing: Rate(rate: 25, period: RatePeriod.perLesson),
        ),
      );
    });

    await tester.pumpWidget(BestiesApp(db: db));
    await settle(tester);

    // ── Create ──────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.text('Lesson'));
    expect(find.text('New lesson'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Topic'),
      'Present Simple',
    );
    // Opening the picker before ever visiting the Students tab must still
    // list students (the app-wide cubit loads eagerly).
    await tapAndSettle(tester, find.text('Tap to select'));
    await tapAndSettle(tester, find.text('Anna'));
    await tapAndSettle(tester, find.text('Done (1)'));
    await tapAndSettle(tester, find.text('Create lesson'));

    final lessons = (await tester.runAsync(
      () => db.getLessonsForRange(DateTime(2000), DateTime(2100)),
    ))!;
    expect(lessons.single.name, 'Present Simple');
    expect(lessons.single.participants.single.student.name, 'Anna');
    expect(find.text('Present Simple'), findsOneWidget, reason: 'listed');

    // ── Track attendance ────────────────────────────────────────────────────
    await tapAndSettle(tester, find.text('Present Simple'));
    await tapAndSettle(tester, find.byTooltip('Present'));

    var lesson = (await tester.runAsync(
      () => db.getLesson(lessons.single.id!),
    ))!;
    expect(lesson.participants.single.attended, isTrue);

    // ── Abandon an edit ─────────────────────────────────────────────────────
    await tapAndSettle(tester, find.text('Edit'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Present Simple'),
      'Past Simple',
    );
    await settle(tester);

    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('Unsaved changes'), findsOneWidget);
    await tapAndSettle(
      tester,
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Discard'),
      ),
    );

    expect(find.text('Edit'), findsOneWidget, reason: 'back in view mode');
    lesson = (await tester.runAsync(() => db.getLesson(lessons.single.id!)))!;
    expect(lesson.name, 'Present Simple');

    await tester.runAsync(() => db.close());
  });
}
