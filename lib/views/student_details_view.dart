import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/extensions/lesson_ui_ext.dart';
import 'package:besties_notes/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsView extends StatefulWidget {
  final Student student;

  const StudentDetailsView({super.key, required this.student});

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  @override
  void initState() {
    super.initState();
    if (widget.student.id != null) {
      context.read<StudentDetailsCubit>().loadStudent(widget.student.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {}, // TODO: open student edit form
          ),
        ],
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _HeaderCard(student: student),
            const SizedBox(height: 12),
            _NavigationChipsRow(student: student),
            const SizedBox(height: 20),
            _RecentLessonsSection(),
          ],
        ),
      ),
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

  Widget _chip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, size: 16, color: color),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          if (student.group != null)
            _chip(
              icon: Icons.group_outlined,
              label: student.group!.name,
              color: AppColors.accentPink,
              onTap: () {}, // TODO: navigate to group details
            ),
          _chip(
            icon: Icons.payments_outlined,
            label: 'Payments',
            color: AppColors.accentGreen,
            onTap: () {}, // TODO: navigate to payments page
          ),
          _chip(
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

// ─── Recent lessons ──────────────────────────────────────────────────────────

class _RecentLessonsSection extends StatelessWidget {
  const _RecentLessonsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent lessons',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.mainText,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<StudentDetailsCubit, StudentDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Text(
                state.error!,
                style: const TextStyle(color: AppColors.secondaryText),
              );
            }
            if (state.lessons.isEmpty) {
              return const Text(
                'No lessons yet',
                style: TextStyle(color: AppColors.secondaryText),
              );
            }

            return Column(
              children: [
                for (final lesson in state.lessons.take(3))
                  _CompactLessonTile(lesson: lesson),
                if (state.lessons.length > 3)
                  SeeAllRow(
                    onTap: () {}, // TODO: navigate to lesson history
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CompactLessonTile extends StatelessWidget {
  final Lesson lesson;

  const _CompactLessonTile({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final color = lesson.accentColor;
    final isCancelled = lesson.isCancelled;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    lesson.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainText,
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    '${lesson.start.toDateFormat()}  ${lesson.start.toHoursAndMinsFormat()}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            StatusBadge(
              label: lesson.status.label(isNow: lesson.isNow),
              accentColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
