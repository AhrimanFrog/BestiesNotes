import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DbClient db;
  const rate = Rate(rate: 25, period: RatePeriod.perLesson);

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

  testWidgets('reports show earnings, and marking paid updates them', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1720);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      db = DbClient(NativeDatabase.memory());
      final anna = await db.createOrUpdateStudent(
        const Student(name: 'Anna', contact: '', pricing: rate),
      );
      final now = DateTime.now();
      // Two lessons this month (both already started), one last month.
      for (final start in [
        DateTime(now.year, now.month),
        DateTime(now.year, now.month).add(const Duration(minutes: 1)),
        DateTime(now.year, now.month - 1, 10),
      ]) {
        final id = await db.createOrUpdateLesson(
          Lesson(
            name: 'Grammar',
            start: start,
            duration: const Duration(hours: 1),
          ),
        );
        await db.syncLessonMembership(id, [
          const Student(
            name: '',
            contact: '',
            pricing: rate,
          ).copyWith(id: anna),
        ]);
      }
    });

    await tester.pumpWidget(BestiesApp(db: db));
    await settle(tester);

    await tapAndSettle(tester, find.byIcon(Icons.insights_outlined));
    expect(find.text('Reports'), findsWidgets);
    // This month: two lessons earned, none paid.
    expect(find.text('50'), findsWidgets);
    expect(find.text('Owed to you'), findsOneWidget);
    // All time: three unpaid lessons.
    expect(find.text('75'), findsOneWidget);

    // Open Anna's payments from the debtors list and mark one lesson paid.
    await tapAndSettle(tester, find.text('3 unpaid lessons'));
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Unpaid'), findsWidgets);
    final toggles = find.byTooltip('Mark paid');
    expect(toggles, findsNWidgets(3));
    await tapAndSettle(tester, toggles.first);
    expect(find.byTooltip('Mark paid'), findsNWidgets(2));
    expect(find.byTooltip('Mark unpaid'), findsOneWidget);

    // Back on Reports the balance has caught up.
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('50'), findsWidgets);
    expect(find.text('2 unpaid lessons'), findsOneWidget);

    // Switching the period re-totals.
    await tester.dragUntilVisible(
      find.text('Last month'),
      find.byType(ListView).first,
      const Offset(0, 300),
    );
    await tapAndSettle(tester, find.text('Last month'));
    expect(find.text('25'), findsWidgets);

    await tester.runAsync(() => db.close());
  });
}
