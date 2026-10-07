import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'group_details_state.dart';

/// A group's page: members, lessons and balance, plus an edit mode (also
/// used to create groups).
class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final DataProvider _provider;
  final PaymentProvider _payments;

  GroupDetailsCubit(this._provider, this._payments)
    : super(const GroupDetailsState());

  Future<void> load(int groupId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final (group, lessons, members, unpaid, owed) = await (
        _provider.getGroup(groupId),
        _provider.getLessonsForGroup(groupId),
        _provider.getGroupMembers(groupId),
        _payments.getUnpaidLessonsForGroup(groupId),
        _payments.getParticipations(groupId: groupId, unpaidOnly: true),
      ).wait;

      emit(
        state.copyWith(
          group: group.copyWith(students: members.toSet()),
          lessons: lessons,
          unpaidLessons: unpaid,
          amountOwed: Earnings.summarize(owed).unpaid,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void startNew() {
    const draft = GroupDraft();
    emit(const GroupDetailsState(draft: draft, initialDraft: draft));
  }

  void startEditing() {
    final group = state.group;
    if (group == null || state.isEditing) return;
    final draft = GroupDraft.fromGroup(group);
    emit(state.copyWith(draft: () => draft, initialDraft: () => draft));
  }

  void updateDraft(GroupDraft Function(GroupDraft draft) update) {
    final draft = state.draft;
    if (draft != null) emit(state.copyWith(draft: () => update(draft)));
  }

  void discardChanges() {
    emit(state.copyWith(draft: () => null, initialDraft: () => null));
  }

  /// Returns false (without saving) when the draft is incomplete or the
  /// write fails.
  Future<bool> save() async {
    final draft = state.draft;
    if (draft == null || !draft.isValid || state.isSaving) return false;

    emit(state.copyWith(isSaving: true));
    try {
      final id = await _provider.createOrUpdateGroup(
        draft.toGroup(id: state.group?.id),
      );
      await _provider.syncGroupMemberships(id, [
        for (final m in draft.members) m.id!,
      ]);
      emit(
        state.copyWith(
          draft: () => null,
          initialDraft: () => null,
          isSaving: false,
        ),
      );
      await load(id);
      return true;
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
      return false;
    }
  }

  /// Members stay; they just leave the group.
  Future<void> delete() async {
    final id = state.group?.id;
    if (id == null) return;
    try {
      await _provider.deleteGroup(id);
      emit(state.copyWith(isDeleted: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
