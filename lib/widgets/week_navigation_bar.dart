import 'package:besties_notes/common/app_colors.dart';
import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeekNavigationBar extends StatelessWidget {
  const WeekNavigationBar({super.key});

  String _formatDate(DateTime date) => '${date.day}.${date.month}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        final cubit = context.read<LessonsCubit>();
        final from = state.dateFrom;
        // dateTo is exclusive (midnight after the last day), display dateTo - 1 day
        final to = state.dateTo.subtract(const Duration(days: 1));
        final label = '${_formatDate(from)} – ${_formatDate(to)}';

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              color: AppColors.accentPink,
              onPressed: cubit.goToPreviousWeek,
            ),
            GestureDetector(
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(start: from, end: to),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.accentPink,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: AppColors.mainText,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (range != null) {
                  cubit.fetchLessons(
                    from: range.start,
                    to: range.end.add(const Duration(days: 1)),
                  );
                }
              },
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainText,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: AppColors.accentPink,
              onPressed: cubit.goToNextWeek,
            ),
          ],
        );
      },
    );
  }
}
