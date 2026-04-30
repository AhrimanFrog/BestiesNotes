import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final DataProvider _provider;

  GroupDetailsCubit(this._provider) : super(const GroupDetailsState());

  Future<void> load(int groupId) async {
    emit(const GroupDetailsState(isLoading: true));
    try {
      final (group, lessons, members) = await (
        _provider.getGroup(groupId),
        _provider.getLessonsForGroup(groupId),
        _provider.getGroupMembers(groupId),
      ).wait;

      emit(
        state.copyWith(
          lessons: lessons,
          group: group.copyWith(students: members.toSet()),
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
