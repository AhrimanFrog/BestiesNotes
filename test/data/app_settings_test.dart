import 'package:besties_notes/data/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an empty store gives the defaults', () {
    final s = AppSettings.fromMap(const {});
    expect(s, const AppSettings());
    expect(s.defaultLessonMinutes, 60);
    expect(s.weekStart, DateTime.monday);
    expect(s.currency, isNull);
    expect(s.locale, isNull, reason: 'follow the system language');
  });

  test('round-trips through the key/value map', () {
    const s = AppSettings(
      teacherName: 'Olena',
      teacherContact: '@olena',
      defaultLessonMinutes: 45,
      weekStart: DateTime.sunday,
      currency: 'UAH',
      lessonColoring: LessonColoring.subject,
      languageCode: 'uk',
    );
    expect(AppSettings.fromMap(s.toMap()), s);
    expect(s.locale, const Locale('uk'));
    expect(s.colorBySubject, isTrue);
  });

  test('cleared optional values round-trip as "not set"', () {
    final s = const AppSettings(
      currency: 'EUR',
      languageCode: 'en',
    ).copyWith(currency: () => null, languageCode: () => null);
    expect(AppSettings.fromMap(s.toMap()).currency, isNull);
    expect(AppSettings.fromMap(s.toMap()).languageCode, isNull);
  });

  test('garbage values fall back instead of crashing', () {
    final s = AppSettings.fromMap(const {
      'default_lesson_minutes': '-5',
      'week_start': '3',
      'currency': 'XYZ',
      'lesson_coloring': 'rainbow',
      'language': 'de',
    });
    expect(s, const AppSettings());
  });
}
