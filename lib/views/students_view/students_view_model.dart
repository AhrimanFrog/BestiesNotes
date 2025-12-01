import 'dart:async';

import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentsViewState {
  final List<Student> students;
  final List<Group> groups;

  StudentsViewState({
    required this.students,
    required this.groups,
  });

  StudentsViewState.empty()
      : students = [],
        groups = [];
}

class StudentViewModel extends AsyncNotifier<StudentsViewState> {
  late final ScheduleRepo scheduleRepo;

  @override
  Future<StudentsViewState> build() async {
    scheduleRepo = ref.read(scheduleRepoProvider);
    final students = await scheduleRepo.getAllStudents();
    final groups = await scheduleRepo.getAllGroups();
    return StudentsViewState(students: students, groups: groups);
  }

  Future<void> createOrUpdateStudent(Student student) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await scheduleRepo.createOrUpdateStudent(student);
      final students = await scheduleRepo.getAllStudents();
      final groups = await scheduleRepo.getAllGroups();
      return StudentsViewState(students: students, groups: groups);
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final students = await scheduleRepo.getAllStudents();
      final groups = await scheduleRepo.getAllGroups();
      return StudentsViewState(students: students, groups: groups);
    });
  }
}

final studentViewModelProvider = AsyncNotifierProvider(StudentViewModel.new);
