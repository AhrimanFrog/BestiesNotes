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
  const rate = Rate(rate: 25, period: RatePeriod.perLesson);

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

  testWidgets('owed badge, create, assign a group, delete', (tester) async {
    tester.view.physicalSize = const Size(800, 1720);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      db = DbClient(NativeDatabase.memory());
      final anna = await db.createOrUpdateStudent(
        const Student(name: 'Anna', contact: '', pricing: rate),
      );
      await db.createOrUpdateGroup(const Group(name: 'Club', pricing: rate));
      final lesson = await db.createOrUpdateLesson(
        Lesson(
          name: 'Grammar',
          start: DateTime(2025, 1, 6, 10),
          duration: const Duration(hours: 1),
        ),
      );
      await db.syncLessonMembership(lesson, [
        Student(id: anna, name: '', contact: '', pricing: rate),
      ]);
    });

    await tester.pumpWidget(BestiesApp(db: db));
    await settle(tester);
    await tapAndSettle(tester, find.byIcon(Icons.school_outlined));

    // An unpaid past lesson shows on the card.
    expect(find.text('Owes 25'), findsOneWidget);

    // ── Create ──────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.text('Student'));
    expect(find.text('New student'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Bob');
    await tester.enterText(find.widgetWithText(TextFormField, 'Rate'), '30');
    await settle(tester);
    await tapAndSettle(tester, find.text('Create student'));

    expect(find.text('Bob'), findsOneWidget, reason: 'back on the list');

    // ── Assign a group ──────────────────────────────────────────────────────
    await tapAndSettle(tester, find.text('Bob'));
    expect(find.text('Nothing owed'), findsOneWidget);
    await tapAndSettle(tester, find.text('Edit'));
    await tapAndSettle(tester, find.text('No group'));
    await tapAndSettle(tester, find.text('Club').last);
    await tapAndSettle(tester, find.text('Save'));

    final bob = (await tester.runAsync(
      () async => (await db.getStudents()).singleWhere((s) => s.name == 'Bob'),
    ))!;
    expect(bob.group?.name, 'Club');
    expect(bob.pricing.rate, 30);
    expect(find.text('Club'), findsOneWidget, reason: 'group chip');

    // ── Delete ──────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.byTooltip('More'));
    await tapAndSettle(tester, find.text('Delete student'));
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Delete'));

    expect(find.text('Bob'), findsNothing);
    final names = (await tester.runAsync(db.getStudents))!.map((s) => s.name);
    expect(names, ['Anna']);

    await tester.runAsync(() => db.close());
  });
}
