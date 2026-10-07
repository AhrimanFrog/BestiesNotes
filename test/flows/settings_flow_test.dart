import 'dart:io';

import 'package:besties_notes/data/calendar_period.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/backup_service.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// Drives the real app against file-backed databases, so a restore swaps an
/// actual database file.
void main() {
  const rate = Rate(rate: 25, period: RatePeriod.perLesson);

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Settings rows below the fold aren't built until scrolled to.
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.dragUntilVisible(
        finder,
        find.byType(ListView).last,
        const Offset(0, -200),
      );

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    // Scrolling takes effect on the next frame; tap where it is now.
    await tester.pump();
    await tester.tap(finder);
    await settle(tester);
  }

  testWidgets('settings apply live, and a backup restores the app', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1720);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    late Directory dir;
    late File current;
    late File backup;
    late DbClient db;
    await tester.runAsync(() async {
      dir = await Directory.systemTemp.createTemp('besties_settings_flow');
      current = File('${dir.path}/current.sqlite');

      // A backup holding "Anna", made from another database.
      final other = DbClient(NativeDatabase(File('${dir.path}/other.sqlite')));
      await other.createOrUpdateStudent(
        const Student(name: 'Anna', contact: '', pricing: rate),
      );
      backup = await BackupService.create(other, dir);
      await other.close();

      db = DbClient(NativeDatabase(current));
      await db.createOrUpdateStudent(
        const Student(name: 'Bob', contact: '', pricing: rate),
      );
    });

    await tester.pumpWidget(
      BestiesApp(
        db: db,
        databaseFile: () async => current,
        openDatabase: () => DbClient(NativeDatabase(current)),
      ),
    );
    await settle(tester);

    // ── Week start ──────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.byTooltip('Settings'));
    await tapAndSettle(tester, find.text('Week starts on'));
    await tapAndSettle(tester, find.text('Sunday'));
    await tester.binding.handlePopRoute();
    await settle(tester);

    final sundayWeek = Intl.withLocale(
      'en',
      () => CalendarPeriod.label(
        CalendarView.week,
        DateTime.now(),
        DateTime.sunday,
      ),
    );
    expect(find.text(sundayWeek), findsOneWidget, reason: 'calendar re-laid');

    // ── Currency ────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.byTooltip('Settings'));
    await scrollTo(tester, find.text('Currency'));
    await tapAndSettle(tester, find.text('Currency'));
    await tapAndSettle(tester, find.text('UAH (₴)'));
    await tester.binding.handlePopRoute();
    await settle(tester);
    await tapAndSettle(tester, find.byIcon(Icons.school_outlined));
    expect(find.text('₴25 / lesson'), findsOneWidget);

    // ── Language ────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.byTooltip('Settings'));
    await scrollTo(tester, find.text('Language'));
    await tapAndSettle(tester, find.text('Language'));
    await tapAndSettle(tester, find.text('Українська'));
    expect(find.text('Налаштування'), findsOneWidget, reason: 'live switch');

    final stored = (await tester.runAsync(db.loadSettings))!;
    expect(stored['week_start'], '7');
    expect(stored['currency'], 'UAH');
    expect(stored['language'], 'uk');

    // ── Restore ─────────────────────────────────────────────────────────────
    final session = tester.state(find.byType(BestiesApp)) as AppSession;
    await tester.runAsync(() => session.restore(backup));
    await settle(tester);

    // The backup carries its own (default) settings: English, no currency.
    expect(find.text('Schedule'), findsWidgets, reason: 'back on schedule');
    await tapAndSettle(tester, find.byIcon(Icons.school_outlined));
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
    expect(find.text('25 / lesson'), findsOneWidget);

    await tester.runAsync(() async {
      await session.db.close();
      await dir.delete(recursive: true);
    });
  });
}
