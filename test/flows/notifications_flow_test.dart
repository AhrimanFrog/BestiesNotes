import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/reminder_plan.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/notification_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Starts without permission; asking grants it.
class FakeNotifications implements NotificationService {
  bool permitted = false;
  List<PlannedReminder> scheduled = [];
  void Function(String route)? onOpen;

  @override
  Future<void> init({required void Function(String route) onOpen}) async =>
      this.onOpen = onOpen;

  @override
  Future<String?> launchRoute() async => null;

  @override
  Future<bool> isPermitted() async => permitted;

  @override
  Future<bool> requestPermission() async => permitted = true;

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders, {
    required String lessonChannel,
    required String weeklyChannel,
  }) async => scheduled = reminders;

  List<PlannedReminder> get lessonReminders =>
      scheduled.where((r) => r.kind == ReminderKind.lesson).toList();
}

void main() {
  late DbClient db;
  late int lessonId;

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
    // Scrolling takes effect on the next frame; tap where it is now.
    await tester.pump();
    await tester.tap(finder);
    await settle(tester);
  }

  /// The scheduler waits for writes to settle before re-planning; its timer
  /// runs on the test's clock.
  Future<void> waitForReplan(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
  }

  testWidgets('reminder settings, permission, and opening a reminder', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1720);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final notifications = FakeNotifications();
    await tester.runAsync(() async {
      db = DbClient(NativeDatabase.memory());
      await db.saveSettings({'language': 'en'});
      const rate = Rate(rate: 10, period: RatePeriod.perLesson);
      final anna = await db.createOrUpdateStudent(
        const Student(name: 'Anna', contact: '', pricing: rate),
      );
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      lessonId = await db.createOrUpdateLesson(
        Lesson(
          name: 'Grammar',
          start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18),
          duration: const Duration(hours: 1),
        ),
      );
      await db.syncLessonMembership(lessonId, [
        const Student(name: '', contact: '', pricing: rate).copyWith(id: anna),
      ]);
    });

    await tester.pumpWidget(BestiesApp(db: db, notifications: notifications));
    await settle(tester);
    expect(
      notifications.lessonReminders.single.title,
      'Grammar in 15 min',
      reason: 'scheduled on start, 15 minutes by default',
    );

    // ── Settings ────────────────────────────────────────────────────────────
    await tapAndSettle(tester, find.byTooltip('Settings'));
    expect(find.text('Notifications are off for this app'), findsOneWidget);
    await tapAndSettle(tester, find.text('Allow'));
    expect(find.text('Notifications are off for this app'), findsNothing);

    await tapAndSettle(tester, find.text('Lesson reminders'));
    await tapAndSettle(tester, find.text('30 min before'));
    await tapAndSettle(tester, find.text('Weekly unpaid summary'));
    await waitForReplan(tester);

    final stored = (await tester.runAsync(db.loadSettings))!;
    expect(stored['lesson_reminder_minutes'], '30');
    expect(stored['debt_digest'], 'false');
    expect(notifications.lessonReminders.single.title, 'Grammar in 30 min');
    // Anna came this week but has nothing booked next week.
    expect(
      notifications.scheduled.where((r) => r.route == '/schedule'),
      isNotEmpty,
    );

    // ── Tapping a reminder opens its lesson ─────────────────────────────────
    notifications.onOpen!('/lesson/$lessonId');
    await settle(tester);
    expect(find.text('Grammar'), findsWidgets);
    expect(find.text('Edit'), findsOneWidget, reason: 'lesson screen');

    await tester.runAsync(() => db.close());
  });
}
