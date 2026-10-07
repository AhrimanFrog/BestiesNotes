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
import 'package:besties_notes/widgets/navigation/main_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Detail screens are top-level so any tab can open them; they cover the
/// bottom bar. Each future completes when the screen closes.
extension AppNavigation on BuildContext {
  Future<void> openLesson(int lessonId) => push('/lesson/$lessonId');

  Future<void> createLesson({DateTime? date}) => push(
    Uri(
      path: '/lesson/new',
      queryParameters: date != null
          ? {'date': date.toIso8601String().substring(0, 10)}
          : null,
    ).toString(),
  );

  Future<void> openStudent(int id) => push('/student/$id');
  Future<void> createStudent() => push('/student/new');
  Future<void> openStudentPayments(int id) => push('/student/$id/payments');
  Future<void> openStudentHistory(int id) => push('/student/$id/history');

  Future<void> openGroup(int id) => push('/group/$id');
  Future<void> createGroup() => push('/group/new');
  Future<void> openGroupPayments(int id) => push('/group/$id/payments');
  Future<void> openGroupHistory(int id) => push('/group/$id/history');
}

int _id(GoRouterState state) => int.parse(state.pathParameters['id']!);

final router = GoRouter(
  initialLocation: '/schedule',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // ── Lessons ──────────────────────────────────────────────────────────────
    GoRoute(
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
      path: '/lesson/:id',
      builder: (context, state) => BlocProvider(
        create: (_) =>
            LessonInfoCubit(context.read<DataProvider>())..load(_id(state)),
        child: const LessonDetailView(),
      ),
    ),

    // ── Students ─────────────────────────────────────────────────────────────
    GoRoute(
      path: '/student/new',
      builder: (context, state) => BlocProvider(
        create: (_) => StudentDetailsCubit(
          context.read<DataProvider>(),
          context.read<PaymentProvider>(),
        )..startNew(),
        child: const StudentDetailsView(),
      ),
    ),
    GoRoute(
      path: '/student/:id',
      builder: (context, state) => BlocProvider(
        create: (_) => StudentDetailsCubit(
          context.read<DataProvider>(),
          context.read<PaymentProvider>(),
        )..load(_id(state)),
        child: const StudentDetailsView(),
      ),
      routes: [
        GoRoute(
          path: 'history',
          builder: (context, state) => BlocProvider(
            create: (_) =>
                LessonsCubit(context.read<DataProvider>())
                  ..fetchLessonsByStudentId(_id(state)),
            child: const LessonsHistoryView(),
          ),
        ),
        GoRoute(
          path: 'payments',
          builder: (context, state) => BlocProvider(
            create: (_) => PaymentsCubit(
              context.read<PaymentProvider>(),
              context.read<DataProvider>(),
            ),
            child: PaymentsView(studentId: _id(state)),
          ),
        ),
      ],
    ),

    // ── Groups ───────────────────────────────────────────────────────────────
    GoRoute(
      path: '/group/new',
      builder: (context, state) => BlocProvider(
        create: (_) => GroupDetailsCubit(
          context.read<DataProvider>(),
          context.read<PaymentProvider>(),
        )..startNew(),
        child: const GroupDetailsView(),
      ),
    ),
    GoRoute(
      path: '/group/:id',
      builder: (context, state) => BlocProvider(
        create: (_) => GroupDetailsCubit(
          context.read<DataProvider>(),
          context.read<PaymentProvider>(),
        )..load(_id(state)),
        child: const GroupDetailsView(),
      ),
      routes: [
        GoRoute(
          path: 'history',
          builder: (context, state) => BlocProvider(
            create: (_) =>
                LessonsCubit(context.read<DataProvider>())
                  ..fetchLessonsByGroupId(_id(state)),
            child: const LessonsHistoryView(),
          ),
        ),
        GoRoute(
          path: 'payments',
          builder: (context, state) => BlocProvider(
            create: (_) => GroupPaymentsCubit(
              context.read<PaymentProvider>(),
              context.read<DataProvider>(),
            ),
            child: GroupPaymentsView(groupId: _id(state)),
          ),
        ),
      ],
    ),

    // ── Tabs ─────────────────────────────────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainBottomBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
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
              path: '/scholars',
              builder: (context, state) => const StudentsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
