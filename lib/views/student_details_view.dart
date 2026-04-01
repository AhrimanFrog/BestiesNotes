import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
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
    cubit.loadStudent(widget.studentId);
    cubit.loadLessons(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentDetailsCubit, StudentDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.student.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        StudentsAndGroupsCubit(context.read<ScheduleRepo>()),
                    child: StudentForm(state.student),
                  ),
                ),
              ),
            ],
          ),
          body: GradientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _HeaderCard(student: state.student),
                const SizedBox(height: 12),
                _NavigationChipsRow(student: state.student),
                const SizedBox(height: 20),
                StateTransitionWidget(
                  state: state,
                  child: RecentLessonsSection(
                    lessons: state.lessons,
                    onSeeAll: () => context.pushNamed(
                      'stud_lessons_history',
                      pathParameters: {'id': '${widget.studentId}'},
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

class _HeaderCard extends StatelessWidget {
  final Student student;

  const _HeaderCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 16,
            children: [
              UserAvatar(teachable: student),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainText,
                      ),
                    ),
                    if (student.contact.isNotEmpty)
                      Row(
                        spacing: 4,
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: AppColors.secondaryText,
                          ),
                          Text(
                            student.contact,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    StatusBadge(
                      label: student.pricing.toString(),
                      accentColor: AppColors.accentPink,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (student.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.softPink),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const Icon(
                  Icons.notes_outlined,
                  size: 14,
                  color: AppColors.secondaryText,
                ),
                Expanded(
                  child: Text(
                    student.note,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
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
        spacing: 8,
        children: [
          if (student.group != null)
            NavigationChip(
              icon: Icons.group_outlined,
              label: student.group!.name,
              color: AppColors.accentPink,
              onTap: () => context.go('/scholars/group/${student.group!.id}'),
            ),
          NavigationChip(
            icon: Icons.payments_outlined,
            label: 'Payments',
            color: AppColors.accentGreen,
            onTap: () {}, // TODO: navigate to payments page
          ),
          NavigationChip(
            icon: Icons.route_outlined,
            label: 'Roadmap',
            color: AppColors.pastelBlue,
            onTap: () {}, // TODO: navigate to roadmap page
          ),
        ],
      ),
    );
  }
}
