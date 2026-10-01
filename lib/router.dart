import 'package:besties_notes/cubits/index.dart';
import 'package:besties_notes/providers/data_provider.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:besties_notes/views/group_details_view.dart';
import 'package:besties_notes/views/group_payments_view.dart';
import 'package:besties_notes/views/lesson_detail_view.dart';
import 'package:besties_notes/views/lessons_history_view.dart';
import 'package:besties_notes/views/payments_view.dart';
import 'package:besties_notes/views/schedule_view.dart';
import 'package:besties_notes/views/student_details_view.dart';
import 'package:besties_notes/views/students_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:besties_notes/widgets/navigation/main_bottom_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Lesson screens are top-level so any tab can open them; they cover the
/// bottom bar.
extension LessonNavigation on BuildContext {
  Future<void> openLesson(int lessonId) => push('/lesson/$lessonId');

  Future<void> createLesson({DateTime? date}) => push(
    Uri(
      path: '/lesson/new',
      queryParameters: date != null
          ? {'date': date.toIso8601String().substring(0, 10)}
          : null,
    ).toString(),
  );
}

final router = GoRouter(
  initialLocation: '/schedule',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      name: 'new_lesson',
      path: '/lesson/new',
      builder: (context, state) => BlocProvider(
        create: (_) => LessonInfoCubit(context.read<DataProvider>())
          ..startNew(
            date: DateTime.tryParse(state.uri.queryParameters['date'] ?? ''),
          ),
        child: const LessonDetailView(),
      ),
    ),
    GoRoute(
      name: 'lesson',
      path: '/lesson/:id',
      builder: (context, state) => BlocProvider(
        create: (_) => LessonInfoCubit(context.read<DataProvider>())
          ..load(int.parse(state.pathParameters['id']!)),
        child: const LessonDetailView(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainBottomBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'schedule',
              path: '/schedule',
              builder: (context, state) => BlocProvider(
                create: (_) =>
                    LessonsCubit(context.read<DataProvider>())..fetchLessons(),
                child: const SchedulePage(),
              ),
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
);
