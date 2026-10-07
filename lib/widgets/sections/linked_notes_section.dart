import 'package:besties_notes/cubits/notes/notes_cubit.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/providers/notes_provider.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/layout/section.dart';
import 'package:besties_notes/widgets/notes/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The notes about one student or one lesson, with "Add note" (which links
/// the new note to it).
class LinkedNotesSection extends StatelessWidget {
  final int? studentId;
  final int? lessonId;

  const LinkedNotesSection({super.key, this.studentId, this.lessonId})
    : assert((studentId == null) != (lessonId == null));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit(
        context.read<NotesProvider>(),
        studentId: studentId,
        lessonId: lessonId,
      )..load(),
      child: _Body(studentId: studentId, lessonId: lessonId),
    );
  }
}

class _Body extends StatelessWidget {
  final int? studentId;
  final int? lessonId;

  const _Body({this.studentId, this.lessonId});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<NotesCubit>();
    // Edits happen in the editor; refresh on the way back.
    Future<void> thenReload(Future<void> route) async {
      await route;
      await cubit.load(quiet: true);
    }

    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        final notes = state.visible;
        return Section(
          title: l10n.commonNotes,
          actionLabel: l10n.notesAdd,
          onAction: () => thenReload(
            context.createNote(studentId: studentId, lessonId: lessonId),
          ),
          child: notes.isEmpty
              ? Text(l10n.notesNoneLinked, style: context.textTheme.bodySmall)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.sm,
                  children: [
                    for (final note in notes)
                      NoteCard(
                        note: note,
                        // The page itself is what they're linked to.
                        showLink: false,
                        onTap: () => thenReload(context.openNote(note.id!)),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
