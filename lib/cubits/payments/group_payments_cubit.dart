import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'group_payments_state.dart';

class GroupPaymentsCubit extends Cubit<GroupPaymentsState> {
  final PaymentProvider _paymentProvider;
  final DataProvider _dataProvider;

  GroupPaymentsCubit(this._paymentProvider, this._dataProvider)
    : super(const GroupPaymentsState());

  Future<void> load(int groupId) async {
    emit(const GroupPaymentsState(isLoading: true));
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    try {
      final (group, members, unpaidLessons, stat) = await (
        _dataProvider.getGroup(groupId),
        _dataProvider.getGroupMembers(groupId),
        _paymentProvider.getUnpaidLessonsForGroup(groupId),
        _paymentProvider.getPaymentStatForGroup(
          groupId: groupId,
          from: monthStart,
          to: now,
        ),
      ).wait;
      emit(
        GroupPaymentsState(
          group: group.copyWith(students: members.toSet()),
          unpaidLessons: unpaidLessons,
          paidThisMonth: stat.paidLessons,
          totalThisMonth: stat.totalLessons,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
