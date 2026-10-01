import 'package:besties_notes/cubits/lessons/lesson_info_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// One lesson: an overview with instant attendance / payment / homework
/// toggles, and an edit mode (also used to create lessons).
class LessonDetailView extends StatefulWidget {
  const LessonDetailView({super.key});

  @override
  State<LessonDetailView> createState() => _LessonDetailViewState();
}

class _LessonDetailViewState extends State<LessonDetailView> {
  final _formKey = GlobalKey<FormState>();

  LessonInfoCubit get _cubit => context.read<LessonInfoCubit>();

  Future<bool> _save() async {
    final state = _cubit.state;
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    if (state.draft?.subjects.isEmpty ?? true) {
      showErrorSnackBar(context, 'Pick at least one student or group');
      return false;
    }
    final wasNew = state.isNew;
    final saved = await _cubit.save();
    if (!mounted) return saved;
    if (!saved) {
      showErrorSnackBar(context, 'Could not save the lesson');
    } else if (wasNew) {
      context.pop();
    }
    return saved;
  }

  void _discard() {
    if (_cubit.state.isNew) {
      context.pop();
    } else {
      _cubit.discardChanges();
    }
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cancel this lesson?',
      message: 'It stays in the schedule, marked as cancelled.',
      confirmLabel: 'Cancel lesson',
      cancelLabel: 'Keep it',
      destructive: true,
    );
    if (confirmed) await _cubit.setCancelled(true);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this lesson?',
      message: 'Attendance and payment records for it are deleted too.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed) await _cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonInfoCubit, LessonInfoState>(
      listenWhen: (prev, next) =>
          next.isDeleted != prev.isDeleted ||
          (next.error != null && next.error != prev.error),
      listener: (context, state) {
        if (state.isDeleted) {
          context.pop();
        } else if (state.error != null && state.lesson != null) {
          showErrorSnackBar(context, state.error!);
        }
      },
      builder: (context, state) {
        final lesson = state.lesson;
        return DetailScaffold(
          noun: 'lesson',
          isLoaded: lesson != null,
          loadFailed: state.error != null,
          isEditing: state.isEditing,
          isNew: state.isNew,
          isDirty: state.isDirty,
          isSaving: state.isSaving,
          onEdit: _cubit.startEditing,
          onSave: _save,
          onDiscard: _discard,
          menuActions: [
            if (lesson?.isCancelled ?? false)
              DetailMenuAction(
                icon: Icons.restore_rounded,
                label: 'Restore lesson',
                onSelected: () => _cubit.setCancelled(false),
              )
            else
              DetailMenuAction(
                icon: Icons.event_busy_outlined,
                label: 'Cancel lesson',
                onSelected: _confirmCancel,
              ),
            DetailMenuAction(
              icon: Icons.delete_outline_rounded,
              label: 'Delete lesson',
              destructive: true,
              onSelected: _confirmDelete,
            ),
          ],
          viewBuilder: (_) => _LessonOverview(lesson: lesson!),
          editBuilder: (_) =>
              _LessonEditForm(formKey: _formKey, draft: state.draft!),
        );
      },
    );
  }
}

// ─── View mode ───────────────────────────────────────────────────────────────

class _LessonOverview extends StatelessWidget {
  final Lesson lesson;

  const _LessonOverview({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        // Clear the FAB.
        96,
      ),
      children: [
        _HeaderCard(lesson: lesson),
        const SizedBox(height: AppSpacing.xxl),
        _ParticipantsSection(lesson: lesson),
        const SizedBox(height: AppSpacing.xxl),
        Section(
          title: 'Notes',
          child: lesson.note.isEmpty
              ? Text('No notes yet.', style: context.textTheme.bodySmall)
              : AppCard(
                  child: Text(lesson.note, style: context.textTheme.bodyLarge),
                ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Lesson lesson;

  const _HeaderCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cancelled = lesson.isCancelled;
    final timeRange =
        '${lesson.start.formatTime(context)} – ${lesson.end.formatTime(context)}'
        ' · ${lesson.duration.inMinutes} min';

    Widget infoRow(IconData icon, String text) => Row(
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: 18, color: tokens.textMuted),
        Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
      ],
    );

    return AppCard(
      stripeColor: tokens.tone(lesson.statusTone).fg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          StatusBadge(label: lesson.uiLabel, tone: lesson.statusTone),
          Text(
            lesson.name,
            style: context.textTheme.headlineSmall?.copyWith(
              color: cancelled ? tokens.textMuted : null,
              decoration: cancelled ? TextDecoration.lineThrough : null,
            ),
          ),
          infoRow(
            Icons.calendar_today_outlined,
            lesson.start.toLongDateFormat(),
          ),
          infoRow(Icons.schedule_outlined, timeRange),
        ],
      ),
    );
  }
}

class _ParticipantsSection extends StatelessWidget {
  final Lesson lesson;

  const _ParticipantsSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final participants = lesson.participants;
    final cubit = context.read<LessonInfoCubit>();
    final enabled = !lesson.isCancelled;
    final present = participants.where((p) => p.attended).length;
    final paid = participants.where((p) => p.isPaid).length;
    final total = participants.length;

    if (participants.isEmpty) {
      return const Section(
        title: 'Participants',
        child: EmptyState(
          icon: Icons.person_add_alt_outlined,
          title: 'No one assigned',
          message: 'Edit the lesson to add students or groups.',
          compact: true,
        ),
      );
    }

    return Section(
      title: 'Participants',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            '$present/$total present · $paid/$total paid',
            style: context.textTheme.labelMedium,
          ),
          if (enabled)
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.how_to_reg_outlined, size: 18),
                  label: const Text('All present'),
                  onPressed: present == total
                      ? null
                      : () => cubit.markAll(attended: true),
                ),
                ActionChip(
                  avatar: const Icon(Icons.payments_outlined, size: 18),
                  label: const Text('All paid'),
                  onPressed: paid == total
                      ? null
                      : () => cubit.markAll(isPaid: true),
                ),
              ],
            )
          else
            Text(
              'Restore the lesson to track attendance and payments.',
              style: context.textTheme.bodySmall,
            ),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                for (final (group, members) in _bySubject(participants)) ...[
                  if (group != null) _GroupHeader(group: group),
                  for (final p in members)
                    _ParticipantRow(
                      participant: p,
                      indented: group != null,
                      enabled: enabled,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Members of each group together under the group, individuals on their own.
  static List<(Group?, List<LessonParticipant>)> _bySubject(
    List<LessonParticipant> participants,
  ) {
    final byGroup = <int?, List<LessonParticipant>>{};
    final groups = <int?, Group>{};
    final individuals = <LessonParticipant>[];
    for (final p in participants) {
      final group = p.group;
      if (group == null) {
        individuals.add(p);
      } else {
        groups[group.id] = group;
        byGroup.putIfAbsent(group.id, () => []).add(p);
      }
    }
    return [
      for (final MapEntry(:key, :value) in byGroup.entries)
        (groups[key], value),
      if (individuals.isNotEmpty) (null, individuals),
    ];
  }
}

class _GroupHeader extends StatelessWidget {
  final Group group;

  const _GroupHeader({required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          UserAvatar(teachable: group, size: 24),
          Text(group.name, style: context.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final LessonParticipant participant;
  final bool indented;
  final bool enabled;

  const _ParticipantRow({
    required this.participant,
    required this.indented,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LessonInfoCubit>();
    final p = participant;
    final id = p.student.id!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        indented ? AppSpacing.xxl : AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          // Avatar + name open the student's profile.
          Expanded(
            child: InkWell(
              borderRadius: AppRadius.mdAll,
              onTap: () => context.openStudent(id),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  UserAvatar(teachable: p.student, size: 36),
                  Expanded(
                    child: Text(
                      p.student.name,
                      style: context.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tight together so names keep their room; each stays 48dp.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusToggle(
                icon: Icons.how_to_reg_outlined,
                label: 'Present',
                value: p.attended,
                tone: StatusTone.scheduled,
                onChanged: enabled
                    ? (v) => cubit.updateParticipantStatus(id, attended: v)
                    : null,
              ),
              _StatusToggle(
                icon: Icons.payments_outlined,
                label: 'Paid',
                value: p.isPaid,
                tone: StatusTone.done,
                onChanged: enabled
                    ? (v) => cubit.updateParticipantStatus(id, isPaid: v)
                    : null,
              ),
              _StatusToggle(
                icon: Icons.assignment_turned_in_outlined,
                label: 'Homework done',
                value: p.homeworkDone,
                tone: StatusTone.warning,
                onChanged: enabled
                    ? (v) => cubit.updateParticipantStatus(id, homeworkDone: v)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A round icon toggle, filled with its tone when on.
class _StatusToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final StatusTone tone;
  final ValueChanged<bool>? onChanged;

  const _StatusToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.tone(tone);
    final enabled = onChanged != null;

    return Semantics(
      toggled: value,
      label: label,
      child: IconButton(
        tooltip: label,
        isSelected: value,
        onPressed: enabled
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        style: IconButton.styleFrom(
          backgroundColor: value ? colors.bg : Colors.transparent,
          foregroundColor: value ? colors.fg : tokens.textSubtle,
          disabledBackgroundColor: value
              ? colors.bg.withValues(alpha: 0.5)
              : Colors.transparent,
          disabledForegroundColor: tokens.textSubtle.withValues(alpha: 0.5),
          side: value ? null : BorderSide(color: tokens.border),
        ),
        icon: Icon(icon, size: 20),
      ),
    );
  }
}

// ─── Edit mode ───────────────────────────────────────────────────────────────

class _LessonEditForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final LessonDraft draft;

  const _LessonEditForm({required this.formKey, required this.draft});

  @override
  State<_LessonEditForm> createState() => _LessonEditFormState();
}

class _LessonEditFormState extends State<_LessonEditForm> {
  // Seeded once; the draft in the cubit is the source of truth afterwards.
  late final _topic = TextEditingController(text: widget.draft.topic);
  late final _duration = TextEditingController(
    text: '${widget.draft.durationMinutes}',
  );
  late final _note = TextEditingController(text: widget.draft.note);

  LessonInfoCubit get _cubit => context.read<LessonInfoCubit>();

  @override
  void dispose() {
    _topic.dispose();
    _duration.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final start = widget.draft.start;
    final picked = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    _cubit.updateDraft(
      start: DateTime(
        picked.year,
        picked.month,
        picked.day,
        start.hour,
        start.minute,
      ),
    );
  }

  Future<void> _pickTime() async {
    final start = widget.draft.start;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(start),
    );
    if (picked == null) return;
    _cubit.updateDraft(
      start: DateTime(
        start.year,
        start.month,
        start.day,
        picked.hour,
        picked.minute,
      ),
    );
  }

  Future<void> _pickSubjects() async {
    final available = context.read<StudentsAndGroupsCubit>().state;
    final all = <Teachable>[...available.groups, ...available.students];
    if (all.isEmpty) {
      showInfoSnackBar(context, 'No students yet. Add some first.');
      return;
    }
    final selected = await showSubjectPicker(
      context,
      title: 'Who is coming?',
      available: all,
      selected: widget.draft.subjects,
    );
    if (selected != null) _cubit.updateDraft(subjects: selected);
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
          InputField(
            _topic,
            label: 'Topic',
            hint: 'E.g. Present Simple',
            icon: const Icon(Icons.menu_book_outlined),
            onChanged: (v) => _cubit.updateDraft(topic: v),
          ),
          const SizedBox(height: AppSpacing.lg),
          ScholarsSelector(
            label: 'Students & groups',
            selectedSubjects: draft.subjects,
            onTap: _pickSubjects,
            onDeleted: (s) =>
                _cubit.updateDraft(subjects: [...draft.subjects]..remove(s)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: InkWellSelector(
                  title: 'Date',
                  body: draft.start.toMediumDateFormat(),
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
              Expanded(
                child: InkWellSelector(
                  title: 'Time',
                  body: draft.start.formatTime(context),
                  icon: Icons.schedule_outlined,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          InputField(
            _duration,
            label: 'Duration (minutes)',
            hint: '60',
            icon: const Icon(Icons.timer_outlined),
            textInputType: TextInputType.number,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) =>
                _cubit.updateDraft(durationMinutes: int.tryParse(v) ?? 0),
            validator: (value) {
              final minutes = int.tryParse(value ?? '');
              if (minutes == null || minutes <= 0) {
                return 'Enter the length in minutes';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          InputField(
            _note,
            label: 'Notes (optional)',
            icon: const Icon(Icons.notes_outlined),
            maxLines: 4,
            validator: (_) => null,
            onChanged: (v) => _cubit.updateDraft(note: v),
          ),
        ],
      ),
    );
  }
}
