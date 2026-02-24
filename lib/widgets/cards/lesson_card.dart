import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/widgets/initials_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonCard extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onClick;

  const LessonCard({super.key, required this.lesson, required this.onClick});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _expanded = false;

  // Pull the latest lesson from cubit state so optimistic updates are reflected
  Lesson _currentLesson(LessonsState state) => state.lessons.firstWhere(
    (l) => l.id == widget.lesson.id,
    orElse: () => widget.lesson,
  );

  Color _cardMainColor(Lesson lesson) {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return AppColors.softGrey;
      case LessonStatus.completed:
        return AppColors.softGreen;
      case LessonStatus.scheduled:
        return lesson.isNow ? AppColors.softWarmPink : AppColors.softPastelBlue;
    }
  }

  Color _cardAccentColor(Lesson lesson) {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return AppColors.accentGrey;
      case LessonStatus.completed:
        return AppColors.accentGreen;
      case LessonStatus.scheduled:
        return lesson.isNow ? AppColors.accentPink : AppColors.pastelBlue;
    }
  }

  String _statusLabel(Lesson lesson) {
    switch (lesson.status) {
      case LessonStatus.cancelled:
        return 'Cancelled';
      case LessonStatus.completed:
        return 'Completed';
      case LessonStatus.scheduled:
        return lesson.isNow ? 'In Progress' : 'Scheduled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        final lesson = _currentLesson(state);
        final isCancelled = lesson.isCancelled;
        final opacity = isCancelled ? 0.55 : 1.0;
        final accentColor = _cardAccentColor(lesson);

        return Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              color: _cardMainColor(lesson),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: isCancelled ? 0.2 : 0.5),
                  spreadRadius: isCancelled ? 2 : 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: _buildHeader(lesson, accentColor, isCancelled),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: _expanded
                      ? _buildParticipantList(
                          context,
                          lesson,
                          accentColor,
                          isCancelled,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Lesson lesson, Color accentColor, bool isCancelled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.start.toHoursAndMinsFormat(),
                style: TextStyle(
                  fontSize: 14,
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                lesson.end.toHoursAndMinsFormat(),
                style: TextStyle(
                  fontSize: 13,
                  color: accentColor.withValues(alpha: 0.8),
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Avatar + details
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InitialsCircle(
                  initials: lesson.subjects.first.initials,
                  circleColor: accentColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.subjects.length > 1
                            ? "${lesson.subjects.first.initials} & ${lesson.subjects.length - 1} more"
                            : lesson.subjects.first.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.mainText,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        lesson.name,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 13,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _statusLabel(lesson),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantList(
    BuildContext context,
    Lesson lesson,
    Color accentColor,
    bool isCancelled,
  ) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: accentColor.withValues(alpha: 0.2),
          indent: 14,
          endIndent: 14,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
          child: Column(
            children: [
              if (lesson.participants.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No participants',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                for (final p in lesson.participants)
                  _buildParticipantRow(
                    context,
                    lesson,
                    p,
                    accentColor,
                    isCancelled,
                  ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: widget.onClick,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  color: accentColor,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit lesson',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantRow(
    BuildContext context,
    Lesson lesson,
    LessonParticipant p,
    Color accentColor,
    bool isCancelled,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          InitialsCircle(
            initials: p.student.initials,
            circleColor: accentColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              p.student.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.mainText,
                decoration: isCancelled ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: [
              _glowDot(
                active: p.isPaid,
                activeColor: AppColors.accentGreen,
                icon: Icons.payments_outlined,
                label: 'Paid',
                onTap: isCancelled
                    ? null
                    : () =>
                          context.read<LessonsCubit>().updateParticipantStatus(
                            lesson.id!,
                            p.student.id!,
                            isPaid: !p.isPaid,
                          ),
              ),
              _glowDot(
                active: p.attended,
                activeColor: accentColor,
                icon: Icons.check_circle_outline,
                label: 'Here',
                onTap: isCancelled
                    ? null
                    : () =>
                          context.read<LessonsCubit>().updateParticipantStatus(
                            lesson.id!,
                            p.student.id!,
                            attended: !p.attended,
                          ),
              ),
              _glowDot(
                active: p.homeworkDone,
                activeColor: accentColor,
                icon: Icons.edit_document,
                label: 'Homework',
                onTap: isCancelled
                    ? null
                    : () =>
                          context.read<LessonsCubit>().updateParticipantStatus(
                            lesson.id!,
                            p.student.id!,
                            homeworkDone: !p.homeworkDone,
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glowDot({
    required bool active,
    required Color activeColor,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final color = active
        ? activeColor
        : AppColors.accentGrey.withValues(alpha: 0.4);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: active ? 0.15 : 0.08),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.55),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: active ? color : AppColors.secondaryText,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
