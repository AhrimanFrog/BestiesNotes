import 'package:besties_notes/cubits/notes/notes_cubit.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/widgets/notes/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  NotesCubit get _cubit => context.read<NotesCubit>();

  /// The editor changes notes; refresh on the way back.
  Future<void> _thenReload(Future<void> route) async {
    await route;
    if (mounted) await _cubit.load(quiet: true);
  }

  void _clearFilters() {
    _search.clear();
    _cubit
      ..setQuery('')
      ..setFilter(NoteFilter.all);
  }

  @override
  Widget build(BuildContext context) {
    // Notes are also written from student and lesson pages.
    return RefreshOnShow(
      location: '/notes',
      onShown: () => _cubit.load(quiet: true),
      child: _scaffold(context),
    );
  }

  Widget _scaffold(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.commonNotes),
        actions: const [
          SettingsButton(),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final notes = state.visible;
          final filtering =
              state.query.isNotEmpty || state.filter != NoteFilter.all;
          return Column(
            children: [
              if (state.notes.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    AppSpacing.sm,
                  ),
                  child: TextField(
                    controller: _search,
                    onChanged: _cubit.setQuery,
                    decoration: InputDecoration(
                      hintText: l10n.notesSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: state.query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              tooltip: l10n.clearSearch,
                              onPressed: () {
                                _search.clear();
                                _cubit.setQuery('');
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(
                        borderRadius: AppRadius.pillAll,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                    ).applyDefaults(Theme.of(context).inputDecorationTheme),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                    ),
                    children: [
                      for (final (filter, label) in [
                        (NoteFilter.all, l10n.filterAll),
                        (NoteFilter.general, l10n.notesFilterGeneral),
                        (NoteFilter.students, l10n.commonStudents),
                        (NoteFilter.lessons, l10n.notesFilterLessons),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: FilterChip(
                            label: Text(label),
                            selected: state.filter == filter,
                            onSelected: (_) => _cubit.setFilter(filter),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: StateTransitionWidget(
                  state: state,
                  isEmpty: notes.isEmpty,
                  onRetry: _cubit.load,
                  empty: filtering
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: l10n.commonNoMatches,
                          message: l10n.noMatchesMessage,
                          actionLabel: l10n.clearFilters,
                          onAction: _clearFilters,
                        )
                      : EmptyState(
                          icon: Icons.sticky_note_2_outlined,
                          title: l10n.notesEmptyTitle,
                          message: l10n.notesEmptyMessage,
                          actionLabel: l10n.notesNew,
                          onAction: () => _thenReload(context.createNote()),
                        ),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.sm,
                      AppSpacing.screen,
                      96, // Clear the FAB.
                    ),
                    itemCount: notes.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => NoteCard(
                      note: notes[i],
                      onTap: () => _thenReload(context.openNote(notes[i].id!)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Every tab's FAB lives on in the shell; default hero tags clash.
        heroTag: null,
        onPressed: () => _thenReload(context.createNote()),
        icon: const Icon(Icons.edit_note_rounded),
        label: Text(l10n.notesNew),
      ),
    );
  }
}
