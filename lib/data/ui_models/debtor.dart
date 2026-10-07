import 'package:equatable/equatable.dart';

import 'student.dart';

/// A student with unpaid charges, across all time.
class Debtor extends Equatable {
  final Student debtor;
  final int unpaidLessons;
  final double amountOwed;

  const Debtor({
    required this.debtor,
    required this.unpaidLessons,
    required this.amountOwed,
  });

  @override
  List<Object?> get props => [debtor, unpaidLessons, amountOwed];
}
