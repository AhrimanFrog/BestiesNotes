import 'package:besties_notes/data/ui_models/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/views/modals/student_form.dart';
import 'package:besties_notes/views/modals/group_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  final double inset = 10;
  final _searchController = TextEditingController();
  late final TabController _tabController;

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

  void _showDeletionConfirmation(BuildContext context, Teachable teachable) {
    final cubit = context.read<StudentsAndGroupsCubit>();
    final del = teachable is Group ? cubit.deleteGroup : cubit.deleteStudent;
    showDialog(
      context: context,
      builder: (_) => DeletionDialog(
        entryName: teachable.name,
        onDelete: () => del(teachable.id!),
      ),
    );
  }

  void _showForm(BuildContext context, Group? group) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentsAndGroupsCubit>(),
        child: _tabController.index == 0 ? StudentForm(null) : GroupForm(group),
      ),
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showForm(context, null),
          ),
        ],
      ),
      body: GradientBackground(
        child: BlocBuilder<StudentsAndGroupsCubit, StudentsAndGroupsState>(
          builder: (context, state) {
            final cubit = context.read<StudentsAndGroupsCubit>();

            return SafeArea(
              minimum: EdgeInsets.all(inset),
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: cubit.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: _tabController.index == 0
                            ? 'Search students...'
                            : 'Search groups...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.secondaryText,
                        ),
                        suffixIcon: state.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.secondaryText,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  cubit.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.softPink,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.softPink,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.accentPink,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sub-tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.accentPink,
                    unselectedLabelColor: AppColors.secondaryText,
                    indicatorColor: AppColors.accentPink,
                    tabs: const [
                      Tab(text: 'Students'),
                      Tab(text: 'Groups'),
                    ],
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildStudentsTab(state, cubit),
                        _buildGroupsTab(state),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentsTab(
    StudentsAndGroupsState state,
    StudentsAndGroupsCubit cubit,
  ) {
    final filtered = state.filteredStudents;

    return StateTransitionWidget(
      state: state,
      child: Column(
        children: [
          // Group filter chips
          if (state.groups.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: state.filterGroupId == null,
                        onSelected: (_) => cubit.setFilterGroup(null),
                        selectedColor: AppColors.softWarmPink,
                        checkmarkColor: AppColors.accentPink,
                      ),
                    ),
                    for (final group in state.groups)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(group.name),
                          selected: state.filterGroupId == group.id,
                          onSelected: (_) => cubit.setFilterGroup(
                            state.filterGroupId == group.id ? null : group.id,
                          ),
                          selectedColor: AppColors.softWarmPink,
                          checkmarkColor: AppColors.accentPink,
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // Student grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: inset,
              crossAxisSpacing: inset,
              childAspectRatio: 0.75,
              children: [
                for (final student in filtered)
                  ParticipantCard(
                    participant: student,
                    onTap: () => context.pushNamed(
                      'student',
                      pathParameters: {'id': '${student.id!}'},
                    ),
                    onDelete: () => _showDeletionConfirmation(context, student),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab(StudentsAndGroupsState state) {
    return StateTransitionWidget(
      state: state,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: inset,
        crossAxisSpacing: inset,
        childAspectRatio: 0.75,
        children: [
          for (final group in state.filteredGroups)
            ParticipantCard(
              participant: group,
              onTap: () => context.pushNamed(
                'group',
                pathParameters: {'id': '${group.id!}'},
              ),
              onDelete: () => _showDeletionConfirmation(context, group),
            ),
        ],
      ),
    );
  }
}
