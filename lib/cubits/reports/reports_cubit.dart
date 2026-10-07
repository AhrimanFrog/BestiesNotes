import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'reports_state.dart';

/// Earnings for a period, plus who owes money overall.
class ReportsCubit extends Cubit<ReportsState> {
  final PaymentProvider _payments;

  ReportsCubit(this._payments, {DateTime? now})
    : super(
        ReportsState(
          range: ReportRange.preset(RangePreset.thisMonth, now: now),
        ),
      );

  /// Reloads the current period. With [quiet], the old figures stay on screen
  /// instead of a spinner (refreshing when the tab is shown again).
  Future<void> load({bool quiet = false}) async {
    if (!quiet) emit(state.copyWith(isLoading: true));
    try {
      final range = state.range;
      final (participations, debtors) = await (
        _payments.getParticipations(from: range.from, to: range.to),
        _payments.getDebtors(),
      ).wait;
      // A newer range was picked while this one loaded.
      if (range != state.range) return;
      emit(
        state.copyWith(
          charges: Earnings.charges(participations),
          debtors: debtors,
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
}
