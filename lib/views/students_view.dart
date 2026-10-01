import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/views/modals/group_form.dart';
import 'package:besties_notes/views/modals/student_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _confirmDeletion(BuildContext context, Teachable teachable) async {
    final cubit = context.read<StudentsAndGroupsCubit>();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete ${teachable.name}?',
      message: teachable is Group
          ? 'Members stay, they just leave the group.'
          : 'Their lesson history and payments will be removed too.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    if (teachable is Group) {
      await cubit.deleteGroup(teachable.id!);
    } else {
      await cubit.deleteStudent(teachable.id!);
    }
  }

  void _showForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentsAndGroupsCubit>(),
        child: _onGroupsTab ? const GroupForm(null) : const StudentForm(null),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  void _clearSearch(StudentsAndGroupsCubit cubit) {
    _searchController.clear();
    cubit.setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Groups'),
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
                        ? 'Search groups'
                        : 'Search students',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            tooltip: 'Clear search',
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
        onPressed: () => _showForm(context),
        icon: Icon(
          _onGroupsTab ? Icons.group_add_outlined : Icons.person_add_outlined,
        ),
        label: Text(_onGroupsTab ? 'Group' : 'Student'),
      ),
    );
  }

  /// "Nothing yet" vs. "nothing matches" — only the first gets a create CTA.
  Widget _emptyState({
    required StudentsAndGroupsState state,
    required StudentsAndGroupsCubit cubit,
    required bool groups,
  }) {
    final filtering = state.searchQuery.isNotEmpty || state.filterGroupId != null;
    if (filtering) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No matches',
        message: 'Try a different name or filter.',
        actionLabel: 'Clear filters',
        onAction: () {
          _clearSearch(cubit);
          cubit.setFilterGroup(null);
        },
      );
    }
    return groups
        ? EmptyState(
            icon: Icons.groups_outlined,
            title: 'No groups yet',
            message: 'Groups let you schedule several students at once.',
            actionLabel: 'Create a group',
            onAction: () => _showForm(context),
          )
        : EmptyState(
            icon: Icons.school_outlined,
            title: 'No students yet',
            message: 'Add the people you teach to start planning lessons.',
            actionLabel: 'Add a student',
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
                  (null, 'All'),
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
                  onTap: () => context.pushNamed(
                    'student',
                    pathParameters: {'id': '${student.id!}'},
                  ),
                  onDelete: () => _confirmDeletion(context, student),
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
            onTap: () => context.pushNamed(
              'group',
              pathParameters: {'id': '${group.id!}'},
            ),
            onDelete: () => _confirmDeletion(context, group),
          ),
      ]),
    );
  }
}
