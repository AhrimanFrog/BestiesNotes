import 'dart:async';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:besties_notes/data/app_settings.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/reminder_plan.dart';
import 'package:besties_notes/l10n/app_localizations.dart';
import 'package:besties_notes/providers/db_client.dart';
import 'package:besties_notes/providers/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Keeps the scheduled notifications in step with the data: re-plans shortly
/// after any change to the database (settings included) and whenever asked,
/// e.g. when the app comes back to the foreground.
class ReminderScheduler {
  final DbClient db;
  final NotificationService notifications;

  /// Batches bursts of writes (saving a lesson touches several tables).
  final Duration debounce;
  final DateTime Function() clock;

  StreamSubscription<void>? _changes;
  Timer? _pending;
  Future<void> _running = Future.value();

  ReminderScheduler(
    this.db,
    this.notifications, {
    this.debounce = const Duration(seconds: 2),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  void start() {
    _changes = db.tableUpdates().listen((_) => _scheduleSoon());
    reschedule();
  }

  /// Stops listening. A pass already running isn't waited for: if the
  /// database closes under it, it fails quietly (see [_reschedule]).
  Future<void> dispose() async {
    _pending?.cancel();
    await _changes?.cancel();
  }

  void _scheduleSoon() {
    _pending?.cancel();
    _pending = Timer(debounce, reschedule);
  }

  /// Re-plans everything; runs one at a time.
  Future<void> reschedule() {
    _pending?.cancel();
    return _running = _running.then((_) => _reschedule());
  }

  Future<void> _reschedule() async {
    try {
      final settings = AppSettings.fromMap(await db.loadSettings());
      final l10n = lookupAppLocalizations(_supported(settings.locale));
      await initializeDateFormatting(l10n.localeName);

      final now = clock();
      final range = ReminderPlan.dataRange(now, settings.weekStart);
      final horizonEnd = now.add(ReminderPlan.horizon);
      final (lessons, unpaid) = await (
        db.getLessonsForRange(
          range.from,
          horizonEnd.isAfter(range.to) ? horizonEnd : range.to,
        ),
        // Owed by the last weekly summary, so each can count what will
        // have been taught by its day.
        db.getParticipations(unpaidOnly: true, asOf: range.to),
      ).wait;

      final reminders = Intl.withLocale(
        l10n.localeName,
        () => ReminderPlan.plan(
          now: now,
          settings: settings,
          l10n: l10n,
          money: (amount) => formatMoney(amount, currency: settings.currency),
          lessons: lessons,
          unpaid: unpaid,
        ),
      );
      await notifications.replaceAll(
        reminders,
        lessonChannel: l10n.reminderChannelLessons,
        weeklyChannel: l10n.reminderChannelSummaries,
      );
    } catch (e, stack) {
      // Reminders are best-effort; never take the app down over them.
      debugPrint('Reminders not scheduled: $e\n$stack');
    }
  }

  /// The chosen language, else the device's, else English.
  static Locale _supported(Locale? chosen) {
    final locale = chosen ?? PlatformDispatcher.instance.locale;
    final supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    );
    return supported ? Locale(locale.languageCode) : const Locale('en');
  }
}
