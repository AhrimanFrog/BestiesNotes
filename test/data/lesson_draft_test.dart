import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rate = Rate(rate: 10, period: RatePeriod.perLesson);
  const anna = Student(id: 1, name: 'Anna', contact: '', pricing: rate);
  const ben = Student(id: 2, name: 'Ben', contact: '', pricing: rate);

  final base = LessonDraft(
    topic: 'Grammar',
    start: DateTime(2025, 1, 6, 10),
    durationMinutes: 60,
    subjects: const [anna, ben],
  );

  test('subject order does not make drafts different', () {
    expect(base.copyWith(subjects: const [ben, anna]), base);
  });

  test('any field change makes drafts different', () {
    expect(base.copyWith(topic: 'Vocabulary'), isNot(base));
    expect(base.copyWith(subjects: const [anna]), isNot(base));
  });

  test('isValid needs a topic, a duration and someone to teach', () {
    expect(base.isValid, isTrue);
    expect(base.copyWith(topic: '  ').isValid, isFalse);
    expect(base.copyWith(durationMinutes: 0).isValid, isFalse);
    expect(base.copyWith(subjects: const []).isValid, isFalse);
  });

  test('toLesson keeps id and cancellation of the edited lesson', () {
    final edited = Lesson(
      id: 9,
      name: 'Old',
      start: DateTime(2025),
      duration: const Duration(minutes: 30),
      isCancelled: true,
    );
    final lesson = base.copyWith(topic: '  Grammar  ').toLesson(base: edited);
    expect(lesson.id, 9);
    expect(lesson.isCancelled, isTrue);
    expect(lesson.name, 'Grammar');
    expect(lesson.duration, const Duration(minutes: 60));
  });

  test('a blank draft on another day starts at 10:00', () {
    final draft = LessonDraft.blank(date: DateTime(2030, 5, 17));
    expect(draft.start, DateTime(2030, 5, 17, 10));
    expect(draft.topic, isEmpty);
    expect(draft.durationMinutes, 60);
  });
}
