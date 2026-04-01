import 'package:besties_notes/cubits/group_details/group_details_cubit.dart';
import 'package:besties_notes/cubits/lessons/lessons_cubit.dart';
import 'package:besties_notes/cubits/student_details/student_details_cubit.dart';
import 'package:besties_notes/cubits/students_and_groups/students_and_groups_cubit.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:besties_notes/views/group_details_view.dart';
import 'package:besties_notes/views/lessons_history_view.dart';
import 'package:besties_notes/views/schedule_view.dart';
import 'package:besties_notes/views/student_details_view.dart';
import 'package:besties_notes/views/students_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:besties_notes/widgets/navigation/main_bottom_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/schedule',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainBottomBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
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
                  routes: [
                    GoRoute(
                      name: 'stud_lessons_history',
                      path: 'lessons_history',
                      builder: (context, state) => BlocProvider(
                        create: (_) =>
                            LessonsCubit(context.read<ScheduleRepo>())
                              ..fetchLessonsByStudentId(
                                int.parse(state.pathParameters['id']!),
                              ),
                        child: LessonsHistoryView(),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  name: 'group',
                  path: 'group/:id',
                  builder: (context, state) => BlocProvider(
                    create: (_) =>
                        GroupDetailsCubit(context.read<ScheduleRepo>()),
                    child: GroupDetailsView(
                      groupId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      name: 'group_lessons_history',
                      path: 'lessons_history',
                      builder: (context, state) => BlocProvider(
                        create: (_) =>
                            LessonsCubit(context.read<ScheduleRepo>())
                              ..fetchLessonsByGroupId(
                                int.parse(state.pathParameters['id']!),
                              ),
                        child: LessonsHistoryView(),
                      ),
                    ),
                  ],
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
