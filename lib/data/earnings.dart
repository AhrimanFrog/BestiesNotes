import 'package:besties_notes/data/common.dart';
import 'package:besties_notes/data/report_range.dart';
import 'package:besties_notes/extensions/datetime_ext.dart';
import 'package:besties_notes/data/ui_models/index.dart';
import 'package:equatable/equatable.dart';

/// One amount a student is billed: a single lesson on a per-lesson rate, or
/// one calendar month on a monthly rate.
class Charge extends Equatable {
  final Student student;

  /// The group billed through, or null for individual lessons.
  final int? groupId;

  /// The lesson start, or the first day of the month for a monthly charge.
  final DateTime date;
  final RatePeriod period;
  final double amount;
  final bool isPaid;
  final List<int> lessonIds;

  const Charge({
    required this.student,
    required this.groupId,
    required this.date,
    required this.period,
    required this.amount,
    required this.isPaid,
    required this.lessonIds,
  });

  @override
  List<Object?> get props => [
    student,
    groupId,
    date,
    period,
    amount,
    isPaid,
    lessonIds,
  ];
}

/// Earned / paid / unpaid over a set of charges.
class EarningsSummary extends Equatable {
  final double earned;
  final double paid;

  const EarningsSummary({this.earned = 0, this.paid = 0});

  factory EarningsSummary.of(Iterable<Charge> charges) {
    var earned = 0.0;
    var paid = 0.0;
    for (final c in charges) {
      earned += c.amount;
      if (c.isPaid) paid += c.amount;
    }
    return EarningsSummary(earned: earned, paid: paid);
  }

  double get unpaid => earned - paid;

  bool get isEmpty => earned == 0;

  @override
  List<Object?> get props => [earned, paid];
}

/// Turns participations into charges.
///
/// - Per-lesson rate: every billable lesson is a charge, attended or not.
/// - Monthly rate: one charge per calendar month with at least one billable
///   lesson, separately for individual lessons and each group. It's paid once
///   all of that month's lessons are marked paid, and priced at the month's
///   latest rate.
abstract final class Earnings {
  static List<Charge> charges(Iterable<Participation> participations) {
    final charges = <Charge>[];
    final months = <(int, int?, int, int), List<Participation>>{};

    for (final p in participations) {
      switch (p.rate.period) {
        case RatePeriod.perLesson:
          charges.add(
            Charge(
              student: p.student,
              groupId: p.groupId,
              date: p.start,
              period: RatePeriod.perLesson,
              amount: p.rate.rate,
              isPaid: p.isPaid,
              lessonIds: [p.lessonId],
            ),
          );
        case RatePeriod.monthly:
          months
              .putIfAbsent((
                p.student.id!,
                p.groupId,
                p.start.year,
                p.start.month,
              ), () => [])
              .add(p);
      }
    }

    for (final MapEntry(key: (_, groupId, year, month), value: ps)
        in months.entries) {
      final latest = ps.reduce((a, b) => b.start.isAfter(a.start) ? b : a);
      charges.add(
        Charge(
          student: latest.student,
          groupId: groupId,
          date: DateTime(year, month),
          period: RatePeriod.monthly,
          amount: latest.rate.rate,
          isPaid: ps.every((p) => p.isPaid),
          lessonIds: [for (final p in ps) p.lessonId],
        ),
      );
    }

    charges.sort((a, b) => a.date.compareTo(b.date));
    return charges;
  }

  static EarningsSummary summarize(Iterable<Participation> participations) =>
      EarningsSummary.of(charges(participations));

  /// Per-student totals, highest earnings first.
  static List<StudentEarnings> byStudent(Iterable<Charge> charges) {
    final byId = <int, List<Charge>>{};
    for (final c in charges) {
      byId.putIfAbsent(c.student.id!, () => []).add(c);
    }
    return [
      for (final cs in byId.values)
        StudentEarnings(
          student: cs.first.student,
          lessons: {for (final c in cs) ...c.lessonIds}.length,
          summary: EarningsSummary.of(cs),
        ),
    ]..sort((a, b) => b.summary.earned.compareTo(a.summary.earned));
  }

  /// Splits [range] into weeks (up to about two months) or calendar months,
  /// and totals [charges] into them. Charges dated outside the buckets (a
  /// monthly fee dated the 1st in a mid-month custom range) go to the
  /// nearest one. An all-time range spans the months that have charges.
  static EarningsBuckets buckets(
    List<Charge> charges,
    ReportRange range, {
    required int weekStart,
  }) {
    var (from, to) = (range.from, range.to);
    if (range.preset == RangePreset.allTime) {
      if (charges.isEmpty) {
        return const EarningsBuckets(size: BucketSize.month, buckets: []);
      }
      final first = charges.first.date;
      final last = charges.last.date;
      from = DateTime(first.year, first.month);
      to = DateTime(last.year, last.month + 1);
    }

    final size = to.difference(from).inDays <= 62
        ? BucketSize.week
        : BucketSize.month;
    final starts = <DateTime>[];
    var start = size == BucketSize.week
        ? from.startOfWeek(weekStart)
        : DateTime(from.year, from.month);
    while (start.isBefore(to)) {
      starts.add(start);
      start = size == BucketSize.week
          ? start.addDays(7)
          : DateTime(start.year, start.month + 1);
    }

    final grouped = [for (final _ in starts) <Charge>[]];
    for (final c in charges) {
      var i = starts.lastIndexWhere((s) => !s.isAfter(c.date));
      if (i < 0) i = 0;
      grouped[i].add(c);
    }
    return EarningsBuckets(
      size: size,
      buckets: [
        for (var i = 0; i < starts.length; i++)
          EarningsBucket(
            start: starts[i],
            summary: EarningsSummary.of(grouped[i]),
          ),
      ],
    );
  }
}

class StudentEarnings extends Equatable {
  final Student student;
  final int lessons;
  final EarningsSummary summary;

  const StudentEarnings({
    required this.student,
    required this.lessons,
    required this.summary,
  });

  @override
  List<Object?> get props => [student, lessons, summary];
}

enum BucketSize { week, month }

class EarningsBucket extends Equatable {
  final DateTime start;
  final EarningsSummary summary;

  const EarningsBucket({required this.start, required this.summary});

  @override
  List<Object?> get props => [start, summary];
}

class EarningsBuckets extends Equatable {
  final BucketSize size;
  final List<EarningsBucket> buckets;

  const EarningsBuckets({required this.size, required this.buckets});

  @override
  List<Object?> get props => [size, buckets];
}
