import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/rate_ui_ext.dart';
import 'package:besties_notes/l10n/l10n.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A group's members, balance and lessons; also edits and creates groups.
class GroupDetailsView extends StatefulWidget {
  const GroupDetailsView({super.key});

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  final _formKey = GlobalKey<FormState>();

  GroupDetailsCubit get _cubit => context.read<GroupDetailsCubit>();

  /// Shown data may change on screens opened from here.
  Future<void> _thenReload(Future<void> route) async {
    await route;
    final id = _cubit.state.group?.id;
    if (mounted && id != null) await _cubit.load(id);
  }

  Future<bool> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    if (_cubit.state.draft?.members.isEmpty ?? true) {
      showErrorSnackBar(context, context.l10n.groupNeedsMember);
      return false;
    }
    final wasNew = _cubit.state.isNew;
    final saved = await _cubit.save();
    if (!mounted) return saved;
    if (!saved) {
      showErrorSnackBar(context, context.l10n.groupSaveFailed);
      return false;
    }
    context.read<StudentsAndGroupsCubit>().refresh();
    if (wasNew) context.pop();
    return true;
  }

  void _discard() {
    if (_cubit.state.isNew) {
      context.pop();
    } else {
      _cubit.discardChanges();
    }
  }

  Future<void> _confirmDelete() async {
    final group = _cubit.state.group;
    if (group == null) return;
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteNameTitle(group.name),
      message: l10n.groupDeleteMessage,
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (confirmed) await _cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupDetailsCubit, GroupDetailsState>(
      listenWhen: (prev, next) =>
          next.isDeleted != prev.isDeleted ||
          (next.error != null && next.error != prev.error),
      listener: (context, state) {
        if (state.isDeleted) {
          context.read<StudentsAndGroupsCubit>().refresh();
          context.pop();
        } else if (state.error != null && state.group != null) {
          showErrorSnackBar(context, state.error!);
        }
      },
      builder: (context, state) {
        final l10n = context.l10n;
        return DetailScaffold(
          texts: DetailTexts(
            newTitle: l10n.groupNew,
            editTitle: l10n.groupEdit,
            createLabel: l10n.groupCreate,
            notFound: l10n.groupNotFound,
          ),
          isLoaded: state.group != null,
          loadFailed: state.error != null,
          isEditing: state.isEditing,
          isNew: state.isNew,
          isDirty: state.isDirty,
          isSaving: state.isSaving,
          onEdit: _cubit.startEditing,
          onSave: _save,
          onDiscard: _discard,
          menuActions: [
            DetailMenuAction(
              icon: Icons.delete_outline_rounded,
              label: l10n.groupDelete,
              destructive: true,
              onSelected: _confirmDelete,
            ),
          ],
          viewBuilder: (_) => _Overview(state: state, thenReload: _thenReload),
          editBuilder: (_) =>
              _GroupEditForm(formKey: _formKey, draft: state.draft!),
        );
      },
    );
  }
}

// ─── View mode ───────────────────────────────────────────────────────────────

class _Overview extends StatelessWidget {
  final GroupDetailsState state;
  final Future<void> Function(Future<void> route) thenReload;

  const _Overview({required this.state, required this.thenReload});

  @override
  Widget build(BuildContext context) {
    final group = state.group!;
    final id = group.id!;
    final members = group.students;
    final owed = state.amountOwed;
    final unpaid = state.unpaidLessons.length;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        96, // Clear the FAB.
      ),
      children: [
        AppCard(
          child: Row(
            spacing: AppSpacing.lg,
            children: [
              UserAvatar(teachable: group, size: 72),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(group.name, style: context.textTheme.titleLarge),
                    Text(
                      l10n.memberCount(members.length),
                      style: context.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    StatusBadge(
                      label: group.pricing.label(l10n),
                      tone: StatusTone.accent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Section(
          title: l10n.commonBalance,
          actionLabel: l10n.commonPayments,
          onAction: () => thenReload(context.openGroupPayments(id)),
          child: AppCard(
            child: StatRow(
              icon: Icons.account_balance_wallet_outlined,
              tone: owed > 0 ? StatusTone.warning : StatusTone.done,
              label: owed > 0
                  ? l10n.groupOwedFor(unpaid)
                  : l10n.commonNothingOwed,
              value: owed > 0 ? formatAmount(owed) : '—',
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Section(
          title: l10n.commonMembers,
          child: members.isEmpty
              ? EmptyState(
                  icon: Icons.group_add_outlined,
                  title: l10n.groupNoMembersYet,
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
                          onTap: () =>
                              thenReload(context.openStudent(student.id!)),
                        ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        RecentLessonsSection(
          lessons: state.lessons,
          onSeeAll: () => thenReload(context.openGroupHistory(id)),
          onLessonTap: (lesson) => thenReload(context.openLesson(lesson.id!)),
        ),
      ],
    );
  }
}

// ─── Edit mode ───────────────────────────────────────────────────────────────

class _GroupEditForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final GroupDraft draft;

  const _GroupEditForm({required this.formKey, required this.draft});

  @override
  State<_GroupEditForm> createState() => _GroupEditFormState();
}

class _GroupEditFormState extends State<_GroupEditForm> {
  // Seeded once; the draft in the cubit is the source of truth afterwards.
  late final _name = TextEditingController(text: widget.draft.name);
  late final _rate = TextEditingController(text: widget.draft.rateInput);

  GroupDetailsCubit get _cubit => context.read<GroupDetailsCubit>();

  @override
  void dispose() {
    _name.dispose();
    _rate.dispose();
    super.dispose();
  }

  Future<void> _pickMembers() async {
    final students = context.read<StudentsAndGroupsCubit>().state.students;
    if (students.isEmpty) {
      showInfoSnackBar(context, context.l10n.noStudentsAddFirst);
      return;
    }
    final selected = await showSubjectPicker(
      context,
      title: context.l10n.commonMembers,
      available: students,
      selected: widget.draft.members,
    );
    if (selected != null) {
      _cubit.updateDraft(
        (d) => d.copyWith(members: selected.cast<Student>().toList()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;

    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.xxl,
        ),
        children: [
          AvatarPickerField(
            avatarPath: draft.iconPath,
            defaultIcon: Icons.groups_outlined,
            onChanged: (path) =>
                _cubit.updateDraft((d) => d.copyWith(iconPath: () => path)),
          ),
          const SizedBox(height: AppSpacing.xl),
          InputField(
            _name,
            label: context.l10n.groupName,
            hint: context.l10n.groupNameHint,
            icon: const Icon(Icons.groups_outlined),
            onChanged: (v) => _cubit.updateDraft((d) => d.copyWith(name: v)),
          ),
          const SizedBox(height: AppSpacing.lg),
          RatePeriodField(
            rateController: _rate,
            selectedPeriod: draft.period,
            onRateChanged: (v) =>
                _cubit.updateDraft((d) => d.copyWith(rateInput: v)),
            onPeriodChanged: (p) =>
                _cubit.updateDraft((d) => d.copyWith(period: p)),
          ),
          const SizedBox(height: AppSpacing.lg),
          ScholarsSelector(
            label: context.l10n.commonMembers,
            selectedSubjects: draft.members,
            onTap: _pickMembers,
            onDeleted: (s) => _cubit.updateDraft(
              (d) => d.copyWith(
                members: [
                  for (final m in d.members)
                    if (m.id != s.id) m,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
