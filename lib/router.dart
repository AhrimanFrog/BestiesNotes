import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/views/schedule_view.dart';
import 'package:besties_notes/views/student_details_view.dart';
import 'package:besties_notes/views/students_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:besties_notes/widgets/main_bottom_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/schedule',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainBottomBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          // initialLocation: '/schedule',
          routes: [
            GoRoute(
              name: 'schedule',
              path: '/schedule',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        LessonsCubit(context.read<ScheduleRepo>())
                          ..fetchLessons(),
                  ),
                  BlocProvider(
                    create: (_) =>
                        StudentsAndGroupsCubit(context.read<ScheduleRepo>())
                          ..fetchStudents()
                          ..fetchGroups(),
                  ),
                ],
                child: SchedulePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          // initialLocation: '/scholars',
          routes: [
            GoRoute(
              name: 'scholars',
              path: '/scholars',
              builder: (context, state) => BlocProvider(
                create: (_) =>
                    StudentsAndGroupsCubit(context.read<ScheduleRepo>())
                      ..fetchStudents()
                      ..fetchGroups(),
                child: StudentsPage(),
              ),
              routes: [
                GoRoute(
                  name: 'student',
                  path: 'student/:id',
                  builder: (context, state) => BlocProvider(
                    create: (_) =>
                        StudentDetailsCubit(context.read<ScheduleRepo>()),
                    child: StudentDetailsView(
                      studentId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  navigatorKey: _rootNavigatorKey,
);
