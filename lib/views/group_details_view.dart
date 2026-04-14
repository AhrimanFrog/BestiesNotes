import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/views/modals/group_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupDetailsView extends StatefulWidget {
  final int groupId;

  const GroupDetailsView({super.key, required this.groupId});

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<GroupDetailsCubit>();
    cubit.loadGroup(widget.groupId);
    cubit.loadLessons(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.group.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        StudentsAndGroupsCubit(context.read<DataProvider>()),
                    child: GroupForm(state.group),
                  ),
                ),
              ),
            ],
          ),
          body: GradientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _GroupHeaderCard(group: state.group),
                const SizedBox(height: 12),
                _NavigationChipsRow(groupId: widget.groupId),
                const SizedBox(height: 20),
                _MembersSection(state: state),
                const SizedBox(height: 20),
                StateTransitionWidget(
                  state: state,
                  child: RecentLessonsSection(
                    lessons: state.lessons,
                    onSeeAll: () => context.pushNamed(
                      'group_lessons_history',
                      pathParameters: {'id': '${widget.groupId}'},
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _GroupHeaderCard extends StatelessWidget {
  final Group group;

  const _GroupHeaderCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        spacing: 16,
        children: [
          UserAvatar(teachable: group),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainText,
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.group_outlined,
                      size: 14,
                      color: AppColors.secondaryText,
                    ),
                    Text(
                      '${group.students.length} members',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  label: group.pricing.toString(),
                  accentColor: AppColors.accentPink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Navigation chips ────────────────────────────────────────────────────────

class _NavigationChipsRow extends StatelessWidget {
  final int groupId;

  const _NavigationChipsRow({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          NavigationChip(
            icon: Icons.payments_outlined,
            label: 'Payments',
            color: AppColors.accentGreen,
            onTap: () => context.pushNamed(
              'group_payments',
              pathParameters: {'id': '$groupId'},
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Members ─────────────────────────────────────────────────────────────────

class _MembersSection extends StatelessWidget {
  final GroupDetailsState state;

  const _MembersSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final students = state.group.students;
    return TitledSection(
      title: 'Members',
      child: StateTransitionWidget(
        state: state,
        isEmpty: students.isEmpty,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.65,
          ),
          itemCount: students.length,
          itemBuilder: (context, index) {
            return ParticipantCard(participant: students.elementAt(index));
          },
        ),
      ),
    );
  }
}
