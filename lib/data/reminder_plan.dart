import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// Lesson reminders and weekly summaries go to separate Android channels, so
/// either can be muted in the system settings.
enum ReminderKind { lesson, weekly }

/// A notification to show at [at]; tapping it opens [route].
class PlannedReminder extends Equatable {
  final int id;
  final ReminderKind kind;
  final DateTime at;
  final String title;
  final String body;
  final String route;

  const PlannedReminder({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    required this.body,
    required this.route,
  });

  @override
  List<Object?> get props => [id, kind, at, title, body, route];
}

/// Decides which notifications to schedule. Nothing runs in the background,
/// so this is re-planned whenever data changes or the app opens, and weekly
/// messages are worded as of the moment they'll be shown.
abstract final class ReminderPlan {
  /// Lessons this far ahead get a reminder.
  static const horizon = Duration(days: 14);

  /// iOS keeps at most 64 pending notifications; leave room for the weekly
  /// ones.
  static const maxLessonReminders = 40;

  /// Weekly messages scheduled ahead, in case the app isn't opened for a
  /// while.
  static const weeksAhead = 2;

  /// A student counts as regular after a lesson in this many days.
  static const activeWindow = Duration(days: 28);

  /// Lessons [lessons] and unpaid charges [unpaid] must cover so the plan is
  /// complete: from [activeWindow] before the first weekly check to the end
  /// of the last week checked.
  static ({DateTime from, DateTime to}) dataRange(DateTime now, int weekStart) {
    final firstWeek = _nextWeekStart(now, weekStart);
    return (
      from: firstWeek.subtract(activeWindow),
      to: firstWeek.addDays(7 * weeksAhead),
    );
  }

  static List<PlannedReminder> plan({
    required DateTime now,
    required AppSettings settings,
    required AppLocalizations l10n,
    required String Function(double amount) money,
    required List<Lesson> lessons,
    required List<Participation> unpaid,
  }) {
    final time = DateFormat.jm(l10n.localeName);
    return [
      if (settings.lessonReminderMinutes > 0)
        ..._lessonReminders(
          now,
          settings.lessonReminderMinutes,
          l10n,
          time,
          lessons,
        ),
      if (settings.debtDigest)
        ..._debtDigests(now, settings.weekStart, l10n, money, unpaid),
      if (settings.bookingReminder)
        ..._bookingReminders(now, settings.weekStart, l10n, lessons),
    ];
  }

  // ── Lessons ──────────────────────────────────────────────────────────────

  static Iterable<PlannedReminder> _lessonReminders(
    DateTime now,
    int minutes,
    AppLocalizations l10n,
    DateFormat time,
    List<Lesson> lessons,
  ) {
    final before = Duration(minutes: minutes);
    final upcoming =
        lessons
            .where(
              (l) =>
                  !l.isCancelled &&
                  l.start.subtract(before).isAfter(now) &&
                  l.start.isBefore(now.add(horizon)),
            )
            .toList()
          ..sort((a, b) => a.start.compareTo(b.start));

    return upcoming.take(maxLessonReminders).map((lesson) {
      final who = lesson.subjects.map((s) => s.name).join(', ');
      return PlannedReminder(
        id: _lessonId(lesson.id!),
        kind: ReminderKind.lesson,
        at: lesson.start.subtract(before),
        title: minutes >= Duration.minutesPerDay
            ? l10n.reminderLessonTomorrow(lesson.name)
            : l10n.reminderLessonSoon(lesson.name, minutes),
        body: [time.format(lesson.start), if (who.isNotEmpty) who].join(' · '),
        route: '/lesson/${lesson.id}',
      );
    });
  }

  // ── Debts ────────────────────────────────────────────────────────────────

  /// 09:00 on the first day of each coming week: who owes money by then.
  static Iterable<PlannedReminder> _debtDigests(
    DateTime now,
    int weekStart,
    AppLocalizations l10n,
    String Function(double) money,
    List<Participation> unpaid,
  ) sync* {
    for (var week = 0; week < weeksAhead; week++) {
      final at = _nextWeekStart(
        now,
        weekStart,
      ).addDays(7 * week).add(const Duration(hours: 9));
      if (!at.isAfter(now)) continue;
      // Lessons that will have happened by then.
      final owing = Earnings.byStudent(
        Earnings.charges(unpaid.where((p) => p.start.isBefore(at))),
      ).where((s) => s.summary.unpaid > 0).toList();
      if (owing.isEmpty) continue;

      final total = owing.fold<double>(0, (sum, s) => sum + s.summary.unpaid);
      yield PlannedReminder(
        id: _debtDigestId + week,
        kind: ReminderKind.weekly,
        at: at,
        title: l10n.reminderDebtTitle(money(total)),
        body: _names(owing.map((s) => s.student.name).toList(), l10n),
        route: '/reports',
      );
    }
  }

  // ── Bookings ─────────────────────────────────────────────────────────────

  /// 18:00 the evening before each coming week: regular students with
  /// nothing booked that week.
  static Iterable<PlannedReminder> _bookingReminders(
    DateTime now,
    int weekStart,
    AppLocalizations l10n,
    List<Lesson> lessons,
  ) sync* {
    for (var week = 0; week < weeksAhead; week++) {
      final from = _nextWeekStart(now, weekStart).addDays(7 * week);
      final to = from.addDays(7);
      final at = from.addDays(-1).add(const Duration(hours: 18));
      if (!at.isAfter(now)) continue;

      Map<int, Student> studentsIn(DateTime start, DateTime end) => {
        for (final lesson in lessons)
          if (!lesson.isCancelled &&
              !lesson.start.isBefore(start) &&
              lesson.start.isBefore(end))
            for (final p in lesson.participants) p.student.id!: p.student,
      };
      final regulars = studentsIn(from.subtract(activeWindow), from);
      final booked = studentsIn(from, to);
      final unbooked = [
        for (final MapEntry(:key, :value) in regulars.entries)
          if (!booked.containsKey(key)) value.name,
      ]..sort();
      if (unbooked.isEmpty) continue;

      yield PlannedReminder(
        id: _bookingId + week,
        kind: ReminderKind.weekly,
        at: at,
        title: l10n.reminderBookingTitle(unbooked.length),
        body: _names(unbooked, l10n),
        route: '/schedule',
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static const _debtDigestId = 10;
  static const _bookingId = 20;
  static int _lessonId(int lessonId) => 1000 + lessonId;

  /// The first day of the week after the one containing [now].
  static DateTime _nextWeekStart(DateTime now, int weekStart) =>
      now.startOfWeek(weekStart).addDays(7);

  /// "Anna, Ben, Chris and 2 more".
  static String _names(List<String> names, AppLocalizations l10n) {
    const shown = 3;
    final head = names.take(shown).join(', ');
    return names.length <= shown
        ? head
        : l10n.reminderNamesAndMore(head, names.length - shown);
  }
}
