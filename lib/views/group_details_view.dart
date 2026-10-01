import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
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
    cubit.load(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () async {
                  // Edit through the shell's cubit so the groups list
                  // updates too, then reload this screen.
                  await showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<StudentsAndGroupsCubit>(),
                      child: GroupForm(state.group),
                    ),
                    useSafeArea: true,
                    isScrollControlled: true,
                    useRootNavigator: true,
                  );
                  if (context.mounted) {
                    context.read<GroupDetailsCubit>().load(widget.groupId);
                  }
                },
              ),
            ],
          ),
          body: StateTransitionWidget(
            state: state,
            isEmpty: false,
            onRetry: () => context.read<GroupDetailsCubit>().load(widget.groupId),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.xxxl,
              ),
              children: [
                _GroupHeaderCard(group: state.group),
                const SizedBox(height: AppSpacing.md),
                _NavigationChipsRow(groupId: widget.groupId),
                const SizedBox(height: AppSpacing.xxl),
                _MembersSection(members: state.group.students),
                const SizedBox(height: AppSpacing.xxl),
                RecentLessonsSection(
                  lessons: state.lessons,
                  onSeeAll: () => context.pushNamed(
                    'group_lessons_history',
                    pathParameters: {'id': '${widget.groupId}'},
                  ),
                  onLessonTap: (lesson) async {
                    await context.openLesson(lesson.id!);
                    if (context.mounted) {
                      context.read<GroupDetailsCubit>().load(widget.groupId);
                    }
                  },
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
    final count = group.students.length;
    return AppCard(
      child: Row(
        spacing: AppSpacing.lg,
        children: [
          UserAvatar(teachable: group, size: 64),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(group.name, style: context.textTheme.titleLarge),
                Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 14,
                      color: context.tokens.textMuted,
                    ),
                    Text(
                      count == 1 ? '1 member' : '$count members',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
                StatusBadge(
                  label: group.pricing.toString(),
                  tone: StatusTone.accent,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: NavigationChip(
        icon: Icons.payments_outlined,
        label: 'Payments',
        tone: StatusTone.done,
        onTap: () => context.pushNamed(
          'group_payments',
          pathParameters: {'id': '$groupId'},
        ),
      ),
    );
  }
}

// ─── Members ─────────────────────────────────────────────────────────────────

class _MembersSection extends StatelessWidget {
  final Set<Student> members;

  const _MembersSection({required this.members});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Members',
      child: members.isEmpty
          ? const EmptyState(
              icon: Icons.group_add_outlined,
              title: 'No members yet',
              compact: true,
            )
          : AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                children: [
                  for (final student in members)
                    ListTile(
                      leading: UserAvatar(teachable: student, size: 40),
                      title: Text(student.name),
                      subtitle: student.contact.isNotEmpty
                          ? Text(student.contact)
                          : null,
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.go('/scholars/student/${student.id}'),
                    ),
                ],
              ),
            ),
    );
  }
}
