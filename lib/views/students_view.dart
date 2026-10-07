import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late final TabController _tabController;

  bool get _onGroupsTab => _tabController.index == 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
      context.read<StudentsAndGroupsCubit>().setActiveTab(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Detail screens can change anything listed here (including balances via
  /// lessons), so refresh on return.
  Future<void> _thenRefresh(Future<void> route) async {
    await route;
    if (mounted) await context.read<StudentsAndGroupsCubit>().refresh();
  }

  void _showForm(BuildContext context) => _thenRefresh(
    _onGroupsTab ? context.createGroup() : context.createStudent(),
  );

  void _clearSearch(StudentsAndGroupsCubit cubit) {
    _searchController.clear();
    cubit.setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.studentsTitle),
        actions: const [
          SettingsButton(),
          SizedBox(width: AppSpacing.xs),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.commonStudents),
            Tab(text: l10n.commonGroups),
          ],
        ),
      ),
      body: BlocBuilder<StudentsAndGroupsCubit, StudentsAndGroupsState>(
        builder: (context, state) {
          final cubit = context.read<StudentsAndGroupsCubit>();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.md,
                  AppSpacing.screen,
                  AppSpacing.sm,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: cubit.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: _onGroupsTab
                        ? l10n.groupsSearch
                        : l10n.studentsSearch,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            tooltip: l10n.clearSearch,
                            onPressed: () => _clearSearch(cubit),
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
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStudentsTab(state, cubit),
                    _buildGroupsTab(state, cubit),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Both tabs' FABs live on in the shell; default hero tags clash.
        heroTag: null,
        onPressed: () => _showForm(context),
        icon: Icon(
          _onGroupsTab ? Icons.group_add_outlined : Icons.person_add_outlined,
        ),
        label: Text(_onGroupsTab ? l10n.fabGroup : l10n.fabStudent),
      ),
    );
  }

  /// "Nothing yet" vs. "nothing matches" — only the first gets a create CTA.
  Widget _emptyState({
    required StudentsAndGroupsState state,
    required StudentsAndGroupsCubit cubit,
    required bool groups,
  }) {
    final l10n = context.l10n;
    final filtering =
        state.searchQuery.isNotEmpty || state.filterGroupId != null;
    if (filtering) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: l10n.commonNoMatches,
        message: l10n.noMatchesMessage,
        actionLabel: l10n.clearFilters,
        onAction: () {
          _clearSearch(cubit);
          cubit.setFilterGroup(null);
        },
      );
    }
    return groups
        ? EmptyState(
            icon: Icons.groups_outlined,
            title: l10n.noGroupsTitle,
            message: l10n.noGroupsMessage,
            actionLabel: l10n.noGroupsAction,
            onAction: () => _showForm(context),
          )
        : EmptyState(
            icon: Icons.school_outlined,
            title: l10n.noStudentsTitle,
            message: l10n.noStudentsMessage,
            actionLabel: l10n.noStudentsAction,
            onAction: () => _showForm(context),
          );
  }

  Widget _grid(List<Widget> children) {
    // Avatar + padding are fixed; the three text lines grow with text size.
    final textHeight = MediaQuery.textScalerOf(context).scale(76);
    return GridView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        96,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: 104 + textHeight,
      ),
      children: children,
    );
  }

  Widget _buildStudentsTab(
    StudentsAndGroupsState state,
    StudentsAndGroupsCubit cubit,
  ) {
    final filtered = state.filteredStudents;

    return Column(
      children: [
        if (state.groups.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              children: [
                for (final (id, label) in [
                  (null, context.l10n.filterAll),
                  for (final g in state.groups) (g.id, g.name),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(label),
                      selected: state.filterGroupId == id,
                      onSelected: (_) => cubit.setFilterGroup(
                        id != null && state.filterGroupId == id ? null : id,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: StateTransitionWidget(
            state: state,
            isEmpty: filtered.isEmpty,
            onRetry: cubit.fetchStudents,
            empty: _emptyState(state: state, cubit: cubit, groups: false),
            child: _grid([
              for (final student in filtered)
                ParticipantCard(
                  participant: student,
                  owed: state.owedBy(student),
                  onTap: () => _thenRefresh(context.openStudent(student.id!)),
                ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsTab(
    StudentsAndGroupsState state,
    StudentsAndGroupsCubit cubit,
  ) {
    final filtered = state.filteredGroups;

    return StateTransitionWidget(
      state: state,
      isEmpty: filtered.isEmpty,
      onRetry: cubit.fetchGroups,
      empty: _emptyState(state: state, cubit: cubit, groups: true),
      child: _grid([
        for (final group in filtered)
          ParticipantCard(
            participant: group,
            subtitle: context.l10n.memberCount(state.memberCount(group)),
            onTap: () => _thenRefresh(context.openGroup(group.id!)),
          ),
      ]),
    );
  }
}
