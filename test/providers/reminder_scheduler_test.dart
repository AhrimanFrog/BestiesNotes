import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/reminder_plan.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/notification_service.dart';
import 'package:besties_notes/providers/reminder_scheduler.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationService extends NoopNotificationService {
  final scheduled = <List<PlannedReminder>>[];
  String? lessonChannel;

  List<PlannedReminder> get current => scheduled.last;

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders, {
    required String lessonChannel,
    required String weeklyChannel,
  }) async {
    scheduled.add(reminders);
    this.lessonChannel = lessonChannel;
  }
}

void main() {
  late DbClient db;
  late FakeNotificationService notifications;
  late ReminderScheduler scheduler;

  /// Wednesday 15 Oct 2025, 10:00.
  final now = DateTime(2025, 10, 15, 10);
  const rate = Rate(rate: 300, period: RatePeriod.perLesson);

  setUp(() async {
    db = DbClient(NativeDatabase.memory());
    notifications = FakeNotificationService();
    scheduler = ReminderScheduler(
      db,
      notifications,
      debounce: Duration.zero,
      clock: () => now,
    );
    // English, whatever the machine running the tests uses.
    await db.saveSettings({'language': 'en'});
  });

  tearDown(() async {
    await scheduler.dispose();
    await db.close();
  });

  Future<int> book(DateTime start, {String name = 'Anna'}) async {
    final student = await db.createOrUpdateStudent(
      Student(name: name, contact: '', pricing: rate),
    );
    final id = await db.createOrUpdateLesson(
      Lesson(name: 'Grammar', start: start, duration: const Duration(hours: 1)),
    );
    await db.syncLessonMembership(id, [
      Student(id: student, name: name, contact: '', pricing: rate),
    ]);
    return id;
  }

  test('plans from the database, in the chosen language', () async {
    final upcoming = await book(DateTime(2025, 10, 15, 18));
    // Taught last week, unpaid: in Monday's summary.
    await book(DateTime(2025, 10, 8, 18), name: 'Ben');

    await scheduler.reschedule();

    final byRoute = {for (final r in notifications.current) r.route: r};
    expect(byRoute['/lesson/$upcoming']!.title, 'Grammar in 15 min');
    expect(byRoute['/reports']!.title, contains('600'));
    expect(notifications.lessonChannel, 'Lesson reminders');

    await db.saveSettings({'language': 'uk'});
    await scheduler.reschedule();
    expect(notifications.lessonChannel, 'Нагадування про уроки');
  });

  test('a changed setting re-plans by itself', () async {
    await book(DateTime(2025, 10, 15, 18));
    scheduler.start();
    await pumpEventQueue();
    expect(
      notifications.current.where((r) => r.kind == ReminderKind.lesson),
      hasLength(1),
    );

    final runs = notifications.scheduled.length;
    await db.saveSettings(
      const AppSettings(lessonReminderMinutes: 0, languageCode: 'en').toMap(),
    );
    // Only the database change triggers it.
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(notifications.scheduled.length, greaterThan(runs));
    expect(
      notifications.current.where((r) => r.kind == ReminderKind.lesson),
      isEmpty,
    );
  });

  test('a failure is swallowed, the next run still works', () async {
    await db.close();
    await scheduler.reschedule();
    expect(notifications.scheduled, isEmpty);

    db = DbClient(NativeDatabase.memory());
    scheduler = ReminderScheduler(db, notifications, clock: () => now);
    await scheduler.reschedule();
    expect(notifications.scheduled, hasLength(1));
  });
}
