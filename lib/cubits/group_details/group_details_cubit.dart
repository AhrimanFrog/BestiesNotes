import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/repositories/schedule_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final ScheduleRepo _repo;

  GroupDetailsCubit(this._repo) : super(const GroupDetailsState());

  Future<void> loadGroup(int groupId) async {
    emit(const GroupDetailsState(isLoading: true));
    try {
      final group = await _repo.getGroup(groupId);
      final members = await _repo.getGroupMembers(groupId);
      emit(state.copyWith(group: group.copyWith(students: members)));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadLessons(int groupId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final lessons = await _repo.getLessonsForGroup(groupId);
      emit(state.copyWith(lessons: lessons, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
