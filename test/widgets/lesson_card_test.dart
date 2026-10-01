import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

LessonParticipant participant(
  int id,
  String name, {
  bool attended = false,
  bool isPaid = false,
}) => LessonParticipant(
  student: Student(id: id, name: name, contact: '', pricing: _rate),
  attended: attended,
  isPaid: isPaid,
  homeworkDone: false,
);

/// Defaults to a lesson that is already over.
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

Lesson upcoming() =>
    makeLesson(start: DateTime.now().add(const Duration(days: 1)));

void main() {
  group('content', () {
    testWidgets('shows topic, time and duration', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      expect(find.text('Present Simple'), findsOneWidget);
      expect(find.text('10:00 AM'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);
    });

    testWidgets('follows the device 24-hour setting', (tester) async {
      await tester.pumpThemed(
        MediaQuery(
          data: const MediaQueryData(alwaysUse24HourFormat: true),
          child: LessonCard(
            lesson: makeLesson(start: DateTime(2025, 1, 15, 14, 30)),
            onTap: () {},
          ),
        ),
      );
      expect(find.text('14:30'), findsOneWidget);
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
  });

  group('status', () {
    testWidgets('a past lesson is marked completed', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: makeLesson(), onTap: () {}));
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('a plain upcoming lesson has no badge', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: upcoming(), onTap: () {}));
      expect(find.text('Scheduled'), findsNothing);
    });

    testWidgets('the featured upcoming lesson says "Up next"', (tester) async {
      await tester.pumpThemed(
        LessonCard(lesson: upcoming(), onTap: () {}, featured: true),
      );
      expect(find.text('Up next'), findsOneWidget);
    });

    testWidgets('cancelled: badge and strikethrough', (tester) async {
      await tester.pumpThemed(
        LessonCard(lesson: makeLesson(isCancelled: true), onTap: () {}),
      );
      final topic = tester.widget<Text>(find.text('Present Simple'));
      expect(topic.style?.decoration, TextDecoration.lineThrough);
      expect(find.text('Cancelled'), findsOneWidget);
    });
  });

  group('attendance and payment', () {
    final mixed = [
      participant(1, 'Alice', attended: true, isPaid: true),
      participant(2, 'Bob', attended: true),
      participant(3, 'Carol'),
    ];

    testWidgets('past lessons show attendance and unpaid count', (
      tester,
    ) async {
      await tester.pumpThemed(
        LessonCard(
          lesson: makeLesson(participants: mixed),
          onTap: () {},
        ),
      );
      expect(find.text('2/3 present'), findsOneWidget);
      expect(find.text('2 unpaid'), findsOneWidget);
    });

    testWidgets('no unpaid badge once everyone paid', (tester) async {
      final paid = [participant(1, 'Alice', attended: true, isPaid: true)];
      await tester.pumpThemed(
        LessonCard(
          lesson: makeLesson(participants: paid),
          onTap: () {},
        ),
      );
      expect(find.textContaining('unpaid'), findsNothing);
    });

    testWidgets('upcoming and cancelled lessons show neither', (tester) async {
      await tester.pumpThemed(LessonCard(lesson: upcoming(), onTap: () {}));
      expect(find.textContaining('present'), findsNothing);

      await tester.pumpThemed(
        LessonCard(
          lesson: makeLesson(isCancelled: true, participants: mixed),
          onTap: () {},
        ),
      );
      expect(find.textContaining('present'), findsNothing);
      expect(find.textContaining('unpaid'), findsNothing);
    });
  });

  testWidgets('tapping the card calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpThemed(
      LessonCard(lesson: makeLesson(), onTap: () => tapped = true),
    );
    await tester.tap(find.text('Present Simple'));
    expect(tapped, isTrue);
  });
}
