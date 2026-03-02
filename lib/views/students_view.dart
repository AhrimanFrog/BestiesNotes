import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/views/student_details_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/student.dart';
import 'package:besties_notes/data/ui_models/group.dart';
import 'package:besties_notes/views/modals/student_form.dart';
import 'package:besties_notes/views/modals/group_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:besties_notes/common/app_colors.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  final double inset = 2;
  final _searchController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteStudentConfirmation(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (student.id != null) {
                final cubit = context.read<StudentsAndGroupsCubit>();
                cubit.deleteStudent(student.id!);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupConfirmation(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete ${group.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (group.id != null) {
                final cubit = context.read<StudentsAndGroupsCubit>();
                cubit.deleteGroup(group.id!);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStudentForm(BuildContext context, Student? student) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentsAndGroupsCubit>(),
        child: StudentForm(student),
      ),
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
    );
  }

  void _showGroupForm(BuildContext context, Group? group) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentsAndGroupsCubit>(),
        child: GroupForm(group),
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
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_tabController.index == 0) {
                _showStudentForm(context, null);
              } else {
                _showGroupForm(context, null);
              }
            },
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
    if (state.isLoading && state.students.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.students.isEmpty) {
      return Center(child: Text(state.error!));
    }

    final filtered = state.filteredStudents;

    return Column(
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
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    state.students.isEmpty
                        ? 'No students yet'
                        : 'No students match your search',
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: inset,
                  crossAxisSpacing: inset,
                  childAspectRatio: 0.75,
                  children: [
                    for (final student in filtered)
                      ParticipantCard(
                        participant: student,
                        onTap: () => BlocProvider(
                          create: (_) =>
                              StudentDetailsCubit(context.read<ScheduleRepo>()),
                          child: StudentDetailsView(student: student),
                        ),
                        onDelete: () =>
                            _showDeleteStudentConfirmation(context, student),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildGroupsTab(StudentsAndGroupsState state) {
    if (state.isLoading && state.groups.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.groups.isEmpty) {
      return Center(child: Text(state.error!));
    }

    final filtered = state.filteredGroups;

    return filtered.isEmpty
        ? Center(
            child: Text(
              state.groups.isEmpty
                  ? 'No groups yet'
                  : 'No groups match your search',
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 16,
              ),
            ),
          )
        : GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: inset,
            crossAxisSpacing: inset,
            childAspectRatio: 0.75,
            children: [
              for (final group in filtered)
                ParticipantCard(
                  participant: group,
                  onTap: () => _showGroupForm(context, group),
                  onDelete: () => _showDeleteGroupConfirmation(context, group),
                ),
            ],
          );
  }
}
