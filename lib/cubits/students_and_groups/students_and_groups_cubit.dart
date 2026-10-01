import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'students_and_groups_state.dart';

/// The app-wide list of students and groups (plus what each student owes),
/// with search and filtering. Read-only: detail screens make the changes and
/// the list refreshes afterwards.
class StudentsAndGroupsCubit extends Cubit<StudentsAndGroupsState> {
  final DataProvider _provider;
  final PaymentProvider _payments;

  StudentsAndGroupsCubit(this._provider, this._payments)
    : super(const StudentsAndGroupsState());

  /// Loads every student. A tutor has a few dozen at most, so no paging.
  Future<void> fetchStudents() async {
    emit(state.copyWith(isLoading: true));
    try {
      final (students, debtors) = await (
        _provider.getStudents(),
        _payments.getDebtors(),
      ).wait;
      emit(
        state.copyWith(
          students: students,
          owed: {for (final d in debtors) d.debtor.id!: d.amountOwed},
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchGroups() async {
    emit(state.copyWith(isLoading: true));
    try {
      final groups = await _provider.getGroups();
      final filter = state.filterGroupId;
      emit(
        state.copyWith(
          groups: groups,
          // Drop a filter whose group no longer exists.
          filterGroupId: filter != null && groups.every((g) => g.id != filter)
              ? () => null
              : null,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Reloads both lists, e.g. after a student or group was edited.
  Future<void> refresh() async {
    await fetchGroups();
    await fetchStudents();
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setFilterGroup(int? groupId) {
    emit(state.copyWith(filterGroupId: () => groupId));
  }

  void setActiveTab(int index) => emit(state.copyWith(activeDataIndex: index));
}
