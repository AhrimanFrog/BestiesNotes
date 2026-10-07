import 'package:besties_notes/cubits/notes/note_editor_cubit.dart';
import 'package:besties_notes/cubits/notes/notes_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/notes_provider.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesProvider extends Mock implements NotesProvider {}

class MockDataProvider extends Mock implements DataProvider {}

const general = Note(id: 1, title: 'Ideas', body: 'warm-up games');
const aboutAnna = Note(
  id: 2,
  title: 'Anna',
  body: 'struggles with articles',
  studentId: 7,
  studentName: 'Anna',
);
const pinnedLesson = Note(
  id: 3,
  title: 'Plan',
  lessonId: 4,
  lessonName: 'Grammar',
  isPinned: true,
);

void main() {
  late MockNotesProvider notes;
  late MockDataProvider data;

  setUpAll(() => registerFallbackValue(const Note()));

  setUp(() {
    notes = MockNotesProvider();
    data = MockDataProvider();
    when(
      () => notes.getNotes(
        studentId: any(named: 'studentId'),
        lessonId: any(named: 'lessonId'),
      ),
    ).thenAnswer((_) async => [general, aboutAnna, pinnedLesson]);
    when(() => notes.setNotePinned(any(), any())).thenAnswer((_) async {});
  });

  group('NotesCubit', () {
    blocTest<NotesCubit, NotesState>(
      'pinned notes come first',
      build: () => NotesCubit(notes),
      act: (c) => c.load(),
      verify: (c) => expect(c.state.visible.map((n) => n.id), [3, 1, 2]),
    );

    blocTest<NotesCubit, NotesState>(
      'search covers text and what a note is linked to',
      build: () => NotesCubit(notes),
      act: (c) async {
        await c.load();
        c.setQuery('ANNA');
      },
      verify: (c) => expect(c.state.visible, [aboutAnna]),
    );

    blocTest<NotesCubit, NotesState>(
      'filters by what notes are linked to',
      build: () => NotesCubit(notes),
      act: (c) => c.load(),
      verify: (c) {
        List<int?> ids(NoteFilter f) => [
          for (final n in c.state.copyWith(filter: f).visible) n.id,
        ];
        expect(ids(NoteFilter.general), [1]);
        expect(ids(NoteFilter.students), [2]);
        expect(ids(NoteFilter.lessons), [3]);
      },
    );

    blocTest<NotesCubit, NotesState>(
      'a failed pin is reverted',
      build: () => NotesCubit(notes),
      setUp: () => when(
        () => notes.setNotePinned(any(), any()),
      ).thenThrow(Exception('disk')),
      act: (c) async {
        await c.load();
        await c.togglePin(general);
      },
      verify: (c) => expect(c.state.notes.first.isPinned, isFalse),
    );

    blocTest<NotesCubit, NotesState>(
      "a student's notes ask only for theirs",
      build: () => NotesCubit(notes, studentId: 7),
      act: (c) => c.load(),
      verify: (_) =>
          verify(() => notes.getNotes(studentId: 7, lessonId: null)).called(1),
    );
  });

  group('NoteEditorCubit', () {
    var nextId = 10;

    setUp(() {
      when(() => notes.saveNote(any())).thenAnswer(
        (i) async => (i.positionalArguments.single as Note).id ?? nextId++,
      );
      when(() => notes.getNote(1)).thenAnswer((_) async => general);
      when(() => notes.deleteNote(any())).thenAnswer((_) async {});
      when(() => data.getStudent(7)).thenAnswer(
        (_) async => const Student(
          id: 7,
          name: 'Anna',
          contact: '',
          pricing: Rate(rate: 1, period: RatePeriod.perLesson),
        ),
      );
    });

    NoteEditorCubit build() =>
        NoteEditorCubit(notes, data, autosaveDelay: Duration.zero);

    test('a blank new note is never stored', () async {
      final cubit = build();
      await cubit.startNew();
      cubit.updateTitle('   ');
      await cubit.close();
      verifyNever(() => notes.saveNote(any()));
    });

    test('typing is saved once, then updates the same note', () async {
      final cubit = build();
      await cubit.startNew(studentId: 7);
      expect(cubit.state.note.studentName, 'Anna', reason: 'chip label');

      cubit.updateTitle('Homework');
      await cubit.flush();
      expect(cubit.state.note.id, isNotNull);
      expect(cubit.state.isDirty, isFalse);

      cubit.updateBody('- [ ] page 12');
      await cubit.flush();
      final saved = verify(() => notes.saveNote(captureAny())).captured;
      expect(saved, hasLength(2));
      expect((saved.first as Note).id, isNull, reason: 'created');
      expect((saved.last as Note).id, cubit.state.note.id, reason: 'updated');
      expect((saved.last as Note).studentId, 7);
      await cubit.close();
    });

    test('typing saves by itself after a pause', () async {
      final cubit = NoteEditorCubit(
        notes,
        data,
        autosaveDelay: const Duration(milliseconds: 10),
      );
      await cubit.load(1);
      cubit.updateBody('more games');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      verify(() => notes.saveNote(any())).called(1);
      await cubit.close();
    });

    test('closing saves what is pending', () async {
      final cubit = NoteEditorCubit(
        notes,
        data,
        autosaveDelay: const Duration(hours: 1),
      );
      await cubit.load(1);
      cubit.updateTitle('Ideas!');
      await cubit.close();
      final saved = verify(() => notes.saveNote(captureAny())).captured;
      expect((saved.single as Note).title, 'Ideas!');
    });

    test('ticking a checkbox in read mode saves at once', () async {
      when(
        () => notes.getNote(5),
      ).thenAnswer((_) async => const Note(id: 5, body: 'a\n- [ ] b'));
      final cubit = build();
      await cubit.load(5);
      await cubit.toggleCheckbox(1);
      expect(cubit.state.note.body, 'a\n- [x] b');
      verify(() => notes.saveNote(any())).called(1);
      await cubit.close();
    });

    test('nothing changed, nothing saved', () async {
      final cubit = build();
      await cubit.load(1);
      cubit
        ..startEditing()
        ..updateTitle('Ideas');
      await cubit.finishEditing();
      verifyNever(() => notes.saveNote(any()));
      expect(cubit.state.isEditing, isFalse);
      await cubit.close();
    });

    test('delete removes the note and leaves', () async {
      final cubit = build();
      await cubit.load(1);
      await cubit.delete();
      verify(() => notes.deleteNote(1)).called(1);
      expect(cubit.state.isDeleted, isTrue);
      await cubit.close();
    });
  });
}
