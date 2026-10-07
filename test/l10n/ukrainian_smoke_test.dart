import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/main.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/router.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every main screen in Ukrainian on a narrow phone with enlarged text.
/// Ukrainian strings run longer than English; any overflow fails the test.
void main() {
  late DbClient db;
  const rate = Rate(rate: 1250, period: RatePeriod.perLesson);

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> loadFonts() async {
    // Real widths, not the test font's oversized placeholder glyphs.
    for (final (family, file) in [
      ('YesevaOne', 'assets/fonts/YesevaOne-Regular.ttf'),
      ('Nunito', 'assets/fonts/Nunito-Variable.ttf'),
    ]) {
      await (FontLoader(family)..addFont(rootBundle.load(file))).load();
    }
  }

  testWidgets('main screens fit in Ukrainian at 130% text', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.localesTestValue = const [Locale('uk')];
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    late int lessonId;
    await tester.runAsync(() async {
      await loadFonts();
      db = DbClient(NativeDatabase.memory());
      final student = await db.createOrUpdateStudent(
        const Student(
          name: 'Олександра Шевченко-Коваленко',
          contact: '+380 67 123 4567',
          pricing: rate,
        ),
      );
      final group = await db.createOrUpdateGroup(
        const Group(name: 'Суботня розмовна група', pricing: rate),
      );
      await db.syncGroupMemberships(group, [student]);
      final now = DateTime.now();
      lessonId = await db.createOrUpdateLesson(
        Lesson(
          name: 'Минулий тривалий час',
          start: DateTime(now.year, now.month, now.day, 9),
          duration: const Duration(minutes: 90),
        ),
      );
      await db.syncLessonMembership(lessonId, [
        const Group(id: 1, name: '', pricing: rate),
      ]);
      // A lesson that has surely happened, for the reports.
      final pastId = await db.createOrUpdateLesson(
        Lesson(
          name: 'Розмовна практика',
          start: now.subtract(const Duration(days: 2)),
          duration: const Duration(minutes: 60),
        ),
      );
      await db.syncLessonMembership(pastId, [
        const Group(id: 1, name: '', pricing: rate),
      ]);
    });

    await tester.pumpWidget(BestiesApp(db: db));
    await settle(tester);
    expect(find.text('Розклад'), findsWidgets, reason: 'rendered in uk');

    // Schedule: week, then month.
    await tester.tap(find.byTooltip('Місяць'));
    await settle(tester);

    // Students and groups lists.
    await tester.tap(find.byIcon(Icons.school_outlined));
    await settle(tester);
    await tester.tap(find.text('Групи').first);
    await settle(tester);

    // Detail screens, view and edit.
    for (final path in ['/student/1', '/group/1', '/lesson/$lessonId']) {
      router.push(path);
      await settle(tester);
      await tester.tap(find.text('Редагувати'));
      await settle(tester);
      router.pop();
      await settle(tester);
    }

    // Reports, and payment histories with a part-paid group lesson.
    await tester.runAsync(
      () => db.updateParticipantStatus(lessonId, 1, isPaid: true),
    );
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await settle(tester);
    await tester.ensureVisible(find.text('Увесь час'));
    await tester.tap(find.text('Увесь час'));
    await settle(tester);
    expect(find.text('Зароблено'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await settle(tester);
    for (final path in ['/student/1/payments', '/group/1/payments']) {
      router.push(path);
      await settle(tester);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
      await settle(tester);
      router.pop();
      await settle(tester);
    }

    // Settings, scrolled to the bottom.
    router.push('/settings');
    await settle(tester);
    expect(find.text('Налаштування'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await settle(tester);
    router.pop();
    await settle(tester);

    // New lesson and its picker.
    router.push('/lesson/new');
    await settle(tester);
    await tester.tap(find.text('Натисніть, щоб вибрати'));
    await settle(tester);
    expect(find.text('Хто прийде?'), findsOneWidget);

    await tester.runAsync(() => db.close());
  });
}
