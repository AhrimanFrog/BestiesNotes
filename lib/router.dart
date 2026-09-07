import 'package:besties_notes/cubits/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/views/group_details_view.dart';
import 'package:besties_notes/views/group_payments_view.dart';
import 'package:besties_notes/views/lessons_history_view.dart';
import 'package:besties_notes/views/modals/lesson_form.dart';
import 'package:besties_notes/views/payments_view.dart';
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
      builder: (context, state, navigationShell) => BlocProvider(
        create: (_) => StudentsAndGroupsCubit(context.read<DataProvider>())
          ..fetchStudents()
          ..fetchGroups(),
        child: MainBottomBar(navigationShell: navigationShell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'schedule',
              path: '/schedule',
              builder: (context, state) => BlocProvider(
                create: (_) =>
                    LessonsCubit(context.read<DataProvider>())..fetchLessons(),
                child: SchedulePage(),
              ),
              routes: [
                GoRoute(
                  name: 'lesson',
                  path: 'lesson/:id',
                  builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) =>
                            LessonsCubit(context.read<DataProvider>())
                              ..fetchLessons(),
                      ),
                      BlocProvider(
                        create: (_) => StudentsAndGroupsCubit(
                          context.read<DataProvider>(),
                        ),
                      ),
                    ],
                    child: LessonForm(null),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'scholars',
              path: '/scholars',
              builder: (context, state) => StudentsPage(),
              routes: [
                GoRoute(
                  name: 'student',
                  path: 'student/:id',
                  builder: (context, state) => BlocProvider(
                    create: (_) =>
                        StudentDetailsCubit(context.read<DataProvider>()),
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
                            LessonsCubit(context.read<DataProvider>())
                              ..fetchLessonsByStudentId(
                                int.parse(state.pathParameters['id']!),
                              ),
                        child: LessonsHistoryView(),
                      ),
                    ),
                    GoRoute(
                      name: 'stud_payments',
                      path: 'payments',
                      builder: (context, state) => BlocProvider(
                        create: (_) => PaymentsCubit(
                          context.read<PaymentProvider>(),
                          context.read<DataProvider>(),
                        ),
                        child: PaymentsView(
                          studentId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  name: 'group',
                  path: 'group/:id',
                  builder: (context, state) => BlocProvider(
                    create: (_) =>
                        GroupDetailsCubit(context.read<DataProvider>()),
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
                            LessonsCubit(context.read<DataProvider>())
                              ..fetchLessonsByGroupId(
                                int.parse(state.pathParameters['id']!),
                              ),
                        child: LessonsHistoryView(),
                      ),
                    ),
                    GoRoute(
                      name: 'group_payments',
                      path: 'payments',
                      builder: (context, state) => BlocProvider(
                        create: (_) => GroupPaymentsCubit(
                          context.read<PaymentProvider>(),
                          context.read<DataProvider>(),
                        ),
                        child: GroupPaymentsView(
                          groupId: int.parse(state.pathParameters['id']!),
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
    ),
  ],
  navigatorKey: _rootNavigatorKey,
);
