import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

LessonParticipant participant(int id, String name) => LessonParticipant(
  student: Student(id: id, name: name, contact: '', pricing: _rate),
  attended: false,
  isPaid: false,
  homeworkDone: false,
);

Lesson makeLesson({
  bool isCancelled = false,
  DateTime? start,
  List<LessonParticipant>? participants,
}) => Lesson(
  id: 1,
  name: 'Present Simple',
  participants: participants ?? [participant(1, 'Alice Smith')],
  start: start ?? DateTime(2025, 1, 15, 10, 0),
  duration: const Duration(minutes: 45),
  isCancelled: isCancelled,
);

void main() {
  group('content', () {
    testWidgets('shows topic, time and duration', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      expect(find.text('Present Simple'), findsOneWidget);
      expect(find.text('10:00 · 45 min'), findsOneWidget);
    });

    testWidgets('shows a single participant by name', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      expect(find.text('Alice Smith'), findsOneWidget);
    });

    testWidgets('summarizes several participants', (tester) async {
      final lesson = makeLesson(
        participants: [
          participant(1, 'Alice Smith'),
          participant(2, 'Bob'),
          participant(3, 'Carol'),
        ],
      );
      await tester.pumpThemed(LessonCard(lesson: lesson, onTap: () {}));
      expect(find.text('Alice Smith +2'), findsOneWidget);
    });

    testWidgets('shows the status badge', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      expect(find.text('Completed'), findsOneWidget);
    });
  });

  group('cancelled appearance', () {
    testWidgets('strikes through the topic', (tester) async {
      await tester.pumpThemed(
        LessonCard(lesson: makeLesson(isCancelled: true), onTap: () {}),
      );
      final topic = tester.widget<Text>(find.text('Present Simple'));
      expect(topic.style?.decoration, TextDecoration.lineThrough);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('a regular lesson has no strikethrough', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      final topic = tester.widget<Text>(find.text('Present Simple'));
      expect(topic.style?.decoration, isNot(TextDecoration.lineThrough));
    });
  });

  group('actions', () {
    testWidgets('tapping the card calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpThemed(
        LessonCard(lesson: makeLesson(), onTap: () => tapped = true),
      );
      await tester.tap(find.text('Present Simple'));
      expect(tapped, isTrue);
    });

    testWidgets('cancel button shows only for upcoming lessons', (tester) async {
      final upcoming = makeLesson(
        start: DateTime.now().add(const Duration(days: 1)),
      );
      await tester.pumpThemed(
        LessonCard(lesson: upcoming, onTap: () {}, onCancel: () {}),
      );
      expect(find.text('Cancel lesson'), findsOneWidget);

      await tester.pumpThemed(
        LessonCard(lesson: makeLesson(), onTap: () {}, onCancel: () {}),
      );
      expect(find.text('Cancel lesson'), findsNothing);
    });
  });
}
