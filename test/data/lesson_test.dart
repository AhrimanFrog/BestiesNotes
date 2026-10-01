import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rate = Rate(rate: 10, period: RatePeriod.perLesson);
  const club = Group(id: 1, name: 'Sat Conversation', pricing: rate);

  LessonParticipant member(int id, {Group? via}) => LessonParticipant(
    student: Student(id: id, name: 'S$id', contact: '', pricing: rate),
    attended: false,
    isPaid: false,
    homeworkDone: false,
    group: via,
  );

  Lesson lesson(List<LessonParticipant> participants) => Lesson(
    name: 'Speaking club',
    participants: participants,
    start: DateTime(2025, 1, 1),
    duration: const Duration(hours: 1),
  );

  group('subjects', () {
    test('a group appears once however many members attend', () {
      final l = lesson([member(1, via: club), member(2, via: club)]);
      expect(l.subjects, [club]);
    });
  });

  group('audienceLabel', () {
    test('names a lone group without counting its members', () {
      final l = lesson([member(1, via: club), member(2, via: club)]);
      expect(l.audienceLabel(), 'Sat Conversation');
    });

    test('counts other subjects', () {
      final l = lesson([member(1, via: club), member(2, via: club), member(3)]);
      expect(l.audienceLabel(), 'Sat Conversation +1');
    });

    test('says so when nobody is assigned', () {
      expect(lesson([]).audienceLabel(), 'No one assigned');
    });
  });
}
