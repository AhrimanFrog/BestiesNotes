import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'payments_state.dart';

/// Payment history of one student, or of a group's lessons: totals for a
/// period, every billable lesson in it, and marking lessons paid.
class PaymentsCubit extends Cubit<PaymentsState> {
  final PaymentProvider _payments;
  final DataProvider _data;
  final int? studentId;
  final int? groupId;

  PaymentsCubit(
    this._payments,
    this._data, {
    this.studentId,
    this.groupId,
    ReportRange? range,
  }) : assert((studentId == null) != (groupId == null)),
       super(
         PaymentsState(range: range ?? ReportRange.preset(RangePreset.allTime)),
       );

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final (subject, inRange, unpaid) = await (
        _subject(),
        _payments.getParticipations(
          from: state.range.from,
          to: state.range.to,
          studentId: studentId,
          groupId: groupId,
        ),
        _payments.getParticipations(
          studentId: studentId,
          groupId: groupId,
          unpaidOnly: true,
        ),
      ).wait;
      emit(
        state.copyWith(
          subject: subject,
          participations: inRange,
          owedAllTime: Earnings.summarize(unpaid).unpaid,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> setRange(ReportRange range) async {
    if (range == state.range) return;
    emit(state.copyWith(range: range));
    await load();
  }

  /// Marks every participant of [entry]'s lesson (in this history) paid, or
  /// unpaid when they all already are. Shown at once; saved after.
  Future<void> togglePaid(PaymentEntry entry) async {
    final isPaid = !entry.isPaid;
    emit(
      state.copyWith(
        participations: [
          for (final p in state.participations)
            p.lessonId == entry.lessonId ? p.copyWith(isPaid: isPaid) : p,
        ],
      ),
    );
    try {
      if (groupId != null) {
        await _data.updateGroupStatuses(
          entry.lessonId,
          groupId!,
          isPaid: isPaid,
        );
      } else {
        await _data.updateParticipantStatus(
          entry.lessonId,
          studentId!,
          isPaid: isPaid,
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
    // Monthly fees and the all-time balance depend on the change.
    await load();
  }

  Future<Teachable> _subject() async {
    if (studentId != null) return _data.getStudent(studentId!);
    final (group, members) = await (
      _data.getGroup(groupId!),
      _data.getGroupMembers(groupId!),
    ).wait;
    return group.copyWith(students: members.toSet());
  }
}
