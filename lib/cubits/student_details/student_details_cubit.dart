import 'package:besties_notes/cubits/cubit_state.dart';
import 'package:besties_notes/data/earnings.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:besties_notes/providers/index.dart';
import 'package:besties_notes/providers/payment_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'student_details_state.dart';

/// A student's profile: lessons and balance, plus an edit mode (also used to
/// create students).
class StudentDetailsCubit extends Cubit<StudentDetailsState> {
  final DataProvider _provider;
  final PaymentProvider _payments;

  StudentDetailsCubit(this._provider, this._payments)
    : super(const StudentDetailsState());

  Future<void> load(int studentId) async {
    emit(state.copyWith(isLoading: true));
    final now = DateTime.now();
    try {
      final (student, lessons, unpaid, month, owed) = await (
        _provider.getStudent(studentId),
        _provider.getLessonsForStudent(studentId),
        _payments.getUnpaidLessonsForStudent(studentId),
        _payments.getPaymentStatForPeriod(
          studentId: studentId,
          from: DateTime(now.year, now.month),
          to: now,
        ),
        _payments.getParticipations(studentId: studentId, unpaidOnly: true),
      ).wait;
      emit(
        state.copyWith(
          student: student,
          lessons: lessons,
          unpaidLessons: unpaid,
          paidThisMonth: month.paidLessons,
          totalThisMonth: month.totalLessons,
          amountOwed: Earnings.summarize(owed).unpaid,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void startNew() {
    const draft = StudentDraft();
    emit(const StudentDetailsState(draft: draft, initialDraft: draft));
  }

  void startEditing() {
    final student = state.student;
    if (student == null || state.isEditing) return;
    final draft = StudentDraft.fromStudent(student);
    emit(state.copyWith(draft: () => draft, initialDraft: () => draft));
  }

  void updateDraft(StudentDraft Function(StudentDraft draft) update) {
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
      final id = await _provider.createOrUpdateStudent(
        draft.toStudent(id: state.student?.id),
      );
      // Leave edit mode, keep showing the old data until the reload lands.
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

  Future<void> delete() async {
    final id = state.student?.id;
    if (id == null) return;
    try {
      await _provider.deleteStudent(id);
      emit(state.copyWith(isDeleted: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
