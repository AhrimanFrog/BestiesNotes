import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/money.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A student's profile, balance and lessons; also edits and creates students.
class StudentDetailsView extends StatefulWidget {
  const StudentDetailsView({super.key});

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  final _formKey = GlobalKey<FormState>();

  StudentDetailsCubit get _cubit => context.read<StudentDetailsCubit>();

  /// Shown data may change on screens opened from here.
  Future<void> _thenReload(Future<void> route) async {
    await route;
    final id = _cubit.state.student?.id;
    if (mounted && id != null) await _cubit.load(id);
  }

  Future<bool> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    final wasNew = _cubit.state.isNew;
    final saved = await _cubit.save();
    if (!mounted) return saved;
    if (!saved) {
      showErrorSnackBar(context, 'Could not save the student');
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
    final name = _cubit.state.student?.name ?? 'this student';
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete $name?',
      message: 'Their lesson history and payments will be removed too.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed) await _cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentDetailsCubit, StudentDetailsState>(
      listenWhen: (prev, next) =>
          next.isDeleted != prev.isDeleted ||
          (next.error != null && next.error != prev.error),
      listener: (context, state) {
        if (state.isDeleted) {
          context.read<StudentsAndGroupsCubit>().refresh();
          context.pop();
        } else if (state.error != null && state.student != null) {
          showErrorSnackBar(context, state.error!);
        }
      },
      builder: (context, state) {
        final student = state.student;
        return DetailScaffold(
          noun: 'student',
          isLoaded: student != null,
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
              label: 'Delete student',
              destructive: true,
              onSelected: _confirmDelete,
            ),
          ],
          viewBuilder: (_) => _Overview(state: state, thenReload: _thenReload),
          editBuilder: (_) =>
              _StudentEditForm(formKey: _formKey, draft: state.draft!),
        );
      },
    );
  }
}

// ─── View mode ───────────────────────────────────────────────────────────────

class _Overview extends StatelessWidget {
  final StudentDetailsState state;
  final Future<void> Function(Future<void> route) thenReload;

  const _Overview({required this.state, required this.thenReload});

  @override
  Widget build(BuildContext context) {
    final student = state.student!;
    final id = student.id!;
    final owed = state.amountOwed;
    final unpaid = state.unpaidLessons.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        96, // Clear the FAB.
      ),
      children: [
        _ProfileCard(
          student: student,
          onGroupTap: (group) => thenReload(context.openGroup(group.id!)),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Section(
          title: 'Balance',
          actionLabel: 'Payments',
          onAction: () => thenReload(context.openStudentPayments(id)),
          child: AppCard(
            child: Column(
              spacing: AppSpacing.md,
              children: [
                StatRow(
                  icon: Icons.account_balance_wallet_outlined,
                  tone: owed > 0 ? StatusTone.warning : StatusTone.done,
                  label: owed > 0
                      ? 'Owes for $unpaid ${unpaid == 1 ? 'lesson' : 'lessons'}'
                      : 'Nothing owed',
                  value: owed > 0 ? formatAmount(owed) : '—',
                ),
                StatRow(
                  icon: Icons.calendar_month_outlined,
                  tone: StatusTone.scheduled,
                  label: 'This month',
                  value: state.totalThisMonth > 0
                      ? '${state.paidThisMonth}/${state.totalThisMonth} paid'
                      : 'No lessons',
                ),
              ],
            ),
          ),
        ),
        if (student.note.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          Section(
            title: 'Notes',
            child: AppCard(
              child: Text(student.note, style: context.textTheme.bodyLarge),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        RecentLessonsSection(
          lessons: state.lessons,
          onSeeAll: () => thenReload(context.openStudentHistory(id)),
          onLessonTap: (lesson) => thenReload(context.openLesson(lesson.id!)),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Student student;
  final ValueChanged<Group> onGroupTap;

  const _ProfileCard({required this.student, required this.onGroupTap});

  @override
  Widget build(BuildContext context) {
    final muted = context.tokens.textMuted;
    final group = student.group;

    return AppCard(
      child: Row(
        spacing: AppSpacing.lg,
        children: [
          UserAvatar(teachable: student, size: 72),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(student.name, style: context.textTheme.titleLarge),
                if (student.contact.isNotEmpty)
                  Row(
                    spacing: AppSpacing.xs,
                    children: [
                      Icon(Icons.phone_outlined, size: 14, color: muted),
                      Flexible(
                        child: Text(
                          student.contact,
                          style: context.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusBadge(
                      label: student.pricing.toString(),
                      tone: StatusTone.accent,
                    ),
                    if (group != null)
                      NavigationChip(
                        icon: Icons.groups_outlined,
                        label: group.name,
                        tone: StatusTone.scheduled,
                        onTap: () => onGroupTap(group),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Edit mode ───────────────────────────────────────────────────────────────

class _StudentEditForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final StudentDraft draft;

  const _StudentEditForm({required this.formKey, required this.draft});

  @override
  State<_StudentEditForm> createState() => _StudentEditFormState();
}

class _StudentEditFormState extends State<_StudentEditForm> {
  // Seeded once; the draft in the cubit is the source of truth afterwards.
  late final _name = TextEditingController(text: widget.draft.name);
  late final _contact = TextEditingController(text: widget.draft.contact);
  late final _rate = TextEditingController(text: widget.draft.rateInput);
  late final _note = TextEditingController(text: widget.draft.note);

  StudentDetailsCubit get _cubit => context.read<StudentDetailsCubit>();

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _rate.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final groups = context.select((StudentsAndGroupsCubit c) => c.state.groups);

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
            defaultIcon: Icons.person_outline_rounded,
            onChanged: (path) =>
                _cubit.updateDraft((d) => d.copyWith(iconPath: () => path)),
          ),
          const SizedBox(height: AppSpacing.xl),
          InputField(
            _name,
            label: 'Name',
            hint: 'E.g. Anna Kovalenko',
            icon: const Icon(Icons.person_outline_rounded),
            onChanged: (v) => _cubit.updateDraft((d) => d.copyWith(name: v)),
          ),
          const SizedBox(height: AppSpacing.lg),
          InputField(
            _contact,
            label: 'Contact (optional)',
            hint: 'Phone number or messenger handle',
            icon: const Icon(Icons.phone_outlined),
            validator: (_) => null,
            onChanged: (v) => _cubit.updateDraft((d) => d.copyWith(contact: v)),
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
          DropdownButtonFormField<int?>(
            initialValue: draft.group?.id,
            // Dropdowns default to titleMedium, the display font here.
            style: context.textTheme.bodyLarge,
            decoration: const InputDecoration(
              labelText: 'Group',
              prefixIcon: Icon(Icons.groups_outlined),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('No group')),
              for (final g in groups)
                DropdownMenuItem(value: g.id, child: Text(g.name)),
            ],
            onChanged: (id) => _cubit.updateDraft(
              (d) => d.copyWith(
                group: () => groups.where((g) => g.id == id).firstOrNull,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InputField(
            _note,
            label: 'Notes (optional)',
            icon: const Icon(Icons.notes_outlined),
            maxLines: 4,
            validator: (_) => null,
            onChanged: (v) => _cubit.updateDraft((d) => d.copyWith(note: v)),
          ),
        ],
      ),
    );
  }
}
