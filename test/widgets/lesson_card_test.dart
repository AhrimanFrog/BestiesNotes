import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/widgets/cards/lesson_card.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mock cubit
// ---------------------------------------------------------------------------

class MockLessonsCubit extends MockCubit<LessonsState> implements LessonsCubit {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _rate = Rate(rate: 10.0, period: RatePeriod.monthly);

Student makeStudent({int id = 1, String name = 'Alice Smith'}) =>
    Student(id: id, name: name, contact: '', pricing: _rate);

LessonParticipant makeParticipant({
  int studentId = 1,
  String name = 'Alice Smith',
  bool attended = false,
  bool isPaid = false,
  bool homeworkDone = false,
}) => LessonParticipant(
  student: makeStudent(id: studentId, name: name),
  attended: attended,
  isPaid: isPaid,
  homeworkDone: homeworkDone,
);

Lesson makeLesson({
  int id = 1,
  String name = 'Grammar',
  LessonStatus status = LessonStatus.scheduled,
  List<Teachable>? subjects,
  List<LessonParticipant>? participants,
}) => Lesson(
  id: id,
  name: name,
  participants: participants ?? const [],
  start: DateTime(2025, 1, 15, 10, 0),
  duration: const Duration(hours: 1),
  status: status,
);

// ---------------------------------------------------------------------------
// Widget builder
// ---------------------------------------------------------------------------

Widget buildCard(
  Lesson lesson,
  MockLessonsCubit cubit, {
  VoidCallback? onClick,
}) {
  whenListen(
    cubit,
    Stream<LessonsState>.empty(),
    initialState: LessonsState(lessons: [lesson]),
  );
  return MaterialApp(
    home: BlocProvider<LessonsCubit>.value(
      value: cubit,
      child: Scaffold(
        body: LessonCard(lesson: lesson, onClick: onClick ?? () {}),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockLessonsCubit cubit;

  setUpAll(() {
    registerFallbackValue(LessonsState());
  });

  setUp(() {
    cubit = MockLessonsCubit();
  });

  group('header — content', () {
    testWidgets('shows the subject name for a single subject', (tester) async {
      final lesson = makeLesson(subjects: [makeStudent(name: 'Alice Smith')]);
      await tester.pumpWidget(buildCard(lesson, cubit));
      expect(find.text('Alice Smith'), findsOneWidget);
    });

    testWidgets('shows "& N more" label for multiple subjects', (tester) async {
      final lesson = makeLesson(subjects: [
        makeStudent(id: 1, name: 'Alice'),
        makeStudent(id: 2, name: 'Bob'),
        makeStudent(id: 3, name: 'Carol'),
      ]);
      await tester.pumpWidget(buildCard(lesson, cubit));
      // Shows first subject's initials + "& 2 more"
      expect(find.textContaining('& 2 more'), findsOneWidget);
    });

    testWidgets('shows lesson name/topic', (tester) async {
      final lesson = makeLesson(name: 'Present Simple');
      await tester.pumpWidget(buildCard(lesson, cubit));
      expect(find.text('Present Simple'), findsOneWidget);
    });

    testWidgets('shows status badge', (tester) async {
      final lesson = makeLesson(status: LessonStatus.completed);
      await tester.pumpWidget(buildCard(lesson, cubit));
      expect(find.text('Completed'), findsOneWidget);
    });
  });

  group('header — cancelled appearance', () {
    testWidgets('cancelled lesson has reduced opacity', (tester) async {
      final lesson = makeLesson(status: LessonStatus.cancelled);
      await tester.pumpWidget(buildCard(lesson, cubit));
      final opacity = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacity.opacity, closeTo(0.55, 0.01));
    });

    testWidgets('non-cancelled lesson has full opacity', (tester) async {
      final lesson = makeLesson(status: LessonStatus.scheduled);
      await tester.pumpWidget(buildCard(lesson, cubit));
      final opacity = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacity.opacity, closeTo(1.0, 0.01));
    });
  });

  group('expand/collapse', () {
    testWidgets('edit icon is not visible before expanding', (tester) async {
      final lesson = makeLesson(participants: [makeParticipant()]);
      await tester.pumpWidget(buildCard(lesson, cubit));
      // The edit button lives inside the collapsed AnimatedSize (zero height)
      expect(find.byIcon(Icons.edit_outlined), findsNothing);
    });

    testWidgets('tapping header expands participant list', (tester) async {
      final lesson = makeLesson(participants: [makeParticipant()]);
      await tester.pumpWidget(buildCard(lesson, cubit));
      // Tap the header GestureDetector (tap on lesson name area)
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
      // After expand, participant name appears in the participant row
      expect(find.text('Alice Smith'), findsWidgets);
    });

    testWidgets('shows "No participants" when expanded with empty list', (tester) async {
      final lesson = makeLesson(participants: []);
      await tester.pumpWidget(buildCard(lesson, cubit));
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
      expect(find.text('No participants'), findsOneWidget);
    });

    testWidgets('tapping header twice collapses list again', (tester) async {
      final lesson = makeLesson(participants: []);
      await tester.pumpWidget(buildCard(lesson, cubit));
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
      expect(find.text('No participants'), findsOneWidget);
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
      expect(find.text('No participants'), findsNothing);
    });
  });

  group('participant toggle dots', () {
    late Lesson lesson;

    setUp(() {
      lesson = makeLesson(participants: [makeParticipant(isPaid: false)]);
      when(
        () => cubit.updateParticipantStatus(
          any(),
          any(),
          attended: any(named: 'attended'),
          isPaid: any(named: 'isPaid'),
          homeworkDone: any(named: 'homeworkDone'),
        ),
      ).thenAnswer((_) async {});
    });

    Future<void> expand(WidgetTester tester) async {
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping Paid dot calls updateParticipantStatus', (tester) async {
      await tester.pumpWidget(buildCard(lesson, cubit));
      await expand(tester);
      await tester.tap(find.text('Paid'));
      verify(
        () => cubit.updateParticipantStatus(1, 1, isPaid: true),
      ).called(1);
    });

    testWidgets('tapping Here dot calls updateParticipantStatus', (tester) async {
      await tester.pumpWidget(buildCard(lesson, cubit));
      await expand(tester);
      await tester.tap(find.text('Here'));
      verify(
        () => cubit.updateParticipantStatus(1, 1, attended: true),
      ).called(1);
    });

    testWidgets('tapping Homework dot calls updateParticipantStatus', (tester) async {
      await tester.pumpWidget(buildCard(lesson, cubit));
      await expand(tester);
      await tester.tap(find.text('Homework'));
      verify(
        () => cubit.updateParticipantStatus(1, 1, homeworkDone: true),
      ).called(1);
    });

    testWidgets('toggle dots are disabled for cancelled lessons', (tester) async {
      final cancelledLesson = makeLesson(
        status: LessonStatus.cancelled,
        participants: [makeParticipant()],
      );
      await tester.pumpWidget(buildCard(cancelledLesson, cubit));
      await expand(tester);
      await tester.tap(find.text('Paid'));
      verifyNever(
        () => cubit.updateParticipantStatus(any(), any()),
      );
    });
  });

  group('onClick', () {
    testWidgets('edit button fires onClick when expanded', (tester) async {
      bool clicked = false;
      final lesson = makeLesson();
      await tester.pumpWidget(buildCard(lesson, cubit, onClick: () => clicked = true));
      await tester.tap(find.text('Grammar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(clicked, isTrue);
    });
  });
}
