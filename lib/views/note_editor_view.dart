import 'package:besties_notes/cubits/notes/note_editor_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/markdown_lite.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/dialogs/choice_sheet.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/widgets/notes/markdown_toolbar.dart';
import 'package:besties_notes/widgets/notes/markdown_view.dart';
import 'package:besties_notes/widgets/notes/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reads and edits one note. There's no save button: typing is saved after a
/// short pause, and leaving the screen saves whatever is pending.
class NoteEditorView extends StatelessWidget {
  const NoteEditorView({super.key});

  Future<void> _linkStudent(BuildContext context) async {
    final cubit = context.read<NoteEditorCubit>();
    final students = context.read<StudentsAndGroupsCubit>().state.students;
    final l10n = context.l10n;
    final picked = await showChoiceSheet<int?>(
      context,
      title: l10n.noteLinkStudent,
      options: [
        (null, l10n.noteUnlink),
        for (final s in students) (s.id, s.name),
      ],
      selected: cubit.state.note.studentId,
    );
    if (picked == null) return;
    final (id,) = picked;
    await cubit.linkStudent(students.where((s) => s.id == id).firstOrNull);
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.noteDeleteTitle,
      message: l10n.noteDeleteMessage,
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (confirmed && context.mounted) {
      await context.read<NoteEditorCubit>().delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<NoteEditorCubit>();
    return BlocConsumer<NoteEditorCubit, NoteEditorState>(
      listenWhen: (a, b) =>
          (!a.isDeleted && b.isDeleted) || (!a.saveFailed && b.saveFailed),
      listener: (context, state) {
        if (state.isDeleted) {
          Navigator.of(context).pop();
        } else {
          showErrorSnackBar(context, l10n.noteSaveFailed);
        }
      },
      builder: (context, state) {
        final note = state.note;
        return PopScope(
          // Save first, then leave, so the list behind is up to date.
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await cubit.flush();
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  tooltip: note.isPinned ? l10n.noteUnpin : l10n.notePin,
                  isSelected: note.isPinned,
                  icon: const Icon(Icons.push_pin_outlined),
                  selectedIcon: const Icon(Icons.push_pin_rounded),
                  onPressed: cubit.togglePin,
                ),
                if (state.isEditing)
                  TextButton(
                    onPressed: cubit.finishEditing,
                    child: Text(l10n.commonDone),
                  )
                else
                  IconButton(
                    tooltip: l10n.commonEdit,
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: cubit.startEditing,
                  ),
                PopupMenuButton<VoidCallback>(
                  tooltip: l10n.commonMore,
                  onSelected: (action) => action(),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: () => _linkStudent(context),
                      child: ListTile(
                        leading: const Icon(Icons.person_outline_rounded),
                        title: Text(l10n.noteLinkStudent),
                      ),
                    ),
                    if (note.lessonId != null)
                      PopupMenuItem(
                        value: cubit.unlinkLesson,
                        child: ListTile(
                          leading: const Icon(Icons.link_off_rounded),
                          title: Text(l10n.noteUnlink),
                        ),
                      ),
                    PopupMenuItem(
                      value: () => _delete(context),
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline_rounded,
                          color: context.tokens.danger,
                        ),
                        title: Text(
                          l10n.noteDelete,
                          style: TextStyle(color: context.tokens.danger),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
            ),
            body: StateTransitionWidget(
              state: state,
              onRetry: () => Navigator.of(context).pop(),
              child: state.isLoading
                  ? const SizedBox.shrink()
                  : state.isEditing
                  ? _Editor(initial: note, isNew: note.id == null)
                  : _Reader(state: state),
            ),
          ),
        );
      },
    );
  }
}

class _Reader extends StatelessWidget {
  final NoteEditorState state;

  const _Reader({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<NoteEditorCubit>();
    final note = state.note;
    final chips = noteLinkChips(context, note);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.xxxl,
      ),
      children: [
        GestureDetector(
          onTap: cubit.startEditing,
          child: Text(
            note.title.trim().isNotEmpty ? note.title : l10n.noteUntitled,
            style: context.textTheme.headlineSmall?.copyWith(
              color: note.title.trim().isEmpty
                  ? context.tokens.textSubtle
                  : null,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...chips,
            if (note.updatedAt case final at?)
              Text(
                at.toMediumDateFormat(),
                style: context.textTheme.labelMedium,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (note.body.trim().isEmpty)
          GestureDetector(
            onTap: cubit.startEditing,
            child: Text(
              l10n.noteBodyHint,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.tokens.textSubtle,
              ),
            ),
          )
        else
          MarkdownView(body: note.body, onToggleCheckbox: cubit.toggleCheckbox),
      ],
    );
  }
}

class _Editor extends StatefulWidget {
  final Note initial;
  final bool isNew;

  const _Editor({required this.initial, required this.isNew});

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  // Seeded once; the cubit's note is the source of truth afterwards.
  late final _title = TextEditingController(text: widget.initial.title);
  late final _body = TextEditingController(text: widget.initial.body);
  final _bodyFocus = FocusNode();

  NoteEditorCubit get _cubit => context.read<NoteEditorCubit>();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final chips = noteLinkChips(
      context,
      context.select((NoteEditorCubit c) => c.state.note),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.xl,
            ),
            children: [
              TextField(
                controller: _title,
                // A new note starts at the title.
                autofocus: widget.isNew,
                style: textTheme.headlineSmall,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _bodyFocus.requestFocus(),
                decoration: _bare(l10n.noteTitleHint, textTheme.headlineSmall),
                onChanged: _cubit.updateTitle,
              ),
              if (chips.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: chips,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _body,
                focusNode: _bodyFocus,
                style: textTheme.bodyLarge,
                maxLines: null,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [ListContinuationFormatter()],
                decoration: _bare(l10n.noteBodyHint, textTheme.bodyLarge),
                onChanged: _cubit.updateBody,
              ),
              Text(l10n.noteFormatHint, style: textTheme.bodySmall),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: MarkdownToolbar(
            controller: _body,
            onChanged: (text) {
              _cubit.updateBody(text);
              _bodyFocus.requestFocus();
            },
          ),
        ),
      ],
    );
  }

  /// A borderless field: the note reads like a page, not a form.
  InputDecoration _bare(String hint, TextStyle? style) => InputDecoration(
    hintText: hint,
    hintStyle: style?.copyWith(color: context.tokens.textSubtle),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: false,
    contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    isDense: true,
  );
}
