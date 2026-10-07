import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/reminder_plan.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _rate = Rate(rate: 100, period: RatePeriod.perLesson);
const anna = Student(id: 1, name: 'Anna', contact: '', pricing: _rate);
const ben = Student(id: 2, name: 'Ben', contact: '', pricing: _rate);

/// Wednesday 15 Oct 2025, 10:00; the next week starts Monday the 20th.
final now = DateTime(2025, 10, 15, 10);

var _ids = 0;

Lesson lesson(
  DateTime start, {
  List<Student> who = const [anna],
  bool cancelled = false,
}) => Lesson(
  id: ++_ids,
  name: 'Grammar',
  start: start,
  duration: const Duration(hours: 1),
  isCancelled: cancelled,
  participants: [
    for (final s in who)
      LessonParticipant(
        student: s,
        attended: false,
        isPaid: false,
        homeworkDone: false,
      ),
  ],
);

Participation owed(Student s, DateTime start) => Participation(
  lessonId: ++_ids,
  start: start,
  student: s,
  rate: _rate,
  isPaid: false,
);

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  setUpAll(initializeDateFormatting);

  List<PlannedReminder> plan({
    AppSettings settings = const AppSettings(),
    List<Lesson> lessons = const [],
    List<Participation> unpaid = const [],
  }) => ReminderPlan.plan(
    now: now,
    settings: settings,
    l10n: l10n,
    money: (amount) => amount.toStringAsFixed(0),
    lessons: lessons,
    unpaid: unpaid,
  );

  group('lesson reminders', () {
    /// Only lesson reminders, so the weekly ones don't mix in.
    List<PlannedReminder> lessonPlan(List<Lesson> lessons, {int? minutes}) =>
        plan(
          settings: AppSettings(
            lessonReminderMinutes:
                minutes ?? const AppSettings().lessonReminderMinutes,
            debtDigest: false,
            bookingReminder: false,
          ),
          lessons: lessons,
        );

    test('fire before each upcoming lesson, 15 minutes by default', () {
      final today = lesson(DateTime(2025, 10, 15, 18), who: [anna, ben]);
      final r = lessonPlan([today]).single;
      expect(r.at, DateTime(2025, 10, 15, 17, 45));
      expect(r.title, 'Grammar in 15 min');
      // intl separates "PM" with a narrow no-break space.
      expect(r.body, '6:00 PM · Anna, Ben');
      expect(r.route, '/lesson/${today.id}');
    });

    test('skip cancelled lessons, past reminders and far-off lessons', () {
      final reminders = lessonPlan([
        lesson(DateTime(2025, 10, 15, 18), cancelled: true),
        // Starts in 10 minutes: its reminder time has passed.
        lesson(DateTime(2025, 10, 15, 10, 10)),
        lesson(now.add(const Duration(days: 20))),
      ]);
      expect(reminders, isEmpty);
    });

    test('a day before reads "tomorrow"; off means none', () {
      final tomorrow = lesson(DateTime(2025, 10, 16, 18));
      final dayBefore = lessonPlan([tomorrow], minutes: 1440).single;
      expect(dayBefore.at, DateTime(2025, 10, 15, 18));
      expect(dayBefore.title, 'Grammar tomorrow');

      expect(lessonPlan([tomorrow], minutes: 0), isEmpty);
    });

    test('at most ${ReminderPlan.maxLessonReminders} are kept', () {
      final many = [
        for (var h = 0; h < 60; h++)
          lesson(DateTime(2025, 10, 16).add(Duration(hours: h * 4))),
      ];
      final reminders = lessonPlan(many);
      expect(reminders, hasLength(ReminderPlan.maxLessonReminders));
      expect(reminders.first.at, DateTime(2025, 10, 15, 23, 45));
    });
  });

  group('weekly unpaid summary', () {
    test('Monday 09:00, counting lessons that will have happened', () {
      final reminders = plan(
        settings: const AppSettings(bookingReminder: false),
        unpaid: [
          owed(anna, DateTime(2025, 10, 10)),
          // Still in the future now, but taught by Monday.
          owed(ben, DateTime(2025, 10, 17)),
          // Only by the Monday after.
          owed(ben, DateTime(2025, 10, 22)),
        ],
      );
      expect(reminders.map((r) => (r.at, r.title, r.body)), [
        (DateTime(2025, 10, 20, 9), '200 unpaid', 'Anna, Ben'),
        (DateTime(2025, 10, 27, 9), '300 unpaid', 'Ben, Anna'),
      ]);
      expect(reminders.first.route, '/reports');
    });

    test('follows the week start and stays quiet with nothing owed', () {
      final sunday = plan(
        settings: const AppSettings(
          weekStart: DateTime.sunday,
          bookingReminder: false,
        ),
        unpaid: [owed(anna, DateTime(2025, 10, 10))],
      );
      expect(sunday.first.at, DateTime(2025, 10, 19, 9));
      expect(
        plan(settings: const AppSettings(bookingReminder: false)),
        isEmpty,
      );
    });
  });

  group('students without lessons', () {
    test('the evening before a week, regulars with nothing booked', () {
      final reminders = plan(
        settings: const AppSettings(debtDigest: false),
        lessons: [
          // Both came recently; only Anna is booked next week.
          lesson(DateTime(2025, 10, 6, 9), who: [anna, ben]),
          lesson(DateTime(2025, 10, 21, 9)),
        ],
      ).where((r) => r.route == '/schedule');

      final first = reminders.first;
      expect(first.at, DateTime(2025, 10, 19, 18));
      expect(first.title, '1 student has no lessons next week');
      expect(first.body, 'Ben');
      // The week after: neither is booked.
      expect(reminders.last.body, 'Anna, Ben');
    });

    test('long lists are shortened', () {
      final crowd = [
        for (var i = 10; i < 15; i++)
          Student(id: i, name: 'S$i', contact: '', pricing: _rate),
      ];
      final r = plan(
        settings: const AppSettings(debtDigest: false),
        lessons: [lesson(DateTime(2025, 10, 6, 9), who: crowd)],
      ).first;
      expect(r.body, 'S10, S11, S12 and 2 more');
    });
  });

  test('every reminder has its own id', () {
    final reminders = plan(
      lessons: [
        lesson(DateTime(2025, 10, 6, 9), who: [anna, ben]),
        lesson(DateTime(2025, 10, 16, 9)),
        lesson(DateTime(2025, 10, 17, 9)),
      ],
      unpaid: [owed(anna, DateTime(2025, 10, 6, 9))],
    );
    expect(reminders.map((r) => r.id).toSet(), hasLength(reminders.length));
  });
}
