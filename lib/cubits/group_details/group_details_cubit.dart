import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final DataProvider _provider;

  GroupDetailsCubit(this._provider) : super(const GroupDetailsState());

  Future<void> loadGroup(int groupId) async {
    emit(const GroupDetailsState(isLoading: true));
    try {
      final group = await _provider.getGroup(groupId);
      final members = (await _provider.getGroupMembers(groupId)).toSet();
      emit(state.copyWith(group: group.copyWith(students: members)));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadLessons(int groupId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final lessons = await _provider.getLessonsForGroup(groupId);
      emit(state.copyWith(lessons: lessons, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
