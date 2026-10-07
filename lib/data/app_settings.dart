import 'dart:ui' show Locale;

import 'package:equatable/equatable.dart';

enum LessonColoring { status, subject }

/// The user's preferences. Stored as string key/value pairs (see
/// `SettingsProvider`); anything missing or unreadable falls back to a
/// default, so old or hand-edited backups still load.
class AppSettings extends Equatable {
  final String teacherName;
  final String teacherContact;
  final int defaultLessonMinutes;

  /// [DateTime.monday] or [DateTime.sunday].
  final int weekStart;

  /// ISO 4217 code ("UAH"), or null to show bare amounts.
  final String? currency;

  final LessonColoring lessonColoring;

  /// "en" / "uk", or null to follow the system language.
  final String? languageCode;

  /// How long before a lesson to remind; 0 turns lesson reminders off.
  final int lessonReminderMinutes;

  /// Weekly "who owes you" notification.
  final bool debtDigest;

  /// Weekly "these students have no lessons next week" notification.
  final bool bookingReminder;

  const AppSettings({
    this.teacherName = '',
    this.teacherContact = '',
    this.defaultLessonMinutes = 60,
    this.weekStart = DateTime.monday,
    this.currency,
    this.lessonColoring = LessonColoring.status,
    this.languageCode,
    this.lessonReminderMinutes = 15,
    this.debtDigest = true,
    this.bookingReminder = true,
  });

  static const currencies = ['UAH', 'USD', 'EUR', 'GBP', 'PLN'];
  static const lessonLengths = [30, 45, 60, 90, 120];
  static const languages = ['en', 'uk'];

  /// Off, minutes before, or a day before.
  static const reminderOptions = [0, 15, 30, 60, 1440];

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);
  bool get colorBySubject => lessonColoring == LessonColoring.subject;

  static const _name = 'teacher_name';
  static const _contact = 'teacher_contact';
  static const _minutes = 'default_lesson_minutes';
  static const _weekStart = 'week_start';
  static const _currency = 'currency';
  static const _coloring = 'lesson_coloring';
  static const _language = 'language';
  static const _reminder = 'lesson_reminder_minutes';
  static const _debtDigest = 'debt_digest';
  static const _bookingReminder = 'booking_reminder';

  factory AppSettings.fromMap(Map<String, String> map) {
    const defaults = AppSettings();
    final minutes = int.tryParse(map[_minutes] ?? '');
    final weekStart = int.tryParse(map[_weekStart] ?? '');
    final currency = map[_currency];
    final language = map[_language];
    final reminder = int.tryParse(map[_reminder] ?? '');
    bool flag(String key, bool fallback) => switch (map[key]) {
      'true' => true,
      'false' => false,
      _ => fallback,
    };
    return AppSettings(
      teacherName: map[_name] ?? defaults.teacherName,
      teacherContact: map[_contact] ?? defaults.teacherContact,
      defaultLessonMinutes: minutes != null && minutes > 0
          ? minutes
          : defaults.defaultLessonMinutes,
      weekStart: weekStart == DateTime.sunday
          ? DateTime.sunday
          : DateTime.monday,
      currency: currencies.contains(currency) ? currency : null,
      lessonColoring: LessonColoring.values.firstWhere(
        (c) => c.name == map[_coloring],
        orElse: () => defaults.lessonColoring,
      ),
      languageCode: languages.contains(language) ? language : null,
      lessonReminderMinutes: reminderOptions.contains(reminder)
          ? reminder!
          : defaults.lessonReminderMinutes,
      debtDigest: flag(_debtDigest, defaults.debtDigest),
      bookingReminder: flag(_bookingReminder, defaults.bookingReminder),
    );
  }

  /// Empty strings stand for "not set" (no currency, system language).
  Map<String, String> toMap() => {
    _name: teacherName,
    _contact: teacherContact,
    _minutes: '$defaultLessonMinutes',
    _weekStart: '$weekStart',
    _currency: currency ?? '',
    _coloring: lessonColoring.name,
    _language: languageCode ?? '',
    _reminder: '$lessonReminderMinutes',
    _debtDigest: '$debtDigest',
    _bookingReminder: '$bookingReminder',
  };

  /// [currency] and [languageCode] take builders so they can be cleared.
  AppSettings copyWith({
    String? teacherName,
    String? teacherContact,
    int? defaultLessonMinutes,
    int? weekStart,
    String? Function()? currency,
    LessonColoring? lessonColoring,
    String? Function()? languageCode,
    int? lessonReminderMinutes,
    bool? debtDigest,
    bool? bookingReminder,
  }) {
    return AppSettings(
      teacherName: teacherName ?? this.teacherName,
      teacherContact: teacherContact ?? this.teacherContact,
      defaultLessonMinutes: defaultLessonMinutes ?? this.defaultLessonMinutes,
      weekStart: weekStart ?? this.weekStart,
      currency: currency != null ? currency() : this.currency,
      lessonColoring: lessonColoring ?? this.lessonColoring,
      languageCode: languageCode != null ? languageCode() : this.languageCode,
      lessonReminderMinutes:
          lessonReminderMinutes ?? this.lessonReminderMinutes,
      debtDigest: debtDigest ?? this.debtDigest,
      bookingReminder: bookingReminder ?? this.bookingReminder,
    );
  }

  @override
  List<Object?> get props => [
    teacherName,
    teacherContact,
    defaultLessonMinutes,
    weekStart,
    currency,
    lessonColoring,
    languageCode,
    lessonReminderMinutes,
    debtDigest,
    bookingReminder,
  ];
}
