import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/router.dart';
import 'package:besties_notes/theme/app_theme.dart';
import 'package:besties_notes/views/modals/student_form.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StudentDetailsView extends StatefulWidget {
  final int studentId;

  const StudentDetailsView({super.key, required this.studentId});

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<StudentDetailsCubit>();
    cubit.load(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentDetailsCubit, StudentDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () async {
                  // Edit through the shell's cubit so the students list
                  // updates too, then reload this screen.
                  await showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<StudentsAndGroupsCubit>(),
                      child: StudentForm(state.student),
                    ),
                    useSafeArea: true,
                    isScrollControlled: true,
                    useRootNavigator: true,
                  );
                  if (context.mounted) {
                    context.read<StudentDetailsCubit>().load(widget.studentId);
                  }
                },
              ),
            ],
          ),
          body: StateTransitionWidget(
            state: state,
            isEmpty: false,
            onRetry: () =>
                context.read<StudentDetailsCubit>().load(widget.studentId),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.xxxl,
              ),
              children: [
                _HeaderCard(student: state.student),
                const SizedBox(height: AppSpacing.md),
                _NavigationChipsRow(student: state.student),
                const SizedBox(height: AppSpacing.xxl),
                RecentLessonsSection(
                  lessons: state.lessons,
                  onSeeAll: () => context.pushNamed(
                    'stud_lessons_history',
                    pathParameters: {'id': '${widget.studentId}'},
                  ),
                  onLessonTap: (lesson) async {
                    await context.openLesson(lesson.id!);
                    if (context.mounted) {
                      context.read<StudentDetailsCubit>().load(
                        widget.studentId,
                      );
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

class _HeaderCard extends StatelessWidget {
  final Student student;

  const _HeaderCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final muted = context.tokens.textMuted;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.lg,
            children: [
              UserAvatar(teachable: student, size: 64),
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
                    StatusBadge(
                      label: student.pricing.toString(),
                      tone: StatusTone.accent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (student.note.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Icon(Icons.notes_outlined, size: 16, color: muted),
                Expanded(
                  child: Text(student.note, style: context.textTheme.bodyMedium),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Navigation chips ────────────────────────────────────────────────────────

class _NavigationChipsRow extends StatelessWidget {
  final Student student;

  const _NavigationChipsRow({required this.student});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          if (student.group != null)
            NavigationChip(
              icon: Icons.group_outlined,
              label: student.group!.name,
              tone: StatusTone.accent,
              onTap: () => context.go('/scholars/group/${student.group!.id}'),
            ),
          NavigationChip(
            icon: Icons.payments_outlined,
            label: 'Payments',
            tone: StatusTone.done,
            onTap: () => context.pushNamed(
              'stud_payments',
              pathParameters: {'id': '${student.id}'},
            ),
          ),
        ],
      ),
    );
  }
}
