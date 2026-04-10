import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final PaymentProvider _paymentProvider;
  final DataProvider _dataProvider;

  PaymentsCubit(this._paymentProvider, this._dataProvider)
    : super(const PaymentsState());

  Future<void> load(int studentId) async {
    emit(const PaymentsState(isLoading: true));
    try {
      final student = await _dataProvider.getStudent(studentId);
      final unpaidLessons = await _paymentProvider.getUnpaidLessonsForStudent(
        studentId,
      );
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month);
      final stat = await _paymentProvider.getPaymentStatForPeriod(
        studentID: studentId,
        from: monthStart,
        to: now,
      );
      emit(
        PaymentsState(
          student: student,
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
